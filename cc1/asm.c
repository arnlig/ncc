/* asm.c - inline assembly support                      ncc, the new c compiler

Copyright (c) 2021 Charles E. Youse (charles@gnuless.org). All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

#include "cc1.h"
#include "string.h"
#include "block.h"
#include "symbol.h"
#include "target.h"
#include "regs.h"
#include "insn.h"
#include "asm.h"

/* struct iasms are created, destroyed, and duplicated
   here, but only indirectly via insn_construct() et al. */

struct iasm *asm_new(void)
{
    struct iasm *new;

    new = safe_malloc(sizeof(struct iasm));
    
    REGS_INIT(&new->defs);
    REGS_INIT(&new->uses);
    REGMAPS_INIT(&new->in);
    REGMAPS_INIT(&new->out);
    
    return new;
}

struct iasm *asm_dup(struct iasm *iasm)
{
    struct iasm *new;

    new = asm_new();

    new->text = iasm->text;

    regs_union(&new->defs, &iasm->defs);
    regs_union(&new->uses, &iasm->uses);
    regmaps_dup(&new->in, &iasm->in);
    regmaps_dup(&new->out, &iasm->out);

    new->defs_mem = iasm->defs_mem;
    new->uses_mem = iasm->uses_mem;
    new->defs_cc = iasm->defs_cc;
    
    return new;
}

void asm_free(struct iasm *iasm)
{
    regs_clear(&iasm->defs);
    regs_clear(&iasm->uses);
    regmaps_clear(&iasm->in);
    regmaps_clear(&iasm->out);
}

/* parse the inputs or outputs clauses, filling in
   regs and map. if mem is not 0, then the mem flag
   is allowed and *mem will be set if it's found.
   similarly, if cc is not 0, then the cc flag is
   allowed and *cc will be set accordingly.

   if ASM_IOPUTS_SOLO_REGS is specified, then machine
   registers without accompanying variables are allowed.
   they will appear in the map linked to PSEUDO_REG_NONE. */

typedef int asm_ioputs_flags;   /* ASM_IOPUTS_ */

#define ASM_IOPUTS_SOLO_REGS    ( 0x00000001 )

#define ASM_IOPUTS0(K, B)                                                   \
    do {                                                                    \
        if ((token.text->k == (K)) && (B)) {                                \
            *(B) = TRUE;                                                    \
            lex();                                                          \
            goto next;                                                      \
        }                                                                   \
    } while (0)

static void asm_ioputs(struct regs *regs, struct regmaps *map,
                       bool *mem, bool *cc, asm_ioputs_flags flags)
{
    pseudo_reg machine_reg;
    pseudo_reg reg;
    struct symbol *sym;
    struct regmap *rm;

    lex_match(K_COLON);

    while (token.k == K_IDENT) {
        ASM_IOPUTS0(K_MEM, mem);
        ASM_IOPUTS0(K_CC, cc);

        machine_reg = token.text->reg;

        if (machine_reg == PSEUDO_REG_NONE)
            error(FATAL, "machine register expected (got %t)", token);

        rm = regmaps_lookup(map, machine_reg);

        if (rm)
            error(FATAL, "duplicate machine register");

        lex();

        if ((token.k != K_EQ) && (flags & ASM_IOPUTS_SOLO_REGS))
            reg = PSEUDO_REG_NONE;
        else {
            lex_match(K_EQ);
            lex_expect(K_IDENT);

            sym = symbol_lookup(current_scope, SCOPE_GLOBAL,
                                token.text, S_NORMAL);

            if ((sym == 0) || (sym->ss & (S_CONST | S_TYPEDEF)))
                error(FATAL, "%t does not name a variable", token);

            if (!TYPE_SCALAR(&sym->type))
                error(FATAL, "%t must have scalar type", token);

            reg = symbol_reg(sym);

            if (target->reg_class(reg) != target->reg_class(machine_reg))
                error(FATAL, "%t is in wrong register class", token);

            lex();
            REGS_ADD(regs, reg);
        }

        regmaps_update(map, machine_reg, reg);
next:   ;  
    }
}

/* parse an __asm() statement */

void asm_statement(void)
{
    struct insn *insn;

    lex();
    insn = insn_new(I_ASM);

    if (token.k == K_VOLATILE) {
        insn->flags |= INSN_FLAG_VOLATILE;
        lex();
    }

    lex_match(K_LPAREN);
    lex_expect(K_STRLIT);
    insn->iasm->text = token.text;
    lex();

    if (token.k == K_COLON)
        asm_ioputs(&insn->iasm->uses, &insn->iasm->in,
                   &insn->iasm->uses_mem, 0, 0);

    if (token.k == K_COLON)
        asm_ioputs(&insn->iasm->defs, &insn->iasm->out,
                   &insn->iasm->defs_mem, &insn->iasm->defs_cc,
                   ASM_IOPUTS_SOLO_REGS);

    lex_match(K_RPAREN);
    EMIT(insn);
}

/* invoked right before the target code generator to insert
   I_LOAD/I_STOREs around I_ASM statements to effect the maps
   specified by the statement, and replace the pseudo registers
   corresponding to symbols with target registers in uses/defs. */

#define REWRITE0(MAP, DST, SRC, REGS, WHERE)                                \
    do {                                                                    \
        REGMAPS_FOREACH(rm, &insn->iasm->MAP) {                             \
            if (rm->to == PSEUDO_REG_NONE)                                  \
                continue;                                                   \
                                                                            \
            sym = reg_symbol(rm->to);                                       \
            ts = TYPE_BASE(&sym->type);                                     \
                                                                            \
            EMIT(insn_new(I_MOVE, operand_reg(ts, rm->DST),                 \
                                  operand_reg(ts, rm->SRC)));               \
                                                                            \
            REGS_ADD(&insn->iasm->REGS, rm->from);                          \
            insns_insert_##WHERE(&b->insns, insn, &current_block->insns);   \
        }                                                                   \
    } while (0)

static blocks_iter_ret rewrite0(struct block *b)
{
    struct insn *insn;
    struct regmap *rm;
    struct symbol *sym;
    type_bits ts;

    INSNS_FOREACH(insn, &b->insns) {
        if (insn->op != I_ASM)
            continue;

        current_block = block_new();

        regs_clear(&insn->iasm->uses);
        regs_clear(&insn->iasm->defs);
        REWRITE0(in, from, to, uses, before);
        REWRITE0(out, to, from, defs, after);

        block_free(current_block);
    }

    return BLOCKS_ITER_OK;
}

void asm_rewrite(void)
{
    blocks_iter(rewrite0);
}

/* vi: set ts=4 expandtab: */

/* prop.c - constant propagation                        ncc, the new c compiler

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
#include "insn.h"
#include "block.h"
#include "symbol.h"
#include "dead.h"
#include "fold.h"
#include "algebra.h"
#include "prop.h"
#include "kill.h"
#include "opt.h"

/* constant propagation. if all definitions that reach a use of a register
   were assignments of the same constant to a register, then we can replace
   that use with the constant. we use common formulation as described in,
   e.g., the dragon book (9.4.1 in the 2nd edition).

   we also perform a limited form of conditional propagation: if a block
   has an unconditional successor whose sole function is to compare a
   register with a constant and branch accordingly, and the register is a
   known constant at the exit of the block, then we hoist the comparison
   and branches to the end of the block. constant folding will later resolve
   the branch statically. this simple transformation results in a handful of
   improvements like loop inversion and better code for logical operators.

   finally, we perform static switch() resolution when possible. */

#define CONP_CONSTRUCT(x)   (*(x) = 0)
#define CONP_DESTRUCT(x)    operand_free(*(x))
#define CONP_DUP(dst,src)   ((*(dst)) = operand_dup(*(src)))
#define CONP_SAME(x, y)     ((*(x) == *(y)) || operand_is_same(*(x), *(y)))

static ASSOC_DEFINE_CLEAR(conp, value, CONP_DESTRUCT)
static ASSOC_DEFINE_INSERT(conp, pseudo_reg, reg, value, CONP_CONSTRUCT)
static ASSOC_DEFINE_UNSET(conp, pseudo_reg, reg, value, CONP_DESTRUCT)
static ASSOC_DEFINE_LOOKUP(conp, pseudo_reg, reg)
static ASSOC_DEFINE_DUP(conp, pseudo_reg, reg, value, CONP_DUP)
static ASSOC_DEFINE_MOVE(conp)
static ASSOC_DEFINE_SAME(conp, reg, value, CONP_SAME)

#define CONPS_INITIALIZER(ps)   ASSOC_INITIALIZER(ps)
#define CONPS_INIT(ps)          ASSOC_INIT(ps)
#define CONPS_COUNT(ps)         ASSOC_COUNT(ps)
#define CONPS_FOREACH(p, ps)    ASSOC_FOREACH(p, ps)
#define CONPS_FIRST(ps)         ASSOC_FIRST(ps)
#define CONPS_NEXT(p)           ASSOC_NEXT(p)

/* update conps to reflect reg -> value.
   caller yields ownership of the value */

static void conps_update(struct conps *ps, pseudo_reg reg,
                         struct operand *value)
{
    struct conp *p;

    p = conps_insert(ps, reg);

    if (p->value)
        operand_free(p->value);

    p->value = value;
}

static bool changed;

/* first, reset the state and compute the GEN() set for
   the block: those constant definitions present in the
   block that survive to the end. while we're at it, we
   initialize the OUT() set for the entry block, which
   is NAC for all possible constants. note that we must
   visit the entry_block first for this work properly. */

static blocks_iter_ret prop0(struct block *b)
{
    struct regs defs = REGS_INITIALIZER(defs);
    struct reg *defs_r;
    struct insn *insn;
    struct operand *value;
    pseudo_reg dst;

    CONPS_INIT(&b->prop.in);
    CONPS_INIT(&b->prop.gen);
    CONPS_INIT(&b->prop.out);

    INSNS_FOREACH(insn, &b->insns) {
        if (value = insn_con(insn, &dst)) {
            conps_update(&b->prop.gen, dst, operand_dup(value));
            conps_update(&entry_block->prop.out, dst, 0);
            continue;
        }

        insn_defs_regs(insn, &defs);
    
        REGS_FOREACH(defs_r, &defs)
            conps_unset(&b->prop.gen, defs_r->reg);

        regs_clear(&defs);
    }

    return BLOCKS_ITER_OK;
}

/* now, iterate to solve for IN and OUT.

   IN = merge of all predecessor's OUTs
   OUT = (IN - KILL) union with GEN

   the rules for merging are as follows:

   1. if any predecessor OUT set has marked the register not-a-constant,
      (a conp with a null value), then the register is not-a-constant (NAC).
   2. if a register is a constant in any predecessor's OUT, then all
      predecessors must agree on the constant, or the register is NAC.

   as usual, we converge when the OUT sets do not change in a pass. */

static void merge(struct block *b)
{
    struct conp *pred_p;
    struct conp *in_p;
    struct cessor *pred;
    int n;

    conps_clear(&b->prop.in);

    for (n = 0; pred = block_get_predecessor_n(b, n); ++n) {
        if (n == 0)
            conps_dup(&b->prop.in, &pred->b->prop.out);
        else CONPS_FOREACH(pred_p, &pred->b->prop.out) {
            in_p = conps_lookup(&b->prop.in, pred_p->reg);

            if (in_p == 0)
                conps_update(&b->prop.in, pred_p->reg, 
                                          operand_dup(pred_p->value));
            else
                if ((in_p->value == 0) || (pred_p->value == 0)
                  || !operand_is_same(in_p->value, pred_p->value))
                    conps_update(&b->prop.in, pred_p->reg, 0);
        }
    }
}

static blocks_iter_ret prop1(struct block *b)
{
    struct conps new_out = CONPS_INITIALIZER(new_out);
    struct conp *gen_p;
    struct reg *kill_r;

    if (b == entry_block)
        return BLOCKS_ITER_OK;

    merge(b);
    conps_dup(&new_out, &b->prop.in);

    REGS_FOREACH(kill_r, &b->kill)
        conps_update(&new_out, kill_r->reg, 0);

    CONPS_FOREACH(gen_p, &b->prop.gen)
        conps_update(&new_out, gen_p->reg, operand_dup(gen_p->value));

    if (conps_same(&new_out, &b->prop.out)) {
        conps_clear(&new_out);
        return BLOCKS_ITER_OK;
    } else {
        conps_clear(&b->prop.out);
        conps_move(&b->prop.out, &new_out);
        return BLOCKS_ITER_REITER;
    }
}

/* now, we rewrite, starting with the IN
   state, updating it as we go along. */

static blocks_iter_ret prop2(struct block *b)
{
    struct regs regs = REGS_INITIALIZER(regs);
    struct reg *regs_r;
    struct insn *insn;
    struct operand *value;
    struct conps current = CONPS_INITIALIZER(current);
    struct conp *p;
    pseudo_reg dst;

    conps_dup(&current, &b->prop.in);

    INSNS_FOREACH(insn, &b->insns) {
        if (value = insn_con(insn, &dst)) {
            conps_update(&current, dst, value);
            continue;
        }

        CONPS_FOREACH(p, &current)
            if (p->value && insn_substitute_con(insn, p->reg, p->value))
                changed = TRUE;

        insn_defs_regs(insn, &regs);
    
        REGS_FOREACH(regs_r, &regs)
            conps_unset(&current, regs_r->reg);

        regs_clear(&regs);
    }

    conps_clear(&current);

    return BLOCKS_ITER_OK;
}

/* conditional propagation - see description in top comment. */

static blocks_iter_ret prop3(struct block *b)
{
    struct cessor *succ;
    struct insn *insn;
    struct conp *p;
    pseudo_reg dst;

    if ((succ = block_always_successor(b))
      && (succ->b != b)
      && (INSNS_COUNT(&succ->b->insns) == 1)
      && insn_test_con(INSNS_FIRST(&succ->b->insns), &dst)
      && (p = conps_lookup(&b->prop.out, dst))
      && OPERAND_PURE_CON(p->value)) {
        insn = insn_dup(INSNS_FIRST(&succ->b->insns));
        insn_substitute_con(insn, p->reg, p->value);
        BLOCK_APPEND_INSN(b, insn);
        block_dup_successors(b, succ->b);
        changed = TRUE;
    }

    return BLOCKS_ITER_OK;
}

/* static switch() resolution. if the controlling expression
   is a known constant, there's no need to switch. */

static blocks_iter_ret prop4(struct block *b)
{
    struct conp *p;
    struct operand *o;
    struct block *switch_b;

    if (BLOCK_SWITCH(b)) {
        o = b->control;

        if (OPERAND_REG(o) && (p = conps_lookup(&b->prop.out, o->reg)))
            o = p->value;
    
        if (OPERAND_PURE_CON(o)) {
            switch_b = block_switch_lookup(b, o->con.i);
            block_remove_successors(b);
            block_add_successor(b, CC_ALWAYS, switch_b);
            changed = TRUE;
        }
    }

    return BLOCKS_ITER_OK;
}

/* clean up after ourselves */

static blocks_iter_ret prop5(struct block *b)
{
    conps_clear(&b->prop.in);
    conps_clear(&b->prop.gen);
    conps_clear(&b->prop.out);

    return BLOCKS_ITER_OK;
}

void prop(void)
{
    changed = FALSE;

    /* sequence the blocks, partly for efficiency, but
       mostly to ensure that entry_block is hit first by
       prop0, since prop0 initializes its OUT() set. */

    blocks_sequence();

    blocks_iter(prop0);
    kill_analyze();
    blocks_iter(prop1);
    blocks_iter(prop2);
    blocks_iter(prop3);
    blocks_iter(prop4);
    blocks_iter(prop5);

    if (changed) {
        fold();
        dead();
        algebra();
        unreach();
    }
}

/* vi: set ts=4 expandtab: */

/* dead.c - dead store elimination                      ncc, the new c compiler

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
#include "block.h"
#include "symbol.h"
#include "dead.h"
#include "opt.h"

/* the hard work in identifying dead stores is live-variable analysis,
   which is done elsewhere. we have to further qualify them to be sure
   they're not used in instructions with side effects, but that's it.

   I_CALL instructions for functions that return values that are unused
   are not recognized as dead here, because they have side effects. this
   is harmless: we make another pass after the target code is generated
   and the dead store will be eliminated then.

   we don't remove the insns, but rather replace them with I_NOPs. this
   necessitates a subsequent nop() pass, but preserves the live data
   well enough for us to continue eliminations in the current block. */

static bool changed;

static blocks_iter_ret dead0(struct block *b)
{
    struct regs regs = REGS_INITIALIZER(regs);
    struct reg *reg;
    struct range *r;
    struct insn *insn;

    INSNS_FOREACH(insn, &b->insns) {
        if (insn->op == I_NOP) goto skip;
        if (insn_defs_mem(insn)) goto skip;
        if (insn_side_effects(insn)) goto skip;

        insn_defs_regs(insn, &regs);

        if (insn_defs_cc(insn))
            REGS_ADD(&regs, PSEUDO_REG_CC);

        REGS_FOREACH(reg, &regs) {
            r = range_by_def(&b->live, reg->reg, insn->index);
            if (!RANGE_DEAD_STORE(r)) goto skip;
        }
    
        insn_replace(insn, I_NOP);
        changed = TRUE;
skip:
        regs_clear(&regs);
    }

    return BLOCKS_ITER_OK;
}

void dead(void)
{
    bool need_nop = FALSE;

    do {
        changed = FALSE;
        live_analyze();
        blocks_iter(dead0);
            
        if (changed)
            need_nop = TRUE;
    } while (changed);

    if (need_nop)
        nop();
}

/* vi: set ts=4 expandtab: */

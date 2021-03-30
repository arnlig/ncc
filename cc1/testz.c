/* testz.c - zero-test simplification                   ncc, the new c compiler

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

#include <stdio.h>
#include "../common/list.h"
#include "cc1.h"
#include "assoc.h"
#include "block.h"
#include "symbol.h"
#include "dead.h"
#include "testz.h"
#include "opt.h"

/* the only state we need is list of registers that
   have been targets of SETcc instructions. */

ASSOC_DECLARE(setcc, pseudo_reg, reg, condition_code, cc)

#define SETCCS_FIRST(s)     ASSOC_FIRST(s)
#define SETCCS_NEXT(i)      ASSOC_NEXT(i)

static struct setccs setccs = ASSOC_INITIALIZER(setccs);

static ASSOC_DEFINE_LOOKUP(setcc, pseudo_reg, reg)
static ASSOC_DEFINE_INSERT(setcc, pseudo_reg, reg, cc, ASSOC_NULL_CONSTRUCT)
static ASSOC_DEFINE_UNSET(setcc, pseudo_reg, reg, cc, ASSOC_NULL_DESTRUCT)
static ASSOC_DEFINE_CLEAR(setcc, cc, ASSOC_NULL_DESTRUCT)

/* this optimization removes redundancies encountered in tests against
   zero, which abound in C (implicitly). in informal terms, this pass
   will transform an expressions like

                        (((a == 0) != 0) == 0) and
                        (((a > 5) == 0) != 0)

   into
                        (a != 0) and
                        (a <= 5) respectively.

   in other words, it's a form of algebraic simplification, although it
   does not appear that way at first glance. these sorts of expressions
   do arise in user code, especially when hidden through layers of macros,
   but the code generator is worst offender. it naively generates lots of
   expressions like the above, anticipating that this pass will mop up.

   more formally, if we encounter an instruction of the form:

            (1)     $0 := SETcc

   and neither $0 nor the condition codes are affected until we encounter:

            (2)     CMP $0, 0
            (3)     $1 := SET[Z|NZ]

   we can swap the positions of (2) and (3) and rewrite (3) as a function
   of the cc from (1). if this is the only use of the condition_codes from
   (2) then dead() will eliminate (2); we perform the swap instead so that
   that we don't need liveness data ourselves.

   similarly, if instead of (3) there is a conditional Z/NZ branch at the
   end of the block, we can eliminate (2) and rewrite the branch conditions.

   we also recognize that $2 := MOVE $1 where $1 was previously the target
   of (1) and has not been invalidated creates $2 as a synonym of $1. copy
   propagation would pick this up, but we do it here ourselves because it's
   trivial and we avoid introducing the dependency.

   we're working on target-independent code. as such, we must be conservative
   when deciding which instructions (might) affect the condition codes; they
   are often changed in target instructions as part of normal operations. as
   such we don't use insn_defs_cc(), but I_SAFE_CC() instead. */

static bool changed;

static blocks_iter_ret testz0(struct block *b)
{
    struct regs regs = REGS_INITIALIZER(regs);
    struct reg *reg;
    struct setcc *s;
    struct setcc *s2;
    struct insn *insn;
    struct insn *next;
    pseudo_reg dst;
    pseudo_reg src;
    condition_code cc;

restart:
    setccs_clear(&setccs);

    INSNS_FOREACH(insn, &b->insns) {
        regs_clear(&regs);
        insn_defs_regs(insn, &regs);

        REGS_FOREACH(reg, &regs)
            setccs_unset(&setccs, reg->reg);

        regs_clear(&regs);

        if (I_IS_SET_CC(insn->op)) {
            s = setccs_insert(&setccs, insn->dst->reg);
            s->cc = I_CC_FROM_SET_CC(insn->op);
        }

        if (insn_copy(insn, &dst, &src)
          && (s = setccs_lookup(&setccs, src))) {
            s2 = setccs_insert(&setccs, dst);
            s2->cc = s->cc;
        }

        if (insn_test_z(insn, &dst) && (s = setccs_lookup(&setccs, dst))) {
            if (next = INSNS_NEXT(insn)) {
                switch (next->op)
                {
                case I_SET_Z:   cc = CC_INVERT(s->cc); break;
                case I_SET_NZ:  cc = s->cc; break;
                default:        goto skip;
                }
    
                next->op = I_SET_CC_FROM_CC(cc);
                insns_swap(&b->insns, insn);
                changed = TRUE;
                goto restart;
            } 

            if (block_rewrite_zs(b, s->cc)) {
                insns_remove(&b->insns, insn);
                changed = TRUE;
                goto out;
            }
        }

skip:
        if (!I_SAFE_CC(insn->op))
            setccs_clear(&setccs);
    }

out:
    return BLOCKS_ITER_OK;
}

void testz(void)
{
    do {
        changed = FALSE;
        blocks_iter(testz0);
            
        if (changed)
            dead();
    } while (changed);
}

/* vi: set ts=4 expandtab: */

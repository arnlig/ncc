/* copy.c - copy propagation                            ncc, the new c compiler

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
#include "assoc.h"
#include "regs.h"
#include "dead.h"
#include "copy.h"

/* copy propagation: informally, if we see an assignment of the form x = y
   at some point, then we can replace uses of x with y, until either x or y
   is redefined. the hope is that all uses of x will disappear, rendering
   the initial assignment a dead store, saving us time and a register. this
   transformation has an effect very similar to register coalescing. in our
   case, we do copy propagation on the high-level IR and register coalescing
   on the target-specific IR (in the graph allocator, much later). */

#define COPYP_DUP(dst, src)     (*(dst) = *(src))
#define COPYP_SAME(x, y)        (*(x) == *(y))

ASSOC_DECLARE(copyp, pseudo_reg, dst, pseudo_reg, src)

static ASSOC_DEFINE_CLEAR(copyp, dst, ASSOC_NULL_DESTRUCT)
static ASSOC_DEFINE_LOOKUP(copyp, pseudo_reg, dst)
static ASSOC_DEFINE_UNSET(copyp, pseudo_reg, dst, src, ASSOC_NULL_DESTRUCT)
static ASSOC_DEFINE_INSERT(copyp, pseudo_reg, dst, src, ASSOC_NULL_CONSTRUCT)

#define COPYPS_INITIALIZER(cs)      ASSOC_INITIALIZER(cs)
#define COPYPS_INIT(cs)             ASSOC_INIT(cs)
#define COPYPS_FOREACH(c, cs)       ASSOC_FOREACH(c, cs)

static bool changed;

/* update the copyps state to indicate
   that dst is a copy of src */

static void copyps_update(struct copyps *copyps, pseudo_reg dst,
                          pseudo_reg src)
{
    struct copyp *c;

    c = copyps_insert(copyps, dst);
    c->src = src;
}

/* remove all entries that use any
   of regs as either src or dst */

static void copyps_invalidate(struct copyps *copyps, struct regs *regs)
{
    struct reg *r;
    struct copyp *c;

    REGS_FOREACH(r, regs) {
again:
        COPYPS_FOREACH(c, copyps)
            if ((c->dst == r->reg) || (c->src == r->reg)) {
                copyps_unset(copyps, c->dst);
                goto again;
            }
    }
}

static blocks_iter_ret copy0(struct block *b)
{
    struct copyps current = COPYPS_INITIALIZER(current);
    struct regs defs = REGS_INITIALIZER(defs);
    struct insn *insn;
    struct copyp *c;
    pseudo_reg dst;
    pseudo_reg src;

    INSNS_FOREACH(insn, &b->insns) {
        if (insn_copy(insn, &dst, &src))
            copyps_update(&current, dst, src);
        else {
            COPYPS_FOREACH(c, &current)
                if (insn_substitute_reg(insn, c->dst, c->src,
                                        INSN_SUBSTITUTE_USES))
                    changed = TRUE;
            
            insn_defs_regs(insn, &defs);
            copyps_invalidate(&current, &defs);
            regs_clear(&defs);
        }
    }

    copyps_clear(&current);

    return BLOCKS_ITER_OK;
}

void copy(void)
{
    changed = FALSE;

    blocks_iter(copy0);

    if (changed)
        dead();
}

/* vi: set ts=4 expandtab: */

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

#include "../common/slist.h"
#include "cc1.h"
#include "regmaps.h"
#include "insn.h"
#include "block.h"
#include "regs.h"
#include "dead.h"
#include "bitset.h"
#include "output.h"
#include "copy.h"

/* copy propagation: informally, if we see an assignment of the form x = y
   at some point, then we can replace uses of x with y, until either x or y
   is redefined. the hope is that all uses of x will disappear, rendering
   the initial assignment a dead store, saving us time and a register. this
   transformation has an effect very similar to register coalescing. in our
   case, we do copy propagation on the high-level IR and register coalescing
   on the target-specific IR (in the graph allocator, much later). */

static bool changed;

/* local propagation:

   often most of the copy propagation work is local (think: compiler
   temporaries and such) so we do a local-only pass first to reduce
   the amount of computation in the global phase. we then come back
   here to do rewrites after the global computations are complete.
   we track state in a struct regmaps, where (perhaps confusingly)
   from is the destination of a copy operation, and to is the source. */

/* remove all entries that use any of regs */

static void regmaps_invalidate(struct regmaps *m, struct regs *regs)
{
    struct reg *r;
    struct regmap *c;

    REGS_FOREACH(r, regs) {
again:
        REGMAPS_FOREACH(c, m)
            if ((c->from == r->reg) || (c->to == r->reg)) {
                regmaps_unset(m, c->from);
                goto again;
            }
    }
}

/* do local replacements, using regmaps as a starting
   point, and destructively updating it as we go along. */

static void local(struct block *b, struct regmaps *m)
{
    struct regs defs = REGS_INITIALIZER(defs);
    struct insn *insn;
    struct regmap *c;
    pseudo_reg dst;
    pseudo_reg src;

    INSNS_FOREACH(insn, &b->insns) {
        if (insn_copy(insn, &dst, &src))
            regmaps_update(m, dst, src);
        else {
            REGMAPS_FOREACH(c, m)
                if (insn_substitute_reg(insn, c->from, c->to,
                                        INSN_SUBSTITUTE_USES))
                    changed = TRUE;

            insn_defs_regs(insn, &defs, 0);
            regmaps_invalidate(m, &defs);
            regs_clear(&defs);
        }
    }
}

static blocks_iter_ret local0(struct block *b)
{
    struct regmaps m = REGMAPS_INITIALIZER(m);

    local(b, &m);
    regmaps_clear(&m);

    return BLOCKS_ITER_OK;
}

/* global propagation:

   each copy operation in the IR gets an entry in the copies list,
   which records the dst and src regs as well as where the copy
   occurred (the latter two solely to differentiate copies). the
   order of the entries in this list corresponds to the order in
   the bitsets (the first entry is bit 0, the second bit 1, etc.) */

struct copy_insn
{
    pseudo_reg dst;
    pseudo_reg src;
    struct block *b;
    insn_index index;
    SLIST_ENTRY(copy_insn) link;
};

#define COPIES_INITIALIZER()    SLIST_HEAD_INITIALIZER(copies)
#define COPIES_FOREACH(c)       SLIST_FOREACH(c, &copies, link)
#define COPIES_FIRST()          SLIST_FIRST(&copies)
#define COPIES_NEXT(c)          SLIST_NEXT(c, link)
#define COPIES_INSERT_HEAD(c)   SLIST_INSERT_HEAD(&copies, c, link)
#define COPIES_REMOVE_HEAD()    SLIST_REMOVE_HEAD(&copies, link)

static SLIST_HEAD(, copy_insn) copies = COPIES_INITIALIZER();
static int nr_copies;

static int next_copy_bit = -1;  /* see init0() */

/* add a new copy_insn entry to copies. */

static void copies_new(pseudo_reg dst, pseudo_reg src,
                       struct block *b, insn_index index)
{
    struct copy_insn *c;

    c = safe_malloc(sizeof(struct copy_insn));
    c->dst = dst;
    c->src = src;
    c->b = b;
    c->index = index;
    COPIES_INSERT_HEAD(c);
    ++nr_copies;
}

/* free up the copies list, reset state */

static void copies_clear(void)
{
    struct copy_insn *c;

    while (c = COPIES_FIRST()) {
        COPIES_REMOVE_HEAD();
        free(c);
    }

    nr_copies = 0;
    next_copy_bit = -1;
}

/* invalidate all entries in the set that
   reference the register specified */

static void copies_invalidate(struct bitset *bitset, pseudo_reg reg)
{
    struct copy_insn *c;
    int bit = 0;

    COPIES_FOREACH(c) {
        if ((c->dst == reg) || (c->src == reg))
            bitset_reset(bitset, bit);

        ++bit;
    }
}

/* in the first pass, we build the copies list */

static blocks_iter_ret copies0(struct block *b)
{
    struct insn *insn;
    pseudo_reg dst;
    pseudo_reg src;

    INSNS_FOREACH(insn, &b->insns)
        if (insn_copy(insn, &dst, &src))
            copies_new(dst, src, b, insn->index);

    return BLOCKS_ITER_OK;
}

/* in the second pass, we allocate the bit vectors in the
   struct copy of each block, and initialize them:

   IN() = empty for entry_block, all ones for others
   OUT() = empty set
   GEN() = downward-exposed copies from this block
   PRSV() = copies not killed by this block

   we encounter the copies in the same order copies0() did,
   so we can save ourselves a little time looking up the
   copy_insns, instead keeping a counter, next_copy_bit. */

static blocks_iter_ret init0(struct block *b)
{
    struct regs defs = REGS_INITIALIZER(defs);
    struct reg *defs_r;
    struct insn *insn;
    pseudo_reg dst;
    pseudo_reg src;

    bitset_init(&b->copy.in, nr_copies);
    bitset_init(&b->copy.out, nr_copies);
    bitset_init(&b->copy.gen, nr_copies);
    bitset_init(&b->copy.prsv, nr_copies);
    bitset_init(&b->copy.tmp, nr_copies);
    bitset_one_all(&b->copy.prsv);

    if (next_copy_bit == -1)
        next_copy_bit = nr_copies;

    if (b != entry_block)
        bitset_one_all(&b->copy.in);
    
    INSNS_FOREACH(insn, &b->insns) {
        insn_defs_regs(insn, &defs, 0);

        REGS_FOREACH(defs_r, &defs) {
            copies_invalidate(&b->copy.gen, defs_r->reg);
            copies_invalidate(&b->copy.prsv, defs_r->reg);
        }
      
        regs_clear(&defs);

        if (insn_copy(insn, &dst, &src))
            bitset_set(&b->copy.gen, --next_copy_bit);
    }
    
    return BLOCKS_ITER_OK;
}

/* now, solve the forward data-flow problem:

   IN() = intersection of all predecessors' OUT()
   OUT() = union of GEN() with (IN() intersected with PRSV()) */

static blocks_iter_ret copy0(struct block *b)
{
    struct cessor *pred;

    CESSORS_FOREACH(pred, &b->predecessors) {
        if (pred == CESSORS_FIRST(&b->predecessors))
            bitset_copy(&b->copy.in, &pred->b->copy.out);
        else
            bitset_and(&b->copy.in, &pred->b->copy.out);
    }

    bitset_copy(&b->copy.tmp, &b->copy.in);
    bitset_and(&b->copy.tmp, &b->copy.prsv);
    bitset_or(&b->copy.tmp, &b->copy.gen);

    if (bitset_same(&b->copy.tmp, &b->copy.out))
        return BLOCKS_ITER_OK;

    bitset_copy(&b->copy.out, &b->copy.tmp);
    return BLOCKS_ITER_REITER;
}

static blocks_iter_ret rewrite0(struct block *b)
{
    struct regmaps m = REGMAPS_INITIALIZER(regmaps);
    struct copy_insn *c;
    int i;

    for (i = 0, c = COPIES_FIRST(); i < nr_copies; ++i, c = COPIES_NEXT(c))
        if (bitset_get(&b->copy.in, i))
            regmaps_update(&m, c->dst, c->src);

    if (REGMAPS_COUNT(&m)) {
        local(b, &m);
        regmaps_clear(&m);
    }

    return BLOCKS_ITER_OK;
}

/* clean up allocated bitsets */

static blocks_iter_ret clear0(struct block *b)
{
    bitset_clear(&b->copy.in);
    bitset_clear(&b->copy.out);
    bitset_clear(&b->copy.gen);
    bitset_clear(&b->copy.prsv);
    bitset_clear(&b->copy.tmp);

    return BLOCKS_ITER_OK;
}

void copy(void)
{
    changed = FALSE;

    blocks_iter(local0);
    blocks_iter(copies0);

    if (nr_copies > 0) {
        blocks_iter(init0);
        blocks_iter(copy0);
        blocks_iter(rewrite0);
        blocks_iter(clear0);
    }

    copies_clear();

    if (changed)
        dead();
}

/* vi: set ts=4 expandtab: */

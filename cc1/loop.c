/* loop.c - natural loop computation                    ncc, the new c compiler

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
#include "output.h"
#include "dom.h"
#include "stack.h"
#include "loop.h"

/* the usual init/clear for block loop data */

void loop_init(struct loop *loop)
{
    BLKS_INIT(&loop->blks);
    REGS_INIT(&loop->invariants);
    loop->depth = 0;
}

void loop_clear(struct loop *loop)
{
    blks_clear(&loop->blks);
    loop->depth = 0;
}

/* in this analysis, we find natural loops using dominators. once identified,
   each block is assigned a loop depth, indicating its loop nesting level.
   the blocks that comprise each loop are collected into the loop.blks field
   of that loop's header block. when multiple loops share the same header,
   we conservatively assume they are part of the same loop, not nested. */

STACK_DECLARE(bstack, struct block *)
static STACK_DEFINE_PUSH(bstack, struct block *)
static STACK_DEFINE_POP(bstack, struct block *)

static struct bstack bstack = STACK_INITIALIZER(bstack);

/* given a back edge from tail to head, compute the
   blocks that comprise the implied natural loop, and
   add those blocks to the head's loop.blks. */

#define INSERT(b)                                                           \
    do {                                                                    \
        if (!BLKS_CONTAINS(&blks, (b))) {                                   \
            BLKS_ADD(&blks, (b));                                           \
            bstack_push(&bstack, (b));                                      \
        }                                                                   \
    } while (0)

static void loop_blocks(struct block *tail, struct block *head)
{
    struct blks blks = BLKS_INITIALIZER(blks);
    struct cessor *pred;
    struct block *b;
    int n;

    BLKS_ADD(&blks, head);

    if (head != tail) {
        INSERT(tail);

        while (!STACK_EMPTY(&bstack)) {
            b = bstack_pop(&bstack);

            for (n = 0; pred = block_get_predecessor_n(b, n); ++n)
                INSERT(pred->b);
        }
    }

    blks_union(&head->loop.blks, &blks);
    blks_clear(&blks);
}

/* initialize before analysis */

static blocks_iter_ret loop0(struct block *b)
{
    blks_clear(&b->loop.blks);
    b->loop.depth = 0;

    return BLOCKS_ITER_OK;
}

/* invoke loop_blocks() for each back edge from this block */

static blocks_iter_ret loop1(struct block *b)
{
    struct cessor *succ;
    int n;

    for (n = 0; succ = block_get_successor_n(b, n); ++n)
        if (DOMINATES(succ->b, b))
            loop_blocks(b, succ->b);

    return BLOCKS_ITER_OK;
}

/* assign a loop depth to every block */

static blocks_iter_ret loop2(struct block *b)
{
    struct blk *blk_b;

    BLKS_FOREACH(blk_b, &b->loop.blks)
        ++(blk_b->b->loop.depth);

    return BLOCKS_ITER_OK;
}

void loop_analyze(void)
{
    dom_analyze();

    blocks_iter(loop0);
    blocks_iter(loop1);
    blocks_iter(loop2);
}

/* loop-invariant code motion. detect computations which do not
   change in the body of a loop, and hoist them to a preheader. */

static struct block *head_b;    /* head of loop currently being processed */

/* reset data before invariants analysis */

static blocks_iter_ret invariants0(struct block *b)
{
    b->flags &= ~BLOCK_FLAG_LOOPED;
    regs_clear(&b->loop.invariants);
    return BLOCKS_ITER_OK;
}

/* identify the innermost loop 
   that hasn't yet been processed. */

static blocks_iter_ret invariants1(struct block *b)
{
    if (!BLKS_EMPTY(&b->loop.blks) && ((head_b == 0)
      || (b->loop.depth > head_b->loop.depth))
      && !(b->flags & BLOCK_FLAG_LOOPED))
        head_b = b;

    return BLOCKS_ITER_OK;
}

/* if this register has exactly one definition b, and
   that definition domininates any/all uses in b (i.e.,
   the DEF precedes all USEs in b), return the insn
   where the DEF occurred. otherwise return 0. */

static struct insn *unique_def(struct block *b, pseudo_reg reg)
{
    struct regs defs = REGS_INITIALIZER(defs);
    struct regs uses = REGS_INITIALIZER(uses);
    struct insn *insn;
    struct insn *def;
    bool busted;

    def = 0;
    busted = FALSE;

    INSNS_FOREACH(insn, &b->insns) {
        insn_defs_regs(insn, &defs, 0);
        insn_uses_regs(insn, &uses, 0);

        if (REGS_CONTAINS(&uses, reg) && (def == 0))
            busted = TRUE;

        if (REGS_CONTAINS(&defs, reg))
            if (def)
                busted = TRUE;
            else
                def = insn;
        
        regs_clear(&defs);
        regs_clear(&uses);

        if (busted)
            break;
    }

    if (busted)
        return 0;
    else
        return def;
}

static bool loop_move(void)
{
    struct blks all_blks = BLKS_INITIALIZER(all_blks);
    struct blks out_blks = BLKS_INITIALIZER(out_blks);
    struct regs candidates = REGS_INITIALIZER(candidates);
    struct blks out_defs = BLKS_INITIALIZER(out_defs);
    struct blks in_defs = BLKS_INITIALIZER(in_defs);
    struct blks read_blks = BLKS_INITIALIZER(read_blks);
    struct blk *def_b;
    struct insn *def_insn;
    struct reg *cand_r;
    struct reg *next_r;
    struct block *preheader;
    bool changed;
    bool moved;
    
    changed = FALSE;
    live_analyze_ccs(head_b);

    blks_all(&all_blks);
    kill_gather(&all_blks, 0, &candidates);

    blks_all(&out_blks);
    blks_diff(&out_blks, &head_b->loop.blks);

    cand_r = REGS_FIRST(&candidates);
    
    while (cand_r) {
        next_r = REGS_NEXT(cand_r);
    
        kill_gather_blks(cand_r->reg, &out_blks, &out_defs, &read_blks);
        kill_gather_blks(cand_r->reg, &head_b->loop.blks,
                         &in_defs, &read_blks);

        /* if there are definitions inside and outside
           the loop, then we can't say it's invariant. */

        if (!BLKS_EMPTY(&in_defs) && !BLKS_EMPTY(&out_defs))
            goto remove;

        /* if all definitions of this candidate are outside
           the loop, then it's definitely a loop invariant. */

        if (BLKS_EMPTY(&in_defs)) {
            REGS_ADD(&head_b->loop.invariants, cand_r->reg);
            goto remove;
        }

        /* if this register is DEFd in more than one block in
           the loop, then we can't say it's loop invariant. */

        if (BLKS_COUNT(&in_defs) > 1)
            goto remove;

        /* if this register is DEFd more than once in the block, or
           said definition does not dominate all subsequent uses,
           then we can't say it's loop invariant. */

        def_b = BLKS_FIRST(&in_defs);
        def_insn = unique_def(def_b->b, cand_r->reg);

        if (!def_insn || !dominates_all(def_b->b, &read_blks))
            goto remove;

        goto next;

remove:
        regs_remove(&candidates, cand_r->reg);

next:
        blks_clear(&out_defs);
        blks_clear(&in_defs);
        blks_clear(&read_blks);
        cand_r = next_r;
    }

    preheader = 0;

    do {
        moved = FALSE;
        cand_r = REGS_FIRST(&candidates);
        
        while (cand_r) {
            next_r = REGS_NEXT(cand_r);

            kill_gather_blks(cand_r->reg, &head_b->loop.blks, &in_defs, 0);
            def_b = BLKS_FIRST(&in_defs);
            def_insn = unique_def(def_b->b, cand_r->reg);

            if (insn_movable(def_insn, &head_b->loop.invariants)) {
                if (preheader == 0) {
                    preheader = block_preheader(head_b, &head_b->loop.blks);
                    changed = TRUE;
                }

                BLOCK_APPEND_INSN(preheader, insn_dup(def_insn));
                insns_remove(&def_b->b->insns, def_insn);
                regs_remove(&candidates, cand_r->reg);
                REGS_ADD(&head_b->loop.invariants, cand_r->reg);
                moved = TRUE;
            }

            blks_clear(&in_defs);
            cand_r = next_r;
        }
    } while (moved);

    regs_clear(&candidates);
    blks_clear(&all_blks);
    blks_clear(&out_blks);

    return changed;
}

void loop_invariants(void)
{
    bool changed;

    webs_analyze();
    blocks_iter(invariants0);
    changed = TRUE;

    for (;;) {
        if (changed) {
            kill_analyze();
            loop_analyze();
        }

        head_b = 0;
        blocks_iter(invariants1);
        
        if (head_b == 0)
            break;
        else {
            head_b->flags |= BLOCK_FLAG_LOOPED;
            changed = loop_move();
        }
    }

    webs_strip();
}

/* vi: set ts=4 expandtab: */

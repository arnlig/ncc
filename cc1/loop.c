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
#include "dom.h"
#include "stack.h"
#include "loop.h"

/* in this analysis, we find natural loops using dominators. once identified,
   each block is assigned a loop_depth, indicating its loop nesting level.
   the blocks that comprise each loop are collected into the loop_blks field
   of that loop's header block. when multiple loops share the same header,
   we conservatively assume they are part of the same loop, not nested. */

STACK_DECLARE(bstack, struct block *)
static STACK_DEFINE_PUSH(bstack, struct block *)
static STACK_DEFINE_POP(bstack, struct block *)

static struct bstack bstack = STACK_INITIALIZER(bstack);

/* given a back edge from tail to head, compute the
   blocks that comprise the implied natural loop, and
   add those blocks to the head's loop_blks. */

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

    blks_union(&head->loop_blks, &blks);
    blks_clear(&blks);
}

/* initialize before analysis */

static blocks_iter_ret loop0(struct block *b)
{
    b->loop_depth = 0;
    blks_clear(&b->loop_blks);

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

    BLKS_FOREACH(blk_b, &b->loop_blks)
        ++(blk_b->b->loop_depth);

    return BLOCKS_ITER_OK;
}

void loop_analyze(void)
{
    dom_analyze();

    blocks_iter(loop0);
    blocks_iter(loop1);
    blocks_iter(loop2);
}

/* vi: set ts=4 expandtab: */

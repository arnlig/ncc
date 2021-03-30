/* dom.c - dominance relations                          ncc, the new c compiler

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
#include "blks.h"
#include "opt.h"
#include "dom.h"

/* the set of all blocks */

static struct blks blks_all = BLKS_INITIALIZER(blks_all);

/* basic dominators calculation: first, build the set of all blocks;
   next, initialize the state of all blocks- all blocks are dominated
   by all blocks, except the entry block which is dominated only by
   itself. finally, iterate to solve: a block's dominators are itself
   and the intersection of all its predecessors' dominators. */

static blocks_iter_ret dom_analyze0(struct block *b)
{
    BLKS_ADD(&blks_all, b);
    return BLOCKS_ITER_OK;
}

static blocks_iter_ret dom_analyze1(struct block *b)
{
    blks_clear(&b->dominators);
    
    if (b == entry_block)
        BLKS_ADD(&b->dominators, entry_block);
    else
        blks_union(&b->dominators, &blks_all);

    return BLOCKS_ITER_OK;
}

static blocks_iter_ret dom_analyze2(struct block *b)
{
    struct blks tmp = BLKS_INITIALIZER(tmp);
    struct cessor *pred;
    int n;

    pred = block_get_predecessor_n(b, 0);

    if (pred)
        blks_union(&tmp, &pred->b->dominators);

    for (n = 1; pred = block_get_predecessor_n(b, n); ++n)
        blks_intersect(&tmp, &pred->b->dominators);

    BLKS_ADD(&tmp, b);

    if (BLKS_COUNT(&tmp) != BLKS_COUNT(&b->dominators)) {
        blks_clear(&b->dominators);
        blks_move(&b->dominators, &tmp);
        return BLOCKS_ITER_REITER;
    } else {
        blks_clear(&tmp);
        return BLOCKS_ITER_OK;
    }
}

void dom_analyze(void)
{
    unreach();      /* no unreachable blocks allowed */

    blocks_iter(dom_analyze0);
    blocks_iter(dom_analyze1);
    blocks_iter(dom_analyze2);

    blks_clear(&blks_all);
}

/* vi: set ts=4 expandtab: */

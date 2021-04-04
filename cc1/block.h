/* block.h - basic blocks                               ncc, the new c compiler

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

#ifndef BLOCK_H
#define BLOCK_H

#include "../common/tailq.h"
#include "insn.h"
#include "type.h"
#include "live.h"
#include "prop.h"
#include "regs.h"
#include "webs.h"
#include "blks.h"
#include "copy.h"
#include "slvn.h"
#include "amd64/target_block.h"

struct symbol;

/* we assume an architecture with condition codes, which maps nicely onto
   AMD64, ARM, SPARC, i386, 68K, etc. (not so nicely onto MIPS, RISC-V...).
   condition_code is a bit of a misnomer: these are not condition codes,
   but rather the states that can be deduced from them.

   we map unsigned and floating-point comparisons onto the same set of codes.
   this reflects the behavior of both x86 SSE and ARM VFP floating-point; if
   a target comes along that makes this awkward, we can separate them. */

typedef int condition_code;     /* CC_* */

#define CC_Z            0           /* zero/equal */
#define CC_NZ           1           /* not zero/equal */
#define CC_G            2           /* (signed) > */
#define CC_LE           3           /* (signed) <= */
#define CC_GE           4           /* (signed) >= */
#define CC_L            5           /* (signed) < */
#define CC_A            6           /* (unsigned/float) > */
#define CC_BE           7           /* (unsigned/float) <= */
#define CC_AE           8           /* (unsigned/float) >= */
#define CC_B            9           /* (unsigned/float) < */

#define CC_ALWAYS       10
#define CC_NEVER        11

    /* separate the condition_codes that are actually dependent
       on the state of the CPU from the ones that aren't */

#define CC_CONDITIONAL(cc)  ((cc) < CC_ALWAYS)

    /* "real" condition codes are those above, which actually indicate some
       condition, as opposed to the pseudo-CCs below used for switch blocks */

#define CC_NR_REAL      (CC_NEVER + 1)
#define CC_REAL(cc)     ((cc) < CC_NR_REAL)

    /* invert the truth value of a (real) condition_code. notice that the
       values of the CC_* constants are arranged such that opposite meanings
       differ in their lsbs only; this makes CC_INVERT() trivial. */

#define CC_INVERT(cc)       ((cc) ^ 1)

    /* used for controlling block of switch statements, see struct cessor */

#define CC_SWITCH       12
#define CC_DEFAULT      13

    /* sometimes we need to index by condition_codes, e.g., to map them
       onto their equivalent I_SETcc instructions. for the moment the CC_*
       values are agreeable, but they might not always be, so use this. */

#define CC_INDEX(cc)    (cc)

    /* sometimes it's useful to group all condition_codes as a set */

typedef int ccset;

#define CCSET_CLEAR(s)          ((s) = 0)
#define CCSET_SET(s, cc)        ((s) |= 1 << CC_INDEX(cc))
#define CCSET_IS_SET(s, cc)     ((s) & (1 << CC_INDEX(cc)))

/* for simplicity we track both successors and predecessors with cessors.
   for successors of a given block, the condition_codes must be exclusive
   and exhaustive. for predecessors, the code is meaningless- use CC_NEVER.

   CC_SWITCH is the oddball here. if the successors are switch cases, then
   the first successor will be CC_DEFAULT, the rest will be CC_SWITCHes for
   the switch cases, and the block control field will be set.

   since switching is fundamentally a test of equality, signedness in the
   ranges has little relevance: we treat all case values as unsigned. */

struct cessor
{
    condition_code cc;
    struct block *b;

    unsigned long min;      /* minimum and maximum values ... */
    unsigned long max;      /* ... in a CC_SWITCH, inclusive */

    TAILQ_ENTRY(cessor) links;
};

TAILQ_HEAD(cessors, cessor);

#define CESSORS_INIT(cs)            TAILQ_INIT(cs)
#define CESSORS_REMOVE(cs, c)       TAILQ_REMOVE(cs, c, links)
#define CESSORS_APPEND(cs, c)       TAILQ_INSERT_TAIL(cs, c, links)
#define CESSORS_FIRST(cs)           TAILQ_FIRST(cs)
#define CESSORS_NEXT(cs)            TAILQ_NEXT(cs, links)
#define CESSORS_FOREACH(c, cs)      TAILQ_FOREACH(c, cs, links)

#define CESSORS_INSERT_AFTER(cs, aft, c)  TAILQ_INSERT_AFTER(cs, aft, c, links)

/* a struct block represents a sequence of insns which can only be entered
   at the beginning and only exited at the end, i.e., a basic block. */

typedef int block_flags;    /* BLOCK_FLAG_* */

#define BLOCK_FLAG_VISITED  ( 0x00000001 )  /* already visited this walk */

struct block
{
    asm_label label;
    block_flags flags;

    struct insns insns;

    struct live live;               /* live-variable data */
    struct regs kill;               /* register kill set */
    struct prop prop;               /* constant propagation data */
    struct copy copy;               /* copy propagation data */
    struct lvns lvns;               /* value numbering data */
    struct operand *control;        /* controlling value of switch block */
    struct webs webs;               /* allocatable webs data */
    struct blks dominators;         /* dominators of this block */
    struct blks loop_blks;          /* loop blocks headed by this block */
    int loop_depth;                 /* loop nesting depth */

    struct cessors successors;
    struct cessors predecessors;

    union
    {
        struct amd64_block amd64;
    };

    TAILQ_ENTRY(block) links;
};

TAILQ_HEAD(blocks, block);      /* struct blocks */

#define BLOCKS_INIT(blks)           TAILQ_INIT(blks)
#define BLOCKS_FIRST(blks)          TAILQ_FIRST(blks)
#define BLOCKS_PREPEND(blks, b)     TAILQ_INSERT_HEAD(blks, b, links)
#define BLOCKS_APPEND(blks, b)      TAILQ_INSERT_TAIL(blks, b, links)
#define BLOCKS_REMOVE(blks, b)      TAILQ_REMOVE(blks, b, links)
#define BLOCKS_NEXT(b)              TAILQ_NEXT(b, links)
#define BLOCKS_FOREACH(b, blks)     TAILQ_FOREACH(b, blks, links)

#define BLOCK_VISITED(b)            ((b)->flags & BLOCK_FLAG_VISITED)
#define BLOCK_MARK_VISITED(b)       ((b)->flags |= BLOCK_FLAG_VISITED)
#define BLOCK_MARK_UNVISITED(b)     ((b)->flags &= ~BLOCK_FLAG_VISITED)

/* if a block ends with a switch-based branch */

#define BLOCK_SWITCH(b)             ((b)->control != 0)

/* the CC_DEFAULT block out of a switch */

#define BLOCK_SWITCH_DEFAULT(b)     (CESSORS_FIRST(&(b)->successors)->b)

#define BLOCK_EMPTY(b)      (INSNS_EMPTY(&(b)->insns) && !BLOCK_SWITCH(b))

extern struct block *block_new(void);
extern void block_free(struct block *);
extern bool block_conditional(struct block *);
extern struct block *block_split(struct block *, insn_index);
extern struct block *block_split_edge(struct block *, struct cessor *);

extern struct cessor *block_add_successor(struct block *, condition_code,
                                          struct block *);

extern void block_redirect_successors(struct block *, struct block *,
                                     struct block *);

extern struct cessor *block_get_successor_n(struct block *, int);
extern struct cessor *block_get_predecessor_n(struct block *, int);
extern struct cessor *block_always_successor(struct block *);
extern void block_switch(struct block *, struct tree *, struct block *);
extern void block_switch_case(struct block *, long, struct block *);
extern struct block *block_switch_lookup(struct block *, long);
extern void block_switch_done(struct block *);
extern void block_remove_successor(struct block *, struct cessor *);
extern void block_remove_successors(struct block *);
extern void block_known_ccs(struct block *, ccset ccs);
extern bool block_rewrite_zs(struct block *, condition_code);
extern bool block_substitute_reg(struct block *, pseudo_reg, pseudo_reg);
extern bool blocks_substitute_reg(pseudo_reg, pseudo_reg);
extern void block_dup_successors(struct block *, struct block *);
extern int block_nr_successors(struct block *);
extern int block_nr_predecessors(struct block *);

#define BLOCK_APPEND_INSN(b, i)     insn_append(&((b)->insns), (i))
#define BLOCK_PREPEND_INSN(b, i)    insn_prepend(&((b)->insns), (i))

typedef int blocks_iter_ret;    /* BLOCKS_ITER_* */

#define BLOCKS_ITER_OK          0
#define BLOCKS_ITER_ABORT       1
#define BLOCKS_ITER_REITER      2

extern blocks_iter_ret blocks_iter(blocks_iter_ret (*f)(struct block *));

extern void blocks_walk(void (*)(struct block *), void (*)(struct block *));

extern void blocks_sequence(void);

extern struct symbol *func_sym;
extern struct type func_ret_type;
extern struct symbol *func_strun_ret;
extern struct regs func_regs;
extern struct block *entry_block;
extern struct block *exit_block;
extern struct block *current_block;

#define EMIT(insn)          BLOCK_APPEND_INSN(current_block, (insn))

extern void func_new(struct symbol *);
extern void func_complete(struct symbol *);
extern void func_free(void);

#endif /* BLOCK_H */

/* vi: set ts=4 expandtab: */

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

#include <stdio.h>
#include <stdlib.h>
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
   e.g., the dragon book (9.4.1 in the 2nd edition). we also do a limited
   form of conditional propagation, and, finally, we perform static switch()
   resolution when possible. */

static bool changed;

/* list of all regs DEFd in this function */

static struct regs all_defs = REGS_INITIALIZER(all_defs);

/* map[] is an index -> pseudo_reg map. obviously that's not helpful
   for map[] itself, but its indices are the same as the conps[] tables. */

static pseudo_reg *map;

#define MAP_SIZE        (REGS_COUNT(&all_defs))

/* get the index of the specified reg in map[] (and
   thus any conps[] table), or -1 if not found. */

static int map_compar(const void *r1, const void *r2)
{
    return (*(const pseudo_reg *) r1 - *(const pseudo_reg *) r2);
}

static int map_index(pseudo_reg reg)
{
    pseudo_reg *entry;
    
    entry = bsearch(&reg, map, MAP_SIZE, sizeof(*map), map_compar);
    
    if (entry)
        return entry - map;
    else
        return -1;
}

/* struct conp tracks the state for one register in a table */

typedef int conp_state;     /* CONP_STATE_ */

#define CONP_STATE_DUNNO        0       /* don't know anything about reg */
#define CONP_STATE_CON          1       /* it's a constant, see value */
#define CONP_STATE_NAC          2       /* definitely not constant */

struct conp
{
    conp_state state;
    struct operand *value;      /* if CONP_STATE_CON, 0 otherwise */
};

/* allocate and initialize a new conps[] table */

static struct conp *conps_new(void)
{
    /* safe_malloc zeros the structs, so { CONP_STATE_DUNNO, 0 }
       is the initial state for each entry, which is perfect */

    return safe_malloc(sizeof(struct conp) * MAP_SIZE);
}

/* reset the conps[] state back to all-unknowns */

static void conps_reset(struct conp *conps)
{
    int i;

    for (i = 0; i < MAP_SIZE; ++i) {
        if (conps[i].value)
            operand_free(conps[i].value);

        conps[i].state = CONP_STATE_DUNNO;
        conps[i].value = 0;
    }
}

/* update the conp to the specified state. if
   CONP_STATE_CON, then ownership of value is
   yielded to this function; otherwise use 0. */

static void conp_set(struct conp *conp, conp_state state,
                     struct operand *value)
{
    if (conp->value) {
        operand_free(conp->value);
        conp->value = 0;
    }

    conp->state = state;
    conp->value = value;
}

/* update the conps[] table entry for reg to
   the specified state, a la conp_set */

static void conps_set(struct conp *conps, pseudo_reg reg,
                      conp_state state, struct operand *value)
{
    int index;

    index = map_index(reg);
    conp_set(conps + index, state, value);
}

/* merge a conps[] table with a predecessor's. this
   is the meat of the meet function (no pun intended) */

static void conps_merge(struct conp *to, struct conp *from)
{
    int n;

    for (n = 0; n < MAP_SIZE; ++n, ++to, ++from) {
        if (to->state != CONP_STATE_NAC) {
            switch (from->state)
            {
            case CONP_STATE_DUNNO:  break;

            case CONP_STATE_NAC:
                conp_set(to, CONP_STATE_NAC, 0);
                break;

            case CONP_STATE_CON:
                if (to->state == CONP_STATE_CON) {
                    if (!operand_is_same(to->value, from->value))
                        conp_set(to, CONP_STATE_NAC, 0);
                } else
                    conp_set(to, CONP_STATE_CON, operand_dup(from->value));
            }
        }
    }
}

/* update a conps[] map with a GEN set, i.e., make a
   matching CONP_STATE_CON in to for each one in gen. */

static void conps_merge_gen(struct conp *to, struct conp *gen)
{
    int n;

    for (n = 0; n < MAP_SIZE; ++n, ++gen, ++to)
        if (gen->state == CONP_STATE_CON)
            conp_set(to, CONP_STATE_CON, operand_dup(gen->value));
}

/* kill all the registers in the kill set, in the
   conps[] table, that is, set them to unknown */

static void conps_kill(struct conp *conps, struct regs *kill)
{
    struct reg *r;

    REGS_FOREACH(r, kill)
        conps_set(conps, r->reg, CONP_STATE_NAC, 0);
}

/* if the conps[] table has an entry for reg and it's
   CONP_STATE_CON, then return its value, otherwise 0 */

static struct operand *conps_value(struct conp *conps, pseudo_reg reg)
{
    int index;

    index = map_index(reg);

    if ((index == -1) || (conps[index].state != CONP_STATE_CON))
        return 0;

    return conps[index].value;
}

/* returns TRUE if two conps[] tables are equivalent */

static bool conps_same(struct conp *conps1, struct conp *conps2)
{
    int n;
    
    for (n = 0; n < MAP_SIZE; ++n, ++conps1, ++conps2) {
        if (conps1->state != conps2->state)
            return FALSE;

        if ((conps1->state == CONP_STATE_CON)
          && !operand_is_same(conps1->value, conps2->value))
            return FALSE;
    }

    return TRUE;
}

/* turn dst conps[] into an equivalent of src conps[] */

static void conps_dup(struct conp *dst, struct conp *src)
{
    int n;

    for (n = 0; n < MAP_SIZE; ++n, ++dst, ++src) {
        if (src->state == CONP_STATE_CON)
            conp_set(dst, CONP_STATE_CON, operand_dup(src->value));
        else
            conp_set(dst, src->state, 0);
    }
}

/* set all conps[] entries to CONP_STATE_NAC */

static void conps_poison(struct conp *dst)
{
    int n;

    for (n = 0; n < MAP_SIZE; ++n, ++dst)
        conp_set(dst, CONP_STATE_NAC, 0);
}

/* reset and free the conps[] table */

static void conps_free(struct conp *conps)
{
    conps_reset(conps);
    free(conps);
}

/* compute all_defs set through merging block kill sets,
   allocate/initialize map[], and create initial conps[]
   for each block. */

static blocks_iter_ret all0(struct block *b)
{
    regs_union(&all_defs, &b->kill);
    return BLOCKS_ITER_OK;
}

static blocks_iter_ret init0(struct block *b)
{
    b->prop.in = conps_new();
    b->prop.gen = conps_new();
    b->prop.out = conps_new();
    b->prop.tmp = conps_new();
}

static void init(void)
{
    struct reg *r;
    int n;

    blocks_iter(all0);
    map = safe_malloc(sizeof(pseudo_reg) * MAP_SIZE);
    
    n = 0;

    REGS_FOREACH(r, &all_defs)  /* iteration returns regs in ascending */
        map[n++] = r->reg;      /* order, so, yay, the map is sorted */

    blocks_iter(init0);
    conps_poison(entry_block->prop.out);
}

/* perform copy propagation in the block, using
   the conps[] provided as a starting point, and
   update the conps[] to reflect the exit state */

static void local(struct block *b, struct conp *conps)
{
    struct insn *insn;
    struct operand *value;
    struct regs regs = REGS_INITIALIZER(regs);
    struct reg *r;
    pseudo_reg dst;

    INSNS_FOREACH(insn, &b->insns) {
        if (value = insn_con(insn, &dst)) {
            conps_set(conps, dst, CONP_STATE_CON, value);
            continue;
        }

        insn_uses_regs(insn, &regs);

        REGS_FOREACH(r, &regs)
            if ((value = conps_value(conps, r->reg))
              && insn_substitute_con(insn, r->reg, value))
                changed = TRUE;

        regs_clear(&regs);

        insn_defs_regs(insn, &regs);

        REGS_FOREACH(r, &regs)
            conps_set(conps, r->reg, CONP_STATE_NAC, 0);
    
        regs_clear(&regs);
    }
}

/* we do one pass of local copy propagation before iteration
   begins - exit state is, conveniently, the GEN() set. */

static blocks_iter_ret gen0(struct block *b)
{
    local(b, b->prop.gen);

    return BLOCKS_ITER_OK;
}

/* the iterative analysis. if the OUT set has
   changed, make sure we rinse and repeat */

static blocks_iter_ret prop0(struct block *b)
{
    struct cessor *pred;

    if (b == entry_block)
        return BLOCKS_ITER_OK;

    conps_reset(b->prop.in);

    for (pred = CESSORS_FIRST(&b->predecessors);
      pred; pred = CESSORS_NEXT(pred))
        conps_merge(b->prop.in, pred->b->prop.out);

    conps_dup(b->prop.tmp, b->prop.in);
    conps_kill(b->prop.tmp, &b->kill);
    conps_merge_gen(b->prop.tmp, b->prop.gen);

    if (conps_same(b->prop.tmp, b->prop.out))
        return BLOCKS_ITER_OK;
    else {
        conps_dup(b->prop.out, b->prop.tmp);
        return BLOCKS_ITER_REITER;
    }
}

/* rewriting is simply another local propagation pass,
   but this time we can use the IN() from other blocks */

static blocks_iter_ret rewrite0(struct block *b)
{
    local(b, b->prop.in);
    
    return BLOCKS_ITER_OK;
}

static blocks_iter_ret clear0(struct block *b)
{
    conps_free(b->prop.in);
    conps_free(b->prop.gen);
    conps_free(b->prop.out);
    conps_free(b->prop.tmp);

    return BLOCKS_ITER_OK;
}

static void clear(void)
{
    blocks_iter(clear0);
    free(map);
    regs_clear(&all_defs);
}

/* conditional propagation. if a block has an unconditional successor
   whose sole function is to compare a register with a constant and
   branch accordingly, and the register is a known constant at the exit
   of the block, then we hoist the comparison and branches to the end of
   the block. constant folding will later resolve the branch statically.
   this simple transformation results in a handful of improvements like
   loop inversion and better code for logical operators. */

static blocks_iter_ret cond0(struct block *b)
{
    struct cessor *succ;
    struct insn *insn;
    struct operand *value;
    pseudo_reg dst;

    if ((succ = block_always_successor(b))
      && (succ->b != b)
      && (INSNS_COUNT(&succ->b->insns) == 1)
      && insn_test_con(INSNS_FIRST(&succ->b->insns), &dst)
      && (value = conps_value(b->prop.out, dst))
      && OPERAND_PURE_CON(value)) {
        insn = insn_dup(INSNS_FIRST(&succ->b->insns));
        insn_substitute_con(insn, dst, value);
        BLOCK_APPEND_INSN(b, insn);
        block_dup_successors(b, succ->b);
        changed = TRUE;
    }

    return BLOCKS_ITER_OK;
}

/* static switch() resolution. if the controlling expression
   is a known constant, there's no need to switch. */

static blocks_iter_ret switch0(struct block *b)
{
    struct conp *p;
    struct operand *o;
    struct block *switch_b;

    if (BLOCK_SWITCH(b)) {
        o = b->control;

        if (OPERAND_REG(o))
            o = conps_value(b->prop.out, o->reg);
    
        if (OPERAND_PURE_CON(o)) {
            switch_b = block_switch_lookup(b, o->con.i);
            block_remove_successors(b);
            block_add_successor(b, CC_ALWAYS, switch_b);
            changed = TRUE;
        }
    }

    return BLOCKS_ITER_OK;
}

void prop(void)
{
    do {
        kill_analyze();
        changed = FALSE;

        init();
        blocks_iter(gen0);
        blocks_iter(prop0);
        blocks_iter(rewrite0);
        blocks_iter(cond0);
        blocks_iter(switch0);

        clear();

        if (changed) {
            fold();
            algebra();
            dead();
            unreach();
        }
    } while (changed);
}

/* vi: set ts=4 expandtab: */

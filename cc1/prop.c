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
#include "opt.h"

/* constant propagation. if a register is assigned a constant value,
   we can replace uses of that register with the constant, until the
   register is re-assigned. the constants still alive at exit of a
   block are made available to its successors, and a successor may
   make use of those constants on which all its predecessors agree.
   we use standard data-flow analysis iteration until no new constants
   are discovered (until the entry conditions at each block stabilize).

   we also perform a limited form of conditional propagation: if a block
   has an unconditional successor whose sole function is to compare a
   register with a constant and branch accordingly, and the register is a
   known constant at the exit of the block, then we hoist the comparison
   and branches to the end of the block. constant folding will later resolve
   the branch statically. this simple transformation results in a handful of
   improvements like loop inversion and better code for logical operators.

   finally, we perform static switch() resolution when possible. */

#define PROP_CONSTRUCT(x)   (*(x) = 0)
#define PROP_DESTRUCT(x)    operand_free(*(x))
#define PROP_DUP(dst,src)   ((*(dst)) = operand_dup(*(src)))

static ASSOC_DEFINE_CLEAR(prop, value, PROP_DESTRUCT)
static ASSOC_DEFINE_INSERT(prop, pseudo_reg, reg, value, PROP_CONSTRUCT)
static ASSOC_DEFINE_UNSET(prop, pseudo_reg, reg, value, PROP_DESTRUCT)
static ASSOC_DEFINE_LOOKUP(prop, pseudo_reg, reg)
static ASSOC_DEFINE_DUP(prop, pseudo_reg, reg, value, PROP_DUP)

#define PROPS_INITIALIZER(ps)   ASSOC_INITIALIZER(ps)
#define PROPS_INIT(ps)          ASSOC_INIT(ps)
#define PROPS_COUNT(ps)         ASSOC_COUNT(ps)
#define PROPS_FOREACH(p, ps)    ASSOC_FOREACH(p, ps)
#define PROPS_FIRST(ps)         ASSOC_FIRST(ps)
#define PROPS_NEXT(p)           ASSOC_NEXT(p)

/* update props to reflect reg -> value.
   caller yields ownership of the value */

static void props_update(struct props *ps, pseudo_reg reg,
                         struct operand *value)
{
    struct prop *p;

    p = props_insert(ps, reg);

    if (p->value)
        operand_free(p->value);

    p->value = value;
}

/* make dst the intersection of dst and src, i.e.,
   remove any elements of dst that are not in src. */

static void props_intersect(struct props *dst, struct props *src)
{
    struct prop *src_p;
    struct prop *dst_p;
    struct prop *next;

    for (dst_p = PROPS_FIRST(dst); dst_p; dst_p = next) {
        next = PROPS_NEXT(dst_p);
        src_p = props_lookup(src, dst_p->reg);

        if ((src_p == 0) || !operand_is_same(src_p->value, dst_p->value))
            props_unset(dst, dst_p->reg);
    }
}

/* create the incoming state of constants as the
   intersection of the states of all predecessors. */

static void props_merge(struct block *b)
{
    struct cessor *pred;

    props_clear(&b->props);

    CESSORS_FOREACH(pred, &b->predecessors) {
        if (pred == CESSORS_FIRST(&b->predecessors))
            props_dup(&b->props, &pred->b->props);
        else
            props_intersect(&b->props, &pred->b->props);
    }
}

static bool changed;

static blocks_iter_ret prop0(struct block *b)
{
    PROPS_INIT(&b->props);
    return BLOCKS_ITER_OK;
}

/* constant propagation proper */

static blocks_iter_ret prop1(struct block *b)
{
    struct regs regs = REGS_INITIALIZER(regs);
    struct reg *regs_r;
    struct insn *insn;
    struct operand *value;
    struct prop *p;
    pseudo_reg dst;
    int count;

    count = PROPS_COUNT(&b->props);
    props_merge(b);

    INSNS_FOREACH(insn, &b->insns) {
        if (value = insn_con(insn, &dst)) {
            props_update(&b->props, dst, value);
            continue;
        }

        PROPS_FOREACH(p, &b->props)
            if (insn_substitute_con(insn, p->reg, p->value))
                changed = TRUE;

        insn_defs_regs(insn, &regs);

        REGS_FOREACH(regs_r, &regs)
            props_unset(&b->props, regs_r->reg);
    
        regs_clear(&regs);
    }

    if (PROPS_COUNT(&b->props) == count)
        return BLOCKS_ITER_OK;
    else
        return BLOCKS_ITER_REITER;
}

/* conditional constant propagation. we do this separately
   so we don't affect convergence during iterative analysis.  */

static blocks_iter_ret prop2(struct block *b)
{
    struct cessor *succ;
    struct insn *insn;
    struct prop *p;
    pseudo_reg dst;

    if ((succ = block_always_successor(b))
      && (succ->b != b)
      && (INSNS_COUNT(&succ->b->insns) == 1)
      && insn_test_con(INSNS_FIRST(&succ->b->insns), &dst)
      && (p = props_lookup(&b->props, dst))
      && OPERAND_PURE_CON(p->value)) {
        insn = insn_dup(INSNS_FIRST(&succ->b->insns));
        insn_substitute_con(insn, p->reg, p->value);
        BLOCK_APPEND_INSN(b, insn);
        block_dup_successors(b, succ->b);
        changed = TRUE;
        return BLOCKS_ITER_ABORT;
    }
    
    return BLOCKS_ITER_OK;
}

/* static switch() resolution. if the controlling expression
   is a known constant, there's no need to switch. */

static blocks_iter_ret prop3(struct block *b)
{
    struct prop *p;
    struct operand *o;
    struct block *switch_b;

    if (BLOCK_SWITCH(b)) {
        o = b->control;

        if (OPERAND_REG(o) && (p = props_lookup(&b->props, o->reg)))
            o = p->value;
    
        if (OPERAND_PURE_CON(o)) {
            switch_b = block_switch_lookup(b, o->con.i);
            block_remove_successors(b);
            block_add_successor(b, CC_ALWAYS, switch_b);
            changed = TRUE;
            return BLOCKS_ITER_ABORT;
        }
    }

    return BLOCKS_ITER_OK;
}

static blocks_iter_ret prop4(struct block *b)
{
    props_clear(&b->props);
    return BLOCKS_ITER_OK;
}

void prop(void)
{
    changed = FALSE;

again:
    blocks_iter(prop0);
    blocks_iter(prop1);

    while (blocks_iter(prop2) == BLOCKS_ITER_ABORT) {
        blocks_iter(prop4);
        goto again;
    }

    while (blocks_iter(prop3) == BLOCKS_ITER_ABORT) {
        blocks_iter(prop4);
        goto again;
    }

    blocks_iter(prop4);

    if (changed) {
        fold();
        dead();
        algebra();
        unreach();
    }
}

/* vi: set ts=4 expandtab: */

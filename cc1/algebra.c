/* algebra.c - algebraic simplifications                ncc, the new c compiler

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
#include "algebra.h"
#include "opt.h"

/* simple algebraic simplifications and strength reductions. in
   addition to its obvious benefits, this pass will effectively
   normalize operations so later passes like value numbering will
   not need to recognize algebraic equivalents, e.g.,

      (x + x) == (2 * x) == (x << 1)  (at least for integers)

   there is plenty of room for expansion here. if we desire further
   strength reduction (e.g., (x * 3) == ((x << 1) + x)) this would
   be the place to do it. also, we currently miss (or even create)
   some easy ones like repeated shifts (((x << 1) << 1) == (x << 2)). */

static bool changed;

/* algebraic simplifications first */

static blocks_iter_ret algebra0(struct block *b)
{
    struct insn *insn;

    INSNS_FOREACH(insn, &b->insns) {
        insn_normalize(insn);

        switch (insn->op)
        {
        case I_ADD:                                         /* x + 0 == x */
        case I_SUB:                                         /* x - 0 == x */
        case I_OR:                                          /* x | 0 == x */
        case I_XOR:                                         /* x ^ 0 == x */
        case I_SHR:                                         /* x >> 0 == x */
        case I_SHL:                                         /* x << 0 == x */
            if (operand_is_zero(insn->src2))
                goto self;
    
            break;

        case I_AND:
            if (operand_is_zero(insn->src2))                /* x & 0 == 0 */
                goto zero;

            break;

        case I_MUL:                            
            if (operand_is_zero(insn->src2))                /* x * 0 == 0 */
                goto zero;
            if (operand_is_one(insn->src2))                 /* x * 1 == x */
                goto self;

            break;

        case I_MOD:
            if ((operand_is_one(insn->src2))                /* x % 1 == 0 */
              || operand_is_same(insn->src1, insn->src2))   /* x % x == 0 */
                goto zero;

            break;

        case I_DIV:
            if (operand_is_same(insn->src1, insn->src2))    /* x / x == 1 */
                goto one;
            if (operand_is_one(insn->src2))                 /* x / 1 == 0 */
                goto self;

            break;
        }

        continue;

self:
        insn_replace(insn, I_MOVE, operand_dup(insn->dst),
                                   operand_dup(insn->src1));
        changed = TRUE;
        continue;

zero:
        insn_replace(insn, I_MOVE, operand_dup(insn->dst),
                                   operand_zero(insn->dst->ts));
        changed = TRUE;
        continue;

one:
        insn_replace(insn, I_MOVE, operand_dup(insn->dst),
                                   operand_one(insn->dst->ts));
        changed = TRUE;
        continue;
    }

    return BLOCKS_ITER_OK;
}

/* determine if the operand is a power of 2. if
   so, return its log2, otherwise return -1.

   this is a pretty naive (slow) way to do this. */

static int log_2(struct operand *opr)
{
    unsigned long u;
    int shift;

    if (OPERAND_PURE_CON(opr) && OPERAND_INTEGRAL(opr))
        for (shift = 0, u = 1; u; ++shift, u <<= 1)
            if ((u & opr->con.i) == opr->con.i)
                return shift;

    return -1;
}

/* strength reductions. notably, all operations that
   can be represented by shifts are changed to shifts. */

static blocks_iter_ret algebra1(struct block *b)
{
    struct insn *insn;
    insn_op op;
    long con;

    INSNS_FOREACH(insn, &b->insns) {
        if (!OPERAND_INTEGRAL(insn->src1) || !OPERAND_INTEGRAL(insn->src2))
            continue;

        switch (insn->op)
        {
        case I_ADD:     /* (x + x) == (x << 1) */

            if (operand_is_same(insn->src1, insn->src2)) {
                con = 1;
                op = I_SHL;
                goto replace;
            }
    
            break;

        case I_MUL:     /* (x * [power of 2]) == (x << [log2]) */

            if ((con = log_2(insn->src2)) != -1) {
                op = I_SHL;
                goto replace;
            }

            break;

        case I_MOD:     /* (x % [power of 2]) == (x & [mask]) */

            if (OPERAND_UNSIGNED(insn->src2)
              && ((con = log_2(insn->src2)) != -1)) {
                op = I_AND;
                con = ~(-1L << con);
                goto replace;
            }

            break;

        case I_DIV:     /* (x / [power of 2]) == (x >> [log2]) */

            if (OPERAND_UNSIGNED(insn->src2)
              && ((con = log_2(insn->src2)) != -1)) {
                op = I_SHR;
                goto replace;
            }

            break;
        }

        continue;

replace:
        insn_replace(insn, op, operand_dup(insn->dst),
                               operand_dup(insn->src1),
                               operand_i(insn->dst->ts, con, 0));
        changed = TRUE;
        continue;
    }
    
    return BLOCKS_ITER_OK;
}


void algebra(void)
{
    changed = FALSE;

    blocks_iter(algebra0);
    blocks_iter(algebra1);

    if (changed)
        nop();
}

/* vi: set ts=4 expandtab: */

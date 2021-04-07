/* fuse.c - load/store fusing                           ncc, the new c compiler

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

#include "../../common/util.h"
#include "../cc1.h"
#include "../block.h"
#include "../insn.h"
#include "../live.h"
#include "insn.h"
#include "fuse.h"

/* the IR reflects a load-store architecture, whereas the AMD64 allows
   memory operands. after the AMD64 code has been generated, we look
   for opportunities to fuse load/store insns with following/previous
   insns (respectively), saving the additional insns. we do this both
   before and after register allocation: doing it before may save a
   register and thus reduce register pressure, and doing it after gives
   us the opportunity to fuse any spill insns. */

/* first, we look for load-store combinations, where a register is read from
   memory, some operation is performed on it, and then it's put back, e.g.,

                        movl 32(%rsi),%edi
                        addl $1,%edi
                        movl %edi,32(%rsi)

   if this is the extent of the live range for %edi above, then we rewrite as:

                        addl $1, 32(%rsi)

   when the condition codes of the middle operation are important, we can't
   always rewrite. this occurs with sub-int operations, e.g.,

                        movzbl (%i16q), %eax
                        addl $1, %eax
                        movl %eax, (%16d)

   can't be rewritten as
        
                        addb $1, (%16q)

   since the condition codes would be set differently for byte and int ops
   for certain values (consider if the byte at (%16q) were 0xFF). */

static struct update            /* this table is incomplete */
{
    insn_op first;
    insn_op second;
    insn_op third;
    insn_op new;
    bool same_ccs;
} updates[] = {
{   AMD64_I_MOVZBL, AMD64_I_ADDL,   AMD64_I_MOVB,   AMD64_I_ADDB,   FALSE   },
{   AMD64_I_MOVZBL, AMD64_I_SUBL,   AMD64_I_MOVB,   AMD64_I_SUBB,   FALSE   },
{   AMD64_I_MOVSBL, AMD64_I_ADDL,   AMD64_I_MOVB,   AMD64_I_ADDB,   FALSE   },
{   AMD64_I_MOVSBL, AMD64_I_SUBL,   AMD64_I_MOVB,   AMD64_I_SUBB,   FALSE   },
{   AMD64_I_MOVZWL, AMD64_I_ADDL,   AMD64_I_MOVW,   AMD64_I_ADDW,   FALSE   },
{   AMD64_I_MOVZWL, AMD64_I_SUBL,   AMD64_I_MOVW,   AMD64_I_SUBW,   FALSE   },
{   AMD64_I_MOVSWL, AMD64_I_ADDL,   AMD64_I_MOVW,   AMD64_I_ADDW,   FALSE   },
{   AMD64_I_MOVSWL, AMD64_I_SUBL,   AMD64_I_MOVW,   AMD64_I_SUBW,   FALSE   },
{   AMD64_I_MOVL,   AMD64_I_ADDL,   AMD64_I_MOVL,   AMD64_I_ADDL,   TRUE    },
{   AMD64_I_MOVL,   AMD64_I_SUBL,   AMD64_I_MOVL,   AMD64_I_SUBL,   TRUE    },
{   AMD64_I_MOVQ,   AMD64_I_ADDQ,   AMD64_I_MOVQ,   AMD64_I_ADDQ,   TRUE    },
{   AMD64_I_MOVQ,   AMD64_I_SUBQ,   AMD64_I_MOVQ,   AMD64_I_SUBQ,   TRUE    }
};

static blocks_iter_ret update0(struct block *b)
{
    struct insn *first;
    struct insn *second;
    struct insn *third;
    struct update *u;
    pseudo_reg reg;
    struct range *r;
    int i;

    INSNS_FOREACH(first, &b->insns) {
        if ((second = INSNS_NEXT(first)) == 0)
            break;

        if ((third = INSNS_NEXT(second)) == 0)
            break;

        for (i = 0, u = updates; i < ARRAY_SIZE(updates); ++i, ++u) {
            if ((first->op != u->first)
              || (second->op != u->second)
              || (third->op != u->third))
                continue;

            if (!AMD64_OPERAND_MEM(first->amd64[0])
              || !AMD64_OPERAND_MEM(third->amd64[1])
              || !amd64_operands_same(first->amd64[0], third->amd64[1]))
                continue;

            if (!AMD64_OPERAND_REG(first->amd64[1])
              || !AMD64_OPERAND_REG(second->amd64[1])
              || !AMD64_OPERAND_REG(third->amd64[0]))
                continue;

            reg = first->amd64[1]->reg;

            if ((second->amd64[1]->reg != reg)
              || (third->amd64[0]->reg != reg))
                continue;

            if (AMD64_OPERAND_REG(second->amd64[0])
              && (second->amd64[0]->reg == reg))
                continue;

            if (!AMD64_OPERAND_REG(second->amd64[0])
              && !AMD64_OPERAND_CON(second->amd64[0]))
                continue;

            r = range_by_use(&b->live, reg, third->index);

            if (r->last != third->index)
                continue;

            if (!u->same_ccs
              && (r = range_by_def(&b->live, PSEUDO_REG_CC, second->index))
              && !RANGE_DEAD(r))
                continue;

            insn_replace(second, u->new, amd64_operand_dup(second->amd64[0]),
                                         amd64_operand_dup(first->amd64[0]));

            second->flags |= first->flags | third->flags;

            insn_replace(first, I_NOP);
            insn_replace(third, I_NOP);
            break;
        }
    }

    return BLOCKS_ITER_OK;
}

void amd64_fuse(void)
{
    live_analyze();
    blocks_iter(update0);
}

/* vi: set ts=4 expandtab: */

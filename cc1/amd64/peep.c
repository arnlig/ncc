/* peep.c - AMD64-specific peephole optimizations       ncc, the new c compiler

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
#include "../insn.h"
#include "../block.h"
#include "insn.h"
#include "peep.h"

/* these are not all peephole optimizations in the strictest sense,
   but rather a miscellaneous collection of improvements that fit into
   the simple block-by-block, insn-by-insn iteration done here, and do
   not require any kind of serious analysis.

   at some point, we may need to create some more general insn-matching
   framework rather than the ad hoc methods here. rainy day, perhaps. */


/* eliminate superfluous sign/zero-extensions.

   the code generator, for several reasons, is blissfully unaware when
   the upper bits of a register are already extended properly.
                                        
        sequences like:                 are replaced with:

        movzbl (%i16q),%i17d            movzbl (%i16q),%i17d
        movzbl %i17b,%i18d              movl %i17d, %18d

   the original sequence above appears because the AMD64 code generator
   automatically extends sub-word loads into the target register to avoid
   partial updates, and the front end casts the result per language rules.

        sometimes we also see:          which should be replaced with:

        movzbl %i22b, %i22d             movzbq %i22b, %i22q
        movslq %i22d, %i23q             movq %i22q, %i23q

   i've only ever seen this arise because of a prior setcc instruction,
   which modifies a byte register, so the code generator manually issues
   the first zero-extend instruction because the result should be an int.
   if that result is cast (to a long, in the above case), then a double
   extension results.

   typically, in cases like the above, the second instruction and reg
   are eliminated by the register allocator through coalescing. */

struct signzero
{
    insn_op first;          /* if the first insn is this .. */
    insn_op second;         /* .. and the second is this .. */
    insn_op new_first;      /* .. replace the first with this .. */
    insn_op new_second;     /* .. and the second with this. */
};

struct signzero signzeros[] =
{
    /* there are surely cases missing. also, note, when the upper 32
       bits are guaranteed to be zero, we can MOVL even for longs */

    /* repeated casts (e.g,. char -> int, char -> int) */

    {   AMD64_I_MOVZBL, AMD64_I_MOVZBL, AMD64_I_MOVZBL, AMD64_I_MOVL    },
    {   AMD64_I_MOVZWL, AMD64_I_MOVZWL, AMD64_I_MOVZWL, AMD64_I_MOVL    },
    {   AMD64_I_MOVSBL, AMD64_I_MOVSBL, AMD64_I_MOVSBL, AMD64_I_MOVL    },
    {   AMD64_I_MOVSWL, AMD64_I_MOVSWL, AMD64_I_MOVSWL, AMD64_I_MOVL    },
    {   AMD64_I_MOVZLQ, AMD64_I_MOVZLQ, AMD64_I_MOVZLQ, AMD64_I_MOVL    },
    {   AMD64_I_MOVSLQ, AMD64_I_MOVSLQ, AMD64_I_MOVSLQ, AMD64_I_MOVQ    },

    /* overlapping casts (e.g., short -> int, short -> long) */

    {   AMD64_I_MOVZBL, AMD64_I_MOVZBQ, AMD64_I_MOVZBQ, AMD64_I_MOVL    },
    {   AMD64_I_MOVSBL, AMD64_I_MOVSBQ, AMD64_I_MOVSBQ, AMD64_I_MOVQ    },
    {   AMD64_I_MOVZWL, AMD64_I_MOVZWQ, AMD64_I_MOVZWQ, AMD64_I_MOVL    },
    {   AMD64_I_MOVSWL, AMD64_I_MOVSWQ, AMD64_I_MOVSWQ, AMD64_I_MOVQ    },

    /* chained casts (e.g., char -> int, int -> long) */

    {   AMD64_I_MOVZBL, AMD64_I_MOVSLQ, AMD64_I_MOVZBQ, AMD64_I_MOVL    },
    {   AMD64_I_MOVZBL, AMD64_I_MOVZLQ, AMD64_I_MOVZBQ, AMD64_I_MOVL    }
};

static bool signzero(struct insn *insn)
{
    struct insn *next;
    int i;
    
    if ((next = INSNS_NEXT(insn)) == 0)
        return FALSE;

    for (i = 0; i < ARRAY_SIZE(signzeros); ++i)
        if ((insn->op == signzeros[i].first)
          && (next->op == signzeros[i].second))
            break;

    if (i == ARRAY_SIZE(signzeros))
        return FALSE;

    if (!AMD64_OPERAND_REG(insn->amd64[1]))
        return FALSE;

    if (!AMD64_OPERAND_REG(next->amd64[0]))
        return FALSE;

    if (insn->amd64[1]->reg != next->amd64[0]->reg)
        return FALSE;

    insn->op = signzeros[i].new_first;
    next->op = signzeros[i].new_second;
    return TRUE;
}

/* the lowest of low-hanging fruit, the oldest optimization in
   the world: replace movl $0, <reg> with xorl <reg>, <reg>. */

static void zero(struct insn *insn)
{
    if ((insn->op == AMD64_I_MOVL)
      && AMD64_OPERAND_ZERO(insn->amd64[0])
      && AMD64_OPERAND_REG(insn->amd64[1])) {
        insn_replace(insn, AMD64_I_ZERO, amd64_operand_dup(insn->amd64[1]),
                                         amd64_operand_dup(insn->amd64[1]));
    }
}

/* our approach is simple: iterate over every instruction in
   the block and see if anyone can improve it. if so, start
   again at the top of the block to ensure we transform any
   uncovered opportunities. */

static blocks_iter_ret peep0(struct block *b)
{
    struct insn *insn;

again:
    INSNS_FOREACH(insn, &b->insns) {
        zero(insn);

        if (signzero(insn))
            goto again;
    }
        

    return BLOCKS_ITER_OK;
}

void amd64_peep(void)
{
    blocks_iter(peep0);
}

/* vi: set ts=4 expandtab: */

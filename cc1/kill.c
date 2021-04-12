/* kill.c - kill set computation                        ncc, the new c compiler

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
#include "blks.h"
#include "regs.h"
#include "block.h"
#include "kill.h"

static blocks_iter_ret analyze0(struct block *b)
{
    struct insn *insn;

    regs_clear(&b->kill);

    INSNS_FOREACH(insn, &b->insns)
        insn_defs_regs(insn, &b->kill, 0);

    return BLOCKS_ITER_OK;
}

void kill_analyze(void)
{
    blocks_iter(analyze0);
}

/* gather kill sets. add the killed registers
   from all blks to regs. if blks is 0, then
   all blocks in the function are included. */

static struct blks *gather_blks;
static struct regs *gather_kill_regs;

static blocks_iter_ret gather0(struct block *b)
{
    if ((gather_blks == 0) || BLKS_CONTAINS(gather_blks, b))
        regs_union(gather_kill_regs, &b->kill);

    return BLOCKS_ITER_OK;
}

void kill_gather_kills(struct blks *blks, struct regs *regs)
{
    gather_blks = blks;
    gather_kill_regs = regs;
    blocks_iter(gather0);
}

/* vi: set ts=4 expandtab: */

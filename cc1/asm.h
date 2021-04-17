/* asm.h - inline assembly support                      ncc, the new c compiler

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

#ifndef ASM_H
#define ASM_H

#include "cc1.h"
#include "regs.h"
#include "regmaps.h"

struct string;

extern void asm_statement(void);
extern void asm_rewrite(void);

/* I_ASM instructions have no operands, having instead a struct iasm payload.

   the syntax of an __asm() instruction is approximately:

   '__asm' [ 'volatile' ] '(' string-literal [':' inputs [':' outputs]] ')'

   inputs and outputs take the form     ( reg [ '=' variable ] ) | flag

   where regs are physical registers, variables are scalars (which must be
   class-appropriate to the reg) and flag is one of 'mem' or 'cc'. inputs
   indicate USEs, and for reg/variable pairs the compiler arranges for the
   variables' values to be placed in reg before the user asm is emitted. the
   outputs indicate DEFs, and for those reg/variable pairs, the compiler will
   retrieve the updated variables' values from their respective registers,
   after the user's assembly. the flag 'cc', and regs without associated
   variables, are only allowed as outputs- the meaning is "contents trashed".

   if __asm() is volatile, then the I_ASM will be marked INSN_FLAG_VOLATILE
   and so the instruction will not be moved/reordered, etc.

   in the target-independent IR, the defs and uses correspond to the pseudo
   registers in the outputs and inputs above, and the regmaps hold the actual
   mappings. right before target code generation, the front end emits correct
   I_MOVEs before and after the I_ASM to effect the mappings, then rewrites
   defs and uses to correspond to the mapped target registers. thus the front
   end sees only pseudo registers and the back end only target registers. */

struct iasm
{
    struct string *text;        /* text supplied by user */

    struct regs defs;           /* returned by insn_defs_regs() */
    struct regs uses;           /* ........and insn_uses_regs() */
    
    /* note that in the regmaps, the physical reg is always the key */

    struct regmaps in;          /* physical reg <- pseudo reg inputs */
    struct regmaps out;         /* pseudo reg <- physical reg outputs */

    bool defs_mem;
    bool uses_mem;
    bool defs_cc;
};

extern struct iasm *asm_new(void);
extern struct iasm *asm_dup(struct iasm *);
extern void asm_free(struct iasm *);

extern void asm_statement(void);
extern void asm_rewrite(void);

/* back ends define a struct regname[] array to map names to pseudo_regs. */

struct regname
{
    char *text;
    pseudo_reg reg;
};

#endif /* ASM_H */

/* vi: set ts=4 expandtab: */

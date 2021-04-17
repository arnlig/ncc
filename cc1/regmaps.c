/* regmaps.c - register -> register mappings            ncc, the new c compiler

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
#include "regmaps.h"

#define REGMAP_CONSTRUCT(r)     (*(r) = PSEUDO_REG_NONE)
#define REGMAP_DUP(dst, src)    (*(dst) = *(src))

ASSOC_DEFINE_CLEAR(regmap, from, ASSOC_NULL_DESTRUCT)
ASSOC_DEFINE_LOOKUP(regmap, pseudo_reg, from)
ASSOC_DEFINE_UNSET(regmap, pseudo_reg, from, to, ASSOC_NULL_DESTRUCT)
ASSOC_DEFINE_INSERT(regmap, pseudo_reg, from, to, ASSOC_NULL_CONSTRUCT)
ASSOC_DEFINE_DUP(regmap, pseudo_reg, from, to, REGMAP_DUP)

void regmaps_update(struct regmaps *m, pseudo_reg from, pseudo_reg to)
{
    struct regmap *r;

    r = regmaps_insert(m, from);
    r->to = to;
}

/* replace the values (the to fields) for all regmaps entries,
   from bef to aft. the terminology here is unfortunate. also
   note that we don't touch the key fields (from) at all.

   returns TRUE if any substitutions are made. */

bool regmaps_substitute(struct regmaps *m, pseudo_reg bef, pseudo_reg aft)
{
    struct regmap *rm;
    bool result = FALSE;

    REGMAPS_FOREACH(rm, m)
        if (rm->to == bef) {
            rm->to = aft;
            result = TRUE;
        }

    return result;
}

/* strip the values (to) of any register indices.
   note that we do not touch the key (from) registers. */

void regmaps_strip(struct regmaps *m)
{
    struct regmap *rm;

    REGMAPS_FOREACH(rm, m)
        rm->to = PSEUDO_REG_BASE(rm->to);
}

/* vi: set ts=4 expandtab: */

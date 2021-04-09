/* field.c - bitfield access optimizations              ncc, the new c compiler

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
#include "tree.h"
#include "type.h"
#include "field.h"

/* return the mask for a bitfield of the given specification */

long field_mask(int size, int shift)
{
    unsigned long mask;

    mask = -1L;
    mask >>= (sizeof(mask) * BITS_PER_BYTE) - size;
    mask <<= shift;

    return mask;
}

/* attempt to optimize some fields accesses. extracting fields
   is an expensive prospect, so we should avoid it when we can.

   one easy situation is when testing if the field is equal to
   (or not equal to) zero. in this case, fetch we the field and
   mask the field off, in-place.

   note: this is called after tree_simplify(), so we can expect
   binary operands to be normalized, at least to the extent that
   a pure constant 0 operand will be on the right. */

struct tree *field_tree_opt(struct tree *tree)
{
    struct type type = TYPE_INITIALIZER(type);
    long mask;

    if ((tree->op != E_EQ) && (tree->op != E_NEQ))
        return tree;

    if (!TREE_FIELD_FETCH(tree->left))
        return tree;

    if (!tree_zero(tree->right))
        return tree;

    type_deref(&type, &tree->left->child->type);
    mask = field_mask(TYPE_GET_SIZE(&type), TYPE_GET_SHIFT(&type));
    type_clear(&tree->left->child->type);
    TYPE_UNFIELD(&type);
    type_ref(&tree->left->child->type, &type);

    tree->left = tree_binary(E_AND, tree->left,
                                    tree_i(TYPE_BASE(&type), mask));

    TYPE_CONCAT(&tree->left->type, &type);

    return tree;
}

/* vi: set ts=4 expandtab: */

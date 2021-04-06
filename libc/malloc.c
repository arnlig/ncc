/* malloc.c - dynamic memory allocation                    ncc standard library

Copyright (c) 1987, 1997, 2001 Prentice Hall. All rights reserved.
Copyright (c) 1987 Vrije Universiteit, Amsterdam, The Netherlands.
Copyright (c) 2021 Charles E. Youse (charles@gnuless.org).

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of Prentice Hall nor the names of the software authors or
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

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

#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

/* a short explanation of the data structure and algorithms: an area
   returned by malloc() is called a slot. each slot contains the number
   of bytes requested, but preceeded by an extra pointer to the next the
   slot in memory. _bottom and _top point to the first/last slot. more
   memory is asked for using brk() and appended to top. the list of free
   slots is maintained to keep malloc() fast. _empty points the the first
   free slot. free slots are linked together by a pointer at the start of
   the user visable part, so just after the next-slot pointer. free slots
   are merged together by free(). */

static void *_bottom;
static void *_top;
static void *_empty;

typedef long ptrint;

#define BRKSIZE         4096        /* allocation alignment */

#define PTRSIZE         ((int) sizeof(void *))
#define ALIGN(x,a)      (((x) + (a - 1)) & ~(a - 1))
#define NEXT_SLOT(p)    (*(void **) ((p) - PTRSIZE))
#define NEXT_FREE(p)    (*(void **) (p))

static int grow(size_t len)
{
    char *p;

    if ((char *) _top + len < (char *) _top
      || (p = (char *) ALIGN((ptrint) _top + len, BRKSIZE)) < (char *) _top)
    {
        errno = ENOMEM;
        return(0);
    }

    if (brk(p) != 0)
        return 0;

    NEXT_SLOT((char *) _top) = p;
    NEXT_SLOT(p) = 0;
    free(_top);
    _top = p;

    return 1;
}

void *malloc(size_t size)
{
    char *prev; 
    char *p;
    char *next;
    char *new;
    size_t len;
    unsigned ntries;

    if (size == 0)
        return 0;

    for (ntries = 0; ntries < 2; ++ntries) {
        if ((len = ALIGN(size, PTRSIZE) + PTRSIZE) < (2 * PTRSIZE)) {
            errno = ENOMEM;
            return 0;
        }

        if (_bottom == 0) {
            if ((p = sbrk(2 * PTRSIZE)) == (char *) -1)
                return 0;

            p = (char *) ALIGN((ptrint) p, PTRSIZE);
            p += PTRSIZE;
            _top = _bottom = p;
            NEXT_SLOT(p) = 0;
        }

        for (prev = 0, p = _empty; p != 0; prev = p, p = NEXT_FREE(p)) {
            next = NEXT_SLOT(p);
            new = p + len;

            if (new > next || new <= p)     /* too small */
                continue;

            if (new + PTRSIZE < next) {     /* too big, so split */
                /* + PTRSIZE avoids tiny slots on free list */
                NEXT_SLOT(new) = next;
                NEXT_SLOT(p) = new;
                NEXT_FREE(new) = NEXT_FREE(p);
                NEXT_FREE(p) = new;
            }

            if (prev)
                NEXT_FREE(prev) = NEXT_FREE(p);
            else
                _empty = NEXT_FREE(p);

            return p;
        }

        if (grow(len) == 0)
            break;
    }

    return 0;
}

void free(void *ptr)
{
    char *prev;
    char *next;
    char *p = ptr;

    if (p == 0)
        return;

    for (prev = 0, next = _empty; next; prev = next, next = NEXT_FREE(next))
        if (p < next)
            break;

    NEXT_FREE(p) = next;

    if (prev)
        NEXT_FREE(prev) = p;
    else
        _empty = p;

    if (next) {
        if (NEXT_SLOT(p) == next) {         /* merge p and next */
            NEXT_SLOT(p) = NEXT_SLOT(next);
            NEXT_FREE(p) = NEXT_FREE(next);
        }
    }

    if (prev) {
        if (NEXT_SLOT(prev) == p) {         /* merge prev and p */
            NEXT_SLOT(prev) = NEXT_SLOT(p);
            NEXT_FREE(prev) = NEXT_FREE(p);
        }
    }
}

/* vi: set ts=4 expandtab: */

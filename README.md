Last update: May 19, 2021

## ncc, the _new_ C compiler

NCC is an ANSI/ISO-compliant optimizing C compiler. Calling it _new_
is a bit of a joke. It's descended from an older K&R C compiler I wrote
some years ago to compile code from the 4.3BSD codebase
(see [old-ncc](https://github.com/gnuless/old-ncc) if you're curious).

The compiler is retargetable, but it only produces binaries
for Linux/x86_64. As the compiler ABI differs somewhat from the
System V ABI used by Linux, its code cannot be linked against Linux
system libraries. It does, however, provide its own (incomplete) standard
ANSI/Posix C library.

### status

The compiler is complete and produces reasonable object code (within 10-20%
of GCC -O2), though it is rather crude and there are likely many lurking bugs.
And again, as mentioned above, the standard library is fairly substantial but
incomplete.

The code base is no longer under active development.

### supported C dialect

The compiler is compliant with ANSI C89/ISO C90, except that

* trigraphs are not recognized,
* there is no support for wide characters/string literals.

The compiler also supports a few extensions:
* inline assembly w/ optimizer integration (see cc1/asm.h for details)
* ALGOL-like statement expressions (with `({ })` a la GCC/LLVM)
* C99-style flexible array members
* C11-style anonymous structs and unions

### the standard library

While the compiler and preprocessor are original works, the standard library
is mostly a curated collection of code with BSD-style licenses. The code is
drawn from the Amsterdam Compiler Kit/Minix libraries, 4BSD, and even
Coherent (much of which is really high-quality code, so I'm happy it can live
on in ncc).

### brief (simplified) notes about internals

The front end uses a syntax-directed approach: an unremarkable
recursive-descent parser builds a CFG from the source input,
expressions being the only constructs that are temporarily
represented as ASTs. The target-independent IR looks much like
a load-store architecture with condition codes (so, e.g, an ARM,
which is not a coincidence).

There are several target-independent optimization phases, including
the usual constant folding, algebraic reassociation/simplification,
constant and copy propagation, value numbering, loop-invariant code
motion, etc. An interpretive code generator then translates the IR
into machine-dependent IR, which is effectively assembly language
with mostly-undetermined register assignments. Target-dependent (and
repeat target-independent) optimizations are run, then the graph
allocator assigns registers and the output is rendered.

There is some primitive instruction scheduling, but only applied (quite
awkwardly, actually) to the target-independent IR.

### criticisms

The compiler is hog-tied, as all C compilers are, by aliasing problems, but
the compiler takes a too-pessimistic view of memory accesses. It does only
the most primitive aliasing analysis, and it does not take advantage of the
Standard's strict-aliasing provisions.

The code is messier than I'd like. Some parts of the compiler are better
thought-out than others. Many of the algorithms are implemented naively,
and there are phasing problems between optimization passes. I initially
intended the code generation to be targeted at the ARM architecture, and
thus the AMD64 support is awkwardly bolted on; the IR is a poor fit for
CISC machines and this exacerbates some of the seedier parts of the code.

The register allocator is a fairly textbook bottom-up allocator, with
absolutely no finesse when it comes to spills: not only does it reserve
registers for spilling (which itself causes spills), but it also spills
entire ranges rather than splitting ranges. To make matters worse, the
spill code naively inserts loads-before-uses and stores-after-defs for
_every_ reference in those spilled ranges.

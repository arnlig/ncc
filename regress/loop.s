.text
_loop_init:
L1:
	pushq %rbp
	movq %rsp,%rbp
L7:
	leaq 8(%rdi),%rsi
	movq $0,8(%rdi)
	movq %rsi,16(%rdi)
	movl $0,(%rdi)
	movl $0,24(%rdi)
L3:
	popq %rbp
	ret
L13:
_loop_clear:
L14:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L18:
	movq %rdi,%rbx
	call _blks_clear
	movl $0,24(%rbx)
L16:
	popq %rbx
	popq %rbp
	ret
L20:
_bstack_push:
L22:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L29:
	movq %rsi,%r12
	movq %rdi,%rbx
	movl $16,%edi
	call _safe_malloc
	movq %r12,(%rax)
	movq (%rbx),%rsi
	movq %rsi,8(%rax)
	movq %rax,(%rbx)
L24:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L31:
_bstack_pop:
L33:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L41:
	movq %rdi,%rsi
	movq (%rsi),%rdi
	movq 8(%rdi),%rax
	movq %rax,(%rsi)
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rax
L35:
	popq %rbx
	popq %rbp
	ret
L43:
.data
.align 8
_bstack:
	.quad 0
.text
_loop_blocks:
L46:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L72:
	movq %rsi,%r15
	movq %rdi,%r12
	leaq -24(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq %rbx,%rdi
	movq %r15,%rsi
	movl $1,%edx
	call _blks_lookup
	cmpq %r15,%r12
	jz L51
L52:
	movq %rbx,%rdi
	movq %r12,%rsi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L58
L55:
	movq %rbx,%rdi
	movq %r12,%rsi
	movl $1,%edx
	call _blks_lookup
	movq $_bstack,%rdi
	movq %r12,%rsi
	call _bstack_push
L58:
	cmpq $0,_bstack(%rip)
	jz L51
L59:
	movq $_bstack,%rdi
	call _bstack_pop
	movq %rax,%r14
	xorl %r13d,%r13d
L61:
	movq %r14,%rdi
	movl %r13d,%esi
	call _block_get_predecessor_n
	movq %rax,%rbx
	cmpq $0,%rbx
	jz L58
L65:
	movq 8(%rbx),%rsi
	leaq -24(%rbp),%r12
	movq %r12,%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L63
L68:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	movl $1,%edx
	call _blks_lookup
	movq 8(%rbx),%rsi
	movq $_bstack,%rdi
	call _bstack_push
L63:
	addl $1,%r13d
	jmp L61
L51:
	leaq -24(%rbp),%rbx
	leaq 456(%r15),%rdi
	movq %rbx,%rsi
	call _blks_union
	movq %rbx,%rdi
	call _blks_clear
L48:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L74:
_loop0:
L76:
	pushq %rbp
	movq %rsp,%rbp
L77:
	addq $456,%rdi
	call _loop_clear
	xorl %eax,%eax
L78:
	popq %rbp
	ret
L83:
_loop1:
L85:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L97:
	movq %rdi,%r12
	xorl %ebx,%ebx
L88:
	movq %r12,%rdi
	movl %ebx,%esi
	call _block_get_successor_n
	movq %rax,%r13
	cmpq $0,%r13
	jz L91
L89:
	movq 8(%r13),%rsi
	leaq 432(%r12),%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jz L90
L92:
	movq 8(%r13),%rsi
	movq %r12,%rdi
	call _loop_blocks
L90:
	addl $1,%ebx
	jmp L88
L91:
	xorl %eax,%eax
L87:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L99:
_loop2:
L101:
	pushq %rbp
	movq %rsp,%rbp
L102:
	movq 464(%rdi),%rsi
L104:
	cmpq $0,%rsi
	jz L107
L105:
	movq (%rsi),%rdi
	addl $1,480(%rdi)
	movq 8(%rsi),%rsi
	jmp L104
L107:
	xorl %eax,%eax
L103:
	popq %rbp
	ret
L112:
_loop_analyze:
L113:
	pushq %rbp
	movq %rsp,%rbp
L114:
	call _dom_analyze
	movq $_loop0,%rdi
	call _blocks_iter
	movq $_loop1,%rdi
	call _blocks_iter
	movq $_loop2,%rdi
	call _blocks_iter
L115:
	popq %rbp
	ret
L119:
.globl _blks_lookup
.globl _blocks_iter
.globl _loop_clear
.globl _blks_clear
.globl _loop_init
.globl _dom_analyze
.globl _loop_analyze
.globl _safe_malloc
.globl _free
.globl _block_get_predecessor_n
.globl _block_get_successor_n
.globl _blks_union

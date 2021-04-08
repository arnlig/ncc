.text
_bstack_push:
L2:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L9:
	movq %rsi,%r12
	movq %rdi,%rbx
L3:
	movl $16,%edi
	call _safe_malloc
	movq %r12,(%rax)
	movq (%rbx),%rsi
	movq %rsi,8(%rax)
	movq %rax,(%rbx)
L4:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L11:
_bstack_pop:
L13:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L21:
	movq %rdi,%rsi
L14:
	movq (%rsi),%rdi
	movq 8(%rdi),%rax
	movq %rax,(%rsi)
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rax
L15:
	popq %rbx
	popq %rbp
	ret
L23:
.data
.align 8
_bstack:
	.quad 0
.text
_loop_blocks:
L26:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L52:
	movq %rsi,%r15
	movq %rdi,%r12
L27:
	leaq -24(%rbp),%rbx
	movq %rbx,%rdi
	movl $24,%ecx
	xorl %eax,%eax
	rep
	stosb
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq %rbx,%rdi
	movq %r15,%rsi
	movl $1,%edx
	call _blks_lookup
	cmpq %r15,%r12
	jz L31
L32:
	movq %rbx,%rdi
	movq %r12,%rsi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L38
L35:
	movq %rbx,%rdi
	movq %r12,%rsi
	movl $1,%edx
	call _blks_lookup
	movq $_bstack,%rdi
	movq %r12,%rsi
	call _bstack_push
L38:
	cmpq $0,_bstack(%rip)
	jz L31
L39:
	movq $_bstack,%rdi
	call _bstack_pop
	movq %rax,%r14
	xorl %r13d,%r13d
L41:
	movq %r14,%rdi
	movl %r13d,%esi
	call _block_get_predecessor_n
	movq %rax,%rbx
	cmpq $0,%rbx
	jz L38
L45:
	movq 8(%rbx),%rsi
	leaq -24(%rbp),%r12
	movq %r12,%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L43
L48:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	movl $1,%edx
	call _blks_lookup
	movq 8(%rbx),%rsi
	movq $_bstack,%rdi
	call _bstack_push
L43:
	addl $1,%r13d
	jmp L41
L31:
	leaq -24(%rbp),%rbx
	leaq 432(%r15),%rdi
	movq %rbx,%rsi
	call _blks_union
	movq %rbx,%rdi
	call _blks_clear
L28:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L54:
_loop0:
L56:
	pushq %rbp
	movq %rsp,%rbp
L57:
	movl $0,456(%rdi)
	addq $432,%rdi
	call _blks_clear
	xorl %eax,%eax
L58:
	popq %rbp
	ret
L63:
_loop1:
L65:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L77:
	movq %rdi,%r12
L66:
	xorl %ebx,%ebx
L68:
	movq %r12,%rdi
	movl %ebx,%esi
	call _block_get_successor_n
	movq %rax,%r13
	cmpq $0,%r13
	jz L71
L69:
	movq 8(%r13),%rsi
	leaq 408(%r12),%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jz L70
L72:
	movq 8(%r13),%rsi
	movq %r12,%rdi
	call _loop_blocks
L70:
	addl $1,%ebx
	jmp L68
L71:
	xorl %eax,%eax
L67:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L79:
_loop2:
L81:
	pushq %rbp
	movq %rsp,%rbp
L82:
	movq 440(%rdi),%rsi
L84:
	cmpq $0,%rsi
	jz L87
L85:
	movq (%rsi),%rdi
	addl $1,456(%rdi)
	movq 8(%rsi),%rsi
	jmp L84
L87:
	xorl %eax,%eax
L83:
	popq %rbp
	ret
L92:
_loop_analyze:
L93:
	pushq %rbp
	movq %rsp,%rbp
L94:
	call _dom_analyze
	movq $_loop0,%rdi
	call _blocks_iter
	movq $_loop1,%rdi
	call _blocks_iter
	movq $_loop2,%rdi
	call _blocks_iter
L95:
	popq %rbp
	ret
L99:
.globl _blks_lookup
.globl _blocks_iter
.globl _blks_clear
.globl _loop_analyze
.globl _dom_analyze
.globl _safe_malloc
.globl _free
.globl _block_get_predecessor_n
.globl _block_get_successor_n
.globl _blks_union

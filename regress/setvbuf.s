.text
_setvbuf:
L1:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L49:
	movl %edx,%r14d
	movq %rcx,%r13
	movq %rdi,%rbx
	movq %rsi,%r12
	xorl %r15d,%r15d
	movq $___stdio_cleanup,___exit_cleanup(%rip)
	cmpl $0,%r14d
	jz L6
L11:
	cmpl $64,%r14d
	jz L6
L7:
	cmpl $4,%r14d
	jz L6
L4:
	movl $-1,%eax
	jmp L3
L6:
	movq 16(%rbx),%rdi
	cmpq $0,%rdi
	jz L18
L19:
	movl 8(%rbx),%esi
	testl $8,%esi
	jz L18
L16:
	call _free
L18:
	movl 8(%rbx),%esi
	andl $-77,%esi
	movl %esi,8(%rbx)
	cmpq $0,%r12
	jz L25
L26:
	cmpq $0,%r13
	jnz L25
L23:
	movl $-1,%r15d
L25:
	cmpq $0,%r12
	jnz L32
L33:
	cmpl $4,%r14d
	jz L32
L30:
	cmpq $0,%r13
	jz L37
L40:
	movq %r13,%rdi
	call _malloc
	movq %rax,%r12
	cmpq $0,%rax
	jnz L38
L37:
	movl $-1,%r15d
	jmp L32
L38:
	movl 8(%rbx),%esi
	orl $8,%esi
	movl %esi,8(%rbx)
L32:
	movq %r12,16(%rbx)
	movl $0,(%rbx)
	movl 8(%rbx),%esi
	orl %r14d,%esi
	movl %esi,8(%rbx)
	movq 16(%rbx),%rsi
	movq %rsi,24(%rbx)
	cmpq $0,%r12
	jnz L45
L44:
	movl $1,12(%rbx)
	jmp L46
L45:
	movl %r13d,12(%rbx)
L46:
	movl %r15d,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L51:
.globl ___stdio_cleanup
.globl ___exit_cleanup
.globl _malloc
.globl _free
.globl _setvbuf

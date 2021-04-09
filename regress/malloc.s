.text
_refill:
L3:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L19:
	movl %edi,%ebx
	leal 5(%rbx),%ecx
	movl $1,%r14d
	shlq %cl,%r14
	movq %r14,%r12
	xorl %edi,%edi
	call _sbrk
	leaq 4095(%rax),%rsi
	shrq $12,%rsi
	shlq $12,%rsi
	subq %rax,%rsi
	cmpq $4096,%r14
	jae L7
L6:
	movl $4096,%eax
	xorl %edx,%edx
	divq %r14
	movl %eax,%r13d
	jmp L8
L7:
	movl $1,%r13d
L8:
	movl %r13d,%edi
	imull %r14d,%edi
	addl %edi,%esi
	movslq %esi,%rdi
	call _sbrk
	movq %rax,%rsi
	cmpq $-1,%rax
	jnz L11
L9:
	xorl %eax,%eax
	jmp L5
L11:
	xorl %edi,%edi
L13:
	cmpl %r13d,%edi
	jge L16
L14:
	movslq %ebx,%rax
	movq _buckets(,%rax,8),%rcx
	movq %rcx,(%rsi)
	movq %rsi,_buckets(,%rax,8)
	addq %r12,%rsi
	addl $1,%edi
	jmp L13
L16:
	movl %r13d,%eax
L5:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L21:
_malloc:
L22:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L23:
	addq $8,%rdi
	xorl %ebx,%ebx
L26:
	leal 5(%rbx),%ecx
	movl $1,%esi
	shlq %cl,%rsi
	cmpq %rsi,%rdi
	jbe L28
L27:
	addl $1,%ebx
	cmpl $26,%ebx
	jl L26
L28:
	cmpl $26,%ebx
	jnz L35
L33:
	xorl %eax,%eax
	jmp L24
L35:
	movslq %ebx,%rsi
	cmpq $0,_buckets(,%rsi,8)
	jnz L39
L37:
	movl %ebx,%edi
	call _refill
	cmpl $0,%eax
	jnz L39
L40:
	xorl %eax,%eax
	jmp L24
L39:
	movslq %ebx,%rsi
	movq _buckets(,%rsi,8),%rdi
	movq (%rdi),%rax
	movq %rax,_buckets(,%rsi,8)
	movl %ebx,4(%rdi)
	movl $1265200743,(%rdi)
	leaq 8(%rdi),%rax
L24:
	popq %rbx
	popq %rbp
	ret
L48:
_free:
L49:
	pushq %rbp
	movq %rsp,%rbp
L50:
	leaq -8(%rdi),%rsi
	movl -8(%rdi),%eax
	cmpl $1265200743,%eax
	jnz L51
L52:
	movl -4(%rdi),%eax
	movslq %eax,%rcx
	movq _buckets(,%rcx,8),%rcx
	movq %rcx,-8(%rdi)
	movslq %eax,%rdi
	movq %rsi,_buckets(,%rdi,8)
L51:
	popq %rbp
	ret
L58:
.globl _sbrk
.local _buckets
.comm _buckets, 208, 8
.globl _malloc
.globl _free

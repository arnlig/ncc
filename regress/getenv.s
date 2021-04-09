.text
_getenv:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq _environ(%rip),%rax
	movq %rax,%rsi
	cmpq $0,%rax
	jz L4
L7:
	cmpq $0,%rdi
	jnz L12
L4:
	xorl %eax,%eax
	jmp L3
L12:
	movq %rsi,%rax
	addq $8,%rsi
	movq (%rax),%rcx
	movq %rcx,%rax
	cmpq $0,%rcx
	jz L14
L13:
	movq %rdi,%rdx
L15:
	movzbl (%rdx),%ecx
	cmpl $0,%ecx
	jz L17
L18:
	movq %rax,%r8
	addq $1,%rax
	movzbl (%r8),%r8d
	cmpl %r8d,%ecx
	jnz L17
L16:
	addq $1,%rdx
	jmp L15
L17:
	movzbl (%rdx),%ecx
	cmpl $0,%ecx
	jnz L12
L25:
	movzbl (%rax),%ecx
	cmpl $61,%ecx
	jnz L12
L24:
	addq $1,%rax
	jmp L3
L14:
	xorl %eax,%eax
L3:
	popq %rbp
	ret
L35:
.globl _getenv
.globl _environ

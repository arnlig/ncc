.text
_strcmp:
L1:
	pushq %rbp
	movq %rsp,%rbp
L4:
	movzbl (%rdi),%eax
	movzbl (%rsi),%ecx
	incq %rsi
	cmpl %ecx,%eax
	jnz L6
L5:
	movzbl (%rdi),%eax
	incq %rdi
	cmpl $0,%eax
	jnz L4
L7:
	xorl %eax,%eax
	jmp L3
L6:
	cmpl $0,%eax
	jnz L13
L11:
	movl $-1,%eax
	jmp L3
L13:
	decq %rsi
	movzbl (%rsi),%eax
	cmpl $0,%eax
	jnz L17
L15:
	movl $1,%eax
	jmp L3
L17:
	movzbl (%rdi),%eax
	movzbl (%rsi),%esi
	subl %esi,%eax
L3:
	popq %rbp
	ret
L23:
.globl _strcmp

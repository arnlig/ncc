.text
_memcmp:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	cmpq $0,%rdx
	jz L6
L4:
	incq %rdx
L7:
	decq %rdx
	jz L6
L8:
	movzbl (%rdi),%eax
	incq %rdi
	movzbl (%rsi),%ecx
	incq %rsi
	cmpl %ecx,%eax
	jz L7
L12:
	decq %rdi
	movzbl (%rdi),%eax
	decq %rsi
	movzbl (%rsi),%esi
	subl %esi,%eax
	jmp L3
L6:
	xorl %eax,%eax
L3:
	popq %rbp
	ret
L19:
.globl _memcmp

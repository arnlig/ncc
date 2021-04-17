.text
_strncat:
L1:
	pushq %rbp
	movq %rsp,%rbp
L21:
	movq %rdi,%rax
	cmpq $0,%rdx
	jz L3
L7:
	movzbl (%rdi),%ecx
	incq %rdi
	cmpl $0,%ecx
	jnz L7
L9:
	decq %rdi
L10:
	movzbl (%rsi),%ecx
	incq %rsi
	movb %cl,(%rdi)
	movzbl %cl,%ecx
	incq %rdi
	cmpl $0,%ecx
	jz L3
L11:
	decq %rdx
	jnz L10
L15:
	movb $0,(%rdi)
L3:
	popq %rbp
	ret
L23:
.globl _strncat

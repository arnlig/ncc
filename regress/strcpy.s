.text
_strcpy:
L1:
	pushq %rbp
	movq %rsp,%rbp
L9:
	movq %rdi,%rax
L4:
	movzbl (%rsi),%ecx
	incq %rsi
	movb %cl,(%rdi)
	movzbl %cl,%ecx
	incq %rdi
	cmpl $0,%ecx
	jnz L4
L3:
	popq %rbp
	ret
L11:
.globl _strcpy

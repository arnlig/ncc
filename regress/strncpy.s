.text
_strncpy:
L1:
	pushq %rbp
	movq %rsp,%rbp
L26:
	movq %rdi,%rax
	cmpq $0,%rdx
	jz L3
L7:
	movzbl (%rsi),%ecx
	incq %rsi
	movb %cl,(%rdi)
	movzbl %cl,%ecx
	incq %rdi
	cmpl $0,%ecx
	jz L9
L10:
	decq %rdx
	jnz L7
L9:
	decq %rsi
	movzbl (%rsi),%esi
	cmpl $0,%esi
	jnz L3
L17:
	decq %rdx
	jz L3
L21:
	movb $0,(%rdi)
	incq %rdi
	decq %rdx
	jnz L21
L3:
	popq %rbp
	ret
L28:
.globl _strncpy

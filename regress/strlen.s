.text
_strlen:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq %rdi,%rax
L4:
	movzbl (%rax),%esi
	incq %rax
	cmpl $0,%esi
	jnz L4
L6:
	decq %rax
	subq %rdi,%rax
L3:
	popq %rbp
	ret
L11:
.globl _strlen

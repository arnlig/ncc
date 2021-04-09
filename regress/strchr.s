.text
_strchr:
L1:
	pushq %rbp
	movq %rsp,%rbp
L13:
	movq %rdi,%rax
	movzbl %sil,%esi
L4:
	movzbl (%rax),%edi
	cmpl %edi,%esi
	jz L3
L5:
	movq %rax,%rdi
	addq $1,%rax
	movzbl (%rdi),%edi
	cmpl $0,%edi
	jnz L4
L7:
	xorl %eax,%eax
L3:
	popq %rbp
	ret
L15:
.globl _strchr

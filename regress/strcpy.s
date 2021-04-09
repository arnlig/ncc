.text
_strcpy:
L1:
	pushq %rbp
	movq %rsp,%rbp
L9:
	movq %rdi,%rax
L4:
	movq %rsi,%rcx
	addq $1,%rsi
	movzbl (%rcx),%ecx
	movq %rdi,%rdx
	addq $1,%rdi
	movb %cl,(%rdx)
	movzbl %cl,%ecx
	cmpl $0,%ecx
	jnz L4
L3:
	popq %rbp
	ret
L11:
.globl _strcpy

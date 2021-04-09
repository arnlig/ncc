.text
_strlen:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq %rdi,%rax
L4:
	movq %rax,%rsi
	addq $1,%rax
	movzbl (%rsi),%esi
	cmpl $0,%esi
	jnz L4
L6:
	addq $-1,%rax
	subq %rdi,%rax
L3:
	popq %rbp
	ret
L11:
.globl _strlen

.text
_sigemptyset:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq $0,(%rdi)
	xorl %eax,%eax
L3:
	popq %rbp
	ret
L8:
.globl _sigemptyset

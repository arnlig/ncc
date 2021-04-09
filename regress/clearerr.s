.text
_clearerr:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movl 8(%rdi),%esi
	andl $-49,%esi
	movl %esi,8(%rdi)
L3:
	popq %rbp
	ret
L7:
.globl _clearerr

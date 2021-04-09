.text
_memchr:
L1:
	pushq %rbp
	movq %rsp,%rbp
L17:
	movq %rdi,%rax
	movzbl %sil,%esi
	cmpq $0,%rdx
	jz L6
L4:
	addq $1,%rdx
L7:
	addq $-1,%rdx
	cmpq $0,%rdx
	jbe L6
L8:
	movq %rax,%rdi
	addq $1,%rax
	movzbl (%rdi),%edi
	cmpl %esi,%edi
	jnz L7
L12:
	addq $-1,%rax
	jmp L3
L6:
	xorl %eax,%eax
L3:
	popq %rbp
	ret
L19:
.globl _memchr

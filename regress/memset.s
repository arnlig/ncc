.text
_memset:
L1:
	pushq %rbp
	movq %rsp,%rbp
L12:
	movq %rdi,%rax
	movq %rax,%rdi
	cmpq $0,%rdx
	jz L3
L4:
	addq $1,%rdx
L7:
	addq $-1,%rdx
	jz L3
L8:
	movq %rdi,%rcx
	addq $1,%rdi
	movb %sil,(%rcx)
	jmp L7
L3:
	popq %rbp
	ret
L14:
.globl _memset

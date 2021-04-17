.text
_memset:
L1:
	pushq %rbp
	movq %rsp,%rbp
L12:
	movq %rdi,%rax
	cmpq $0,%rdx
	jz L3
L4:
	incq %rdx
L7:
	decq %rdx
	jz L3
L8:
	movb %sil,(%rdi)
	incq %rdi
	jmp L7
L3:
	popq %rbp
	ret
L14:
.globl _memset

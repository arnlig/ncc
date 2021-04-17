.text
_memcpy:
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
	movzbl (%rsi),%ecx
	incq %rsi
	movb %cl,(%rdi)
	incq %rdi
	jmp L7
L3:
	popq %rbp
	ret
L14:
.globl _memcpy

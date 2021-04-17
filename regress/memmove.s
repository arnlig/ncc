.text
_memmove:
L1:
	pushq %rbp
	movq %rsp,%rbp
L22:
	movq %rdi,%rax
	movq %rsi,%rcx
	cmpq $0,%rdx
	jz L3
L4:
	cmpq %rax,%rsi
	ja L8
L10:
	addq %rdx,%rsi
	cmpq %rax,%rsi
	jbe L8
L7:
	leaq (%rax,%rdx),%rdi
	incq %rdx
L14:
	decq %rdx
	jz L3
L15:
	decq %rsi
	movzbl (%rsi),%ecx
	decq %rdi
	movb %cl,(%rdi)
	jmp L14
L8:
	incq %rdx
L17:
	decq %rdx
	jz L3
L18:
	movzbl (%rcx),%esi
	incq %rcx
	movb %sil,(%rdi)
	incq %rdi
	jmp L17
L3:
	popq %rbp
	ret
L24:
.globl _memmove

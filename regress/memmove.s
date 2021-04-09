.text
_memmove:
L1:
	pushq %rbp
	movq %rsp,%rbp
L22:
	movq %rdi,%rax
	movq %rax,%rdi
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
	addq $1,%rdx
L14:
	addq $-1,%rdx
	jz L3
L15:
	addq $-1,%rsi
	movzbl (%rsi),%ecx
	addq $-1,%rdi
	movb %cl,(%rdi)
	jmp L14
L8:
	addq $1,%rdx
L17:
	addq $-1,%rdx
	jz L3
L18:
	movq %rcx,%rsi
	addq $1,%rcx
	movzbl (%rsi),%esi
	movq %rdi,%r8
	addq $1,%rdi
	movb %sil,(%r8)
	jmp L17
L3:
	popq %rbp
	ret
L24:
.globl _memmove

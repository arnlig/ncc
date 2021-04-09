.text
_strcat:
L1:
	pushq %rbp
	movq %rsp,%rbp
L12:
	movq %rdi,%rax
L4:
	movq %rdi,%rcx
	addq $1,%rdi
	movzbl (%rcx),%ecx
	cmpl $0,%ecx
	jnz L4
L6:
	addq $-1,%rdi
L7:
	movq %rsi,%rcx
	addq $1,%rsi
	movzbl (%rcx),%ecx
	movq %rdi,%rdx
	addq $1,%rdi
	movb %cl,(%rdx)
	movzbl %cl,%ecx
	cmpl $0,%ecx
	jnz L7
L3:
	popq %rbp
	ret
L14:
.globl _strcat

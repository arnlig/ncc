.text
_sigaction:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
L6:
	movq %rsi,%rax
	leaq -32(%rbp),%rsi
	movups (%rax),%xmm0
	movups %xmm0,-32(%rbp)
	movups 16(%rax),%xmm0
	movups %xmm0,-16(%rbp)
	orq $67108864,-24(%rbp)
	movq $___sigreturn,-16(%rbp)
	call ___sigaction
L3:
	movq %rbp,%rsp
	popq %rbp
	ret
L8:
.globl ___sigreturn
.globl _sigaction
.globl ___sigaction

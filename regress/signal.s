.text
_signal:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
L10:
	movq %rsi,%rax
	leaq -32(%rbp),%rsi
	xorps %xmm0,%xmm0
	movups %xmm0,-32(%rbp)
	movups %xmm0,-16(%rbp)
	leaq -64(%rbp),%rdx
	xorps %xmm0,%xmm0
	movups %xmm0,-64(%rbp)
	movups %xmm0,-48(%rbp)
	movq %rax,-32(%rbp)
	movl $3221225472,%eax
	movq %rax,-24(%rbp)
	call _sigaction
	cmpl $-1,%eax
	jnz L5
L4:
	movq $-1,%rax
	jmp L3
L5:
	movq -64(%rbp),%rax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret
L12:
.globl _signal
.globl _sigaction

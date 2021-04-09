.text
_dtof:
L2:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L61:
	movq %rdi,%rax
	cmpl $0,%ecx
	jge L8
L5:
	movq %rax,%rdi
	addq $1,%rax
	movb $48,(%rdi)
	jmp L7
L8:
	movzbl (%rsi),%edi
	cmpl $0,%edi
	jz L12
L11:
	movq %rsi,%rdi
	addq $1,%rsi
	movzbl (%rdi),%edi
	jmp L13
L12:
	movl $48,%edi
L13:
	movq %rax,%rbx
	addq $1,%rax
	movb %dil,(%rbx)
	movl %ecx,%edi
	addl $-1,%ecx
	cmpl $0,%edi
	jnz L8
L7:
	cmpl $0,%r9d
	jnz L16
L17:
	cmpl $0,%edx
	jz L4
L21:
	cmpl $103,%r8d
	jz L25
L29:
	cmpl $71,%r8d
	jnz L16
L25:
	movzbl (%rsi),%edi
	cmpl $0,%edi
	jz L4
L16:
	movq %rax,%rdi
	addq $1,%rax
	movb $46,(%rdi)
L34:
	movl %edx,%edi
	addl $-1,%edx
	cmpl $0,%edi
	jle L4
L35:
	cmpl $103,%r8d
	jz L44
L48:
	cmpl $71,%r8d
	jnz L39
L44:
	movzbl (%rsi),%edi
	cmpl $0,%edi
	jnz L39
L40:
	cmpl $0,%r9d
	jz L4
L39:
	addl $1,%ecx
	cmpl $0,%ecx
	jge L54
L53:
	movq %rax,%rdi
	addq $1,%rax
	movb $48,(%rdi)
	jmp L34
L54:
	movzbl (%rsi),%edi
	cmpl $0,%edi
	jz L57
L56:
	movq %rsi,%rdi
	addq $1,%rsi
	movzbl (%rdi),%edi
	jmp L58
L57:
	movl $48,%edi
L58:
	movq %rax,%rbx
	addq $1,%rax
	movb %dil,(%rbx)
	jmp L34
L4:
	popq %rbx
	popq %rbp
	ret
L63:
.align 8
L134:
	.quad 0x0
.align 8
L135:
	.quad 0x400a934f0979a371
.align 8
L137:
	.quad 0x4024000000000000
.align 8
L138:
	.quad 0x4014000000000000
.align 8
L142:
	.quad 0x3fb999999999999a
.align 8
L143:
	.quad 0x3ff0000000000000
_dtoa:
L65:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	movsd %xmm10,-40(%rbp)
L132:
	movl %edi,-32(%rbp)	 # spill
	movq %rcx,-24(%rbp)	 # spill
	movl %edx,%r15d
	movq %r8,%rbx
	movq %rbx,%r12
	movsd (%rsi),%xmm10
	ucomisd L134(%rip),%xmm10
	jz L71
L70:
	leaq -8(%rbp),%rsi
	movsd %xmm10,%xmm0
	movq %rsi,%rdi
	call _frexp
	leaq -16(%rbp),%rsi
	movl -8(%rbp),%edi
	addl $-1,%edi
	movl %edi,-8(%rbp)
	cvtsi2sdl %edi,%xmm0
	divsd L135(%rip),%xmm0
	movq %rsi,%rdi
	call _modf
	ucomisd L134(%rip),%xmm0
	jae L75
L73:
	movsd -16(%rbp),%xmm0
	subsd L143(%rip),%xmm0
	movsd %xmm0,-16(%rbp)
L75:
	movsd -16(%rbp),%xmm0
	cvtsd2sil %xmm0,%r14d
	movl %r14d,%r13d
	movl %r14d,%esi
	negl %esi
	movl %esi,%edi
	call ___pow10
	mulsd %xmm0,%xmm10
	ucomisd L137(%rip),%xmm10
	jb L78
L76:
	leal 1(%r14),%r13d
	mulsd L142(%rip),%xmm10
L78:
	movq -24(%rbp),%r10	 # spill
	movl %r13d,(%r10)
	cmpl $101,-32(%rbp)	 # spill
	jz L79
L82:
	cmpl $69,-32(%rbp)	 # spill
	jnz L80
L79:
	leal 1(%r15),%eax
	jmp L81
L80:
	cmpl $102,-32(%rbp)	 # spill
	jnz L87
L86:
	leal 1(%r15,%r13),%eax
	jmp L81
L87:
	movl %r15d,%eax
L81:
	cmpl $0,%eax
	jg L90
L89:
	cmpl $0,%eax
	jnz L71
L95:
	ucomisd L138(%rip),%xmm10
	ja L99
L71:
	movq -24(%rbp),%r10	 # spill
	movl $0,(%r10)
	movq %r12,%rsi
	movb $48,(%rsi)
	movb $0,1(%rbx)
	jmp L67
L90:
	cmpl $15,%eax
	jle L105
L102:
	movl $15,%eax
L105:
	movslq %eax,%rsi
	addq %rbx,%rsi
	cmpq %rsi,%r12
	jae L108
L109:
	ucomisd L134(%rip),%xmm10
	jz L108
L106:
	cvtsd2sil %xmm10,%esi
	leal 48(%rsi),%edi
	movq %r12,%rcx
	addq $1,%r12
	movb %dil,(%rcx)
	cvtsi2sdl %esi,%xmm0
	subsd %xmm0,%xmm10
	mulsd L137(%rip),%xmm10
	jmp L105
L108:
	movb $0,(%r12)
	ucomisd L138(%rip),%xmm10
	ja L124
L116:
	addq $-1,%r12
	cmpq %r12,%rbx
	jz L67
L119:
	movzbl (%r12),%esi
	cmpl $48,%esi
	jnz L67
L117:
	movb $0,(%r12)
	jmp L116
L124:
	movq %r12,%rsi
	addq $-1,%r12
	cmpq %rsi,%rbx
	jz L126
L125:
	movzbl (%r12),%esi
	addl $1,%esi
	movb %sil,(%r12)
	movzbl %sil,%esi
	cmpl $57,%esi
	jle L67
L129:
	movb $0,(%r12)
	jmp L124
L126:
	addq $1,%r12
L99:
	movq -24(%rbp),%r10	 # spill
	addl $1,(%r10)
	movq %r12,%rsi
	addq $1,%r12
	movb $49,(%rsi)
	movb $0,(%r12)
L67:
	movsd -40(%rbp),%xmm10
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L144:
.align 8
L204:
	.quad 0xbff0000000000000
___dtefg:
L145:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L201:
	movq %rdi,%rbx
	movl %edx,%r15d
	movq %r9,%rdi
	movl %ecx,%r13d
	movl %r8d,%r12d
	movsd (%rsi),%xmm0
	movsd %xmm0,-32(%rbp)
	cmpl $0,%r13d
	jnz L149
L151:
	cmpl $103,%r15d
	jz L148
L155:
	cmpl $71,%r15d
	jnz L149
L148:
	movl $1,%r13d
	jmp L150
L149:
	cmpl $-1,%r13d
	jnz L150
L159:
	movl $6,%r13d
L150:
	movsd -32(%rbp),%xmm0
	ucomisd L134(%rip),%xmm0
	jae L163
L162:
	mulsd L204(%rip),%xmm0
	movsd %xmm0,-32(%rbp)
	movl $-1,(%rdi)
	jmp L164
L163:
	movl $1,(%rdi)
L164:
	leaq -16(%rbp),%rax
	leaq -24(%rbp),%rcx
	leaq -32(%rbp),%rsi
	movl %r15d,%edi
	movl %r13d,%edx
	movq %rax,%r8
	call _dtoa
	cmpl $101,%r15d
	jz L166
L169:
	cmpl $69,%r15d
	jz L166
L165:
	cmpl $103,%r15d
	jz L173
L177:
	cmpl $71,%r15d
	jnz L167
L173:
	movl -24(%rbp),%esi
	cmpl $-4,%esi
	jl L166
L181:
	cmpl %r13d,%esi
	jl L167
L166:
	movl $1,%r14d
	xorl %eax,%eax
	jmp L187
L167:
	xorl %r14d,%r14d
	movl -24(%rbp),%eax
L187:
	leaq -16(%rbp),%rsi
	movq %rbx,%rdi
	movl %r13d,%edx
	movl %eax,%ecx
	movl %r15d,%r8d
	movl %r12d,%r9d
	call _dtof
	movq %rax,%rbx
	movq %rbx,%rax
	cmpl $0,%r14d
	jz L147
L188:
	cmpl $69,%r15d
	jz L191
L194:
	cmpl $71,%r15d
	jnz L192
L191:
	movl $69,%edi
	jmp L193
L192:
	movl $101,%edi
L193:
	leaq 1(%rbx),%rsi
	movb %dil,(%rax)
	movl -24(%rbp),%edi
	pushq %rdi
	pushq $L198
	pushq %rsi
	call _sprintf
	addq $24,%rsp
	movslq %eax,%rsi
	leaq 1(%rbx,%rsi),%rax
L147:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L205:
L198:
	.byte 37,43,48,51,100,0
.globl ___pow10
.globl _modf
.globl _sprintf
.globl ___dtefg
.globl _frexp

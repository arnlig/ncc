.data
.align 1
_digits:
	.byte 48
	.byte 49
	.byte 50
	.byte 51
	.byte 52
	.byte 53
	.byte 54
	.byte 55
	.byte 56
	.byte 57
	.byte 65
	.byte 66
	.byte 67
	.byte 68
	.byte 69
	.byte 70
.align 1
_ldigits:
	.byte 48
	.byte 49
	.byte 50
	.byte 51
	.byte 52
	.byte 53
	.byte 54
	.byte 55
	.byte 56
	.byte 57
	.byte 97
	.byte 98
	.byte 99
	.byte 100
	.byte 101
	.byte 102
.text
_convert:
L4:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
L18:
	movl %edx,%r8d
	cmpl $120,%ecx
	jnz L8
L7:
	movq $_ldigits,%rcx
	jmp L9
L8:
	movq $_digits,%rcx
L9:
	leaq -2(%rbp),%r9
	movb $0,-2(%rbp)
L10:
	movl %r8d,%ebx
	movq %rsi,%rax
	xorl %edx,%edx
	divq %rbx
	movzbl (%rcx,%rdx),%eax
	addq $-1,%r9
	movb %al,(%r9)
	movq %rsi,%rax
	xorl %edx,%edx
	divq %rbx
	movq %rax,%rsi
	cmpq $0,%rsi
	jnz L10
L13:
	movzbl (%r9),%esi
	cmpl $0,%esi
	jz L15
L14:
	movq %r9,%rsi
	addq $1,%r9
	movzbl (%rsi),%esi
	movq %rdi,%rax
	addq $1,%rdi
	movb %sil,(%rax)
	jmp L13
L15:
	movq %rdi,%rax
L6:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L20:
_vfprintf:
L21:
	pushq %rbp
	movq %rsp,%rbp
	subq $624,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L339:
	movq %rdx,-576(%rbp)	 # spill
	movq %rsi,%rbx
	movq %rdi,%r12
	xorl %r10d,%r10d
	movl %r10d,-536(%rbp)	 # spill
L28:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $37,%esi
	jz L30
L29:
	cmpl $0,%esi
	jnz L33
L31:
	movl -536(%rbp),%eax	 # spill
L23:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L33:
	addl $1,-536(%rbp)	 # spill
	movl (%r12),%edi
	addl $-1,%edi
	movl %edi,(%r12)
	cmpl $0,%edi
	jl L36
L35:
	movq 24(%r12),%rdi
	movq %rdi,%rax
	addq $1,%rdi
	movq %rdi,24(%r12)
	movb %sil,(%rax)
	jmp L28
L36:
	movl %esi,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L28
L30:
	xorl %eax,%eax
	xorl %r10d,%r10d
	movl %r10d,-544(%rbp)	 # spill
	xorl %r10d,%r10d
	movl %r10d,-552(%rbp)	 # spill
	xorl %r10d,%r10d
	movl %r10d,-560(%rbp)	 # spill
	movl $32,-568(%rbp)	 # spill
L39:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	cmpl $32,%esi
	jz L50
L306:
	cmpl $35,%esi
	jz L52
L307:
	cmpl $43,%esi
	jz L48
L308:
	cmpl $45,%esi
	jz L46
L309:
	cmpl $48,%esi
	jz L54
L41:
	cmpl $42,%esi
	jnz L59
L58:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movl -8(%r10),%esi
	movl %esi,-584(%rbp)	 # spill
	cmpl $0,%esi
	jge L63
L61:
	movl $1,-560(%rbp)	 # spill
	negl %esi
	movl %esi,-584(%rbp)	 # spill
L63:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	jmp L60
L59:
	xorl %r10d,%r10d
	movl %r10d,-584(%rbp)	 # spill
L64:
	cmpl $48,%ecx
	jl L60
L68:
	cmpl $57,%ecx
	jg L60
L65:
	movl -584(%rbp),%esi	 # spill
	imull $10,%esi
	leal -48(%rsi,%rcx),%esi
	movl %esi,-584(%rbp)	 # spill
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	jmp L64
L60:
	cmpl $46,%ecx
	jnz L73
L72:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	cmpl $42,%esi
	jnz L76
L75:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movl -8(%r10),%esi
	movl %esi,%r13d
	cmpl $0,%esi
	jge L80
L78:
	movl $-1,%r13d
L80:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	jmp L74
L76:
	xorl %r13d,%r13d
L81:
	cmpl $48,%ecx
	jl L74
L85:
	cmpl $57,%ecx
	jg L74
L82:
	movl %r13d,%esi
	imull $10,%esi
	leal -48(%rsi,%rcx),%esi
	movl %esi,%r13d
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	jmp L81
L73:
	movl $-1,%r13d
L74:
	cmpl $108,%ecx
	jz L89
L100:
	cmpl $104,%ecx
	jz L89
L96:
	cmpl $76,%ecx
	jz L89
L92:
	cmpl $122,%ecx
	jnz L90
L89:
	cmpl $122,%ecx
	jz L106
L105:
	movl %ecx,-592(%rbp)	 # spill
L106:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movl %esi,%ecx
	jmp L91
L90:
	xorl %r10d,%r10d
	movl %r10d,-592(%rbp)	 # spill
L91:
	leaq -512(%rbp),%r10
	movq %r10,-600(%rbp)	 # spill
	movq -600(%rbp),%r14	 # spill
	movq %r14,%r15
	xorl %r10d,%r10d
	movl %r10d,-608(%rbp)	 # spill
	xorl %r10d,%r10d
	movl %r10d,-616(%rbp)	 # spill
	xorl %r10d,%r10d
	movl %r10d,-624(%rbp)	 # spill
	movl $0,-520(%rbp)
	cmpl $105,%ecx
	jz L112
	jb L312
L326:
	cmpl $115,%ecx
	jz L175
	jb L327
L334:
	cmpl $120,%ecx
	jz L130
	ja L108
L335:
	cmpl $117,%ecx
	jnz L108
L127:
	movl $10,%edx
	jmp L125
L327:
	cmpl $111,%ecx
	jz L124
	jb L328
L331:
	cmpl $112,%ecx
	jnz L108
L192:
	movl $108,-592(%rbp)	 # spill
	movl $16,%r13d
	addl $1,%eax
	movl $88,%ecx
	movl $16,%edx
	jmp L131
L328:
	cmpl $110,%ecx
	jnz L108
L194:
	cmpl $104,-592(%rbp)	 # spill
	jnz L196
L195:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movq -8(%r10),%rsi
	movl -536(%rbp),%r10d	 # spill
	movw %r10w,(%rsi)
	jmp L109
L196:
	cmpl $108,-592(%rbp)	 # spill
	jnz L199
L198:
	movl -536(%rbp),%r10d	 # spill
	movslq %r10d,%rdi
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movq -8(%r10),%rsi
	movq %rdi,(%rsi)
	jmp L109
L199:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movq -8(%r10),%rsi
	movl -536(%rbp),%r10d	 # spill
	movl %r10d,(%rsi)
	jmp L109
L124:
	movl $8,%edx
	jmp L125
L175:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movq -8(%r10),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jnz L178
L176:
	movq $L179,%rsi
L178:
	movq %rsi,%r14
	movq %r14,%r15
L180:
	movq %r15,%rdi
	addq $1,%r15
	movzbl (%rdi),%edi
	cmpl $0,%edi
	jz L182
L181:
	cmpl $0,%r13d
	jl L180
L186:
	movq %r15,%rdi
	subq %rsi,%rdi
	movslq %r13d,%rax
	cmpq %rax,%rdi
	jle L180
L182:
	addq $-1,%r15
	jmp L109
L312:
	cmpl $99,%ecx
	jz L173
	jb L313
L320:
	cmpl $101,%ecx
	jae L325
L321:
	cmpl $100,%ecx
	jz L112
	jnz L108
L325:
	cmpl $103,%ecx
	jbe L171
	ja L108
L313:
	cmpl $71,%ecx
	jz L171
	jb L314
L317:
	cmpl $88,%ecx
	jnz L108
L130:
	movl $16,%edx
L125:
	cmpl $108,-592(%rbp)	 # spill
	jnz L132
L131:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movq -8(%r10),%rsi
	jmp L136
L132:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movl -8(%r10),%esi
	movslq %esi,%rdi
	movq %rdi,%rsi
	cmpl $104,-592(%rbp)	 # spill
	jnz L136
L134:
	movzwq %di,%rsi
L136:
	cmpl $0,%eax
	jz L122
L140:
	cmpq $0,%rsi
	jz L144
L148:
	cmpl $8,%edx
	jz L137
L144:
	cmpl $16,%edx
	jnz L122
L137:
	movl %ecx,-616(%rbp)	 # spill
	jmp L122
L314:
	cmpl $69,%ecx
	jz L171
L108:
	addl $1,-536(%rbp)	 # spill
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L203
L202:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb %cl,(%rdi)
	jmp L28
L203:
	movl %ecx,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L28
L171:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movsd -8(%r10),%xmm0
	leaq -528(%rbp),%rsi
	movsd %xmm0,-528(%rbp)
	leaq -520(%rbp),%r9
	movq -600(%rbp),%rdi	 # spill
	movl %ecx,%edx
	movl %r13d,%ecx
	movl %eax,%r8d
	call ___dtefg
	movq %rax,%rsi
	movq %rsi,%r15
	jmp L109
L173:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movl -8(%r10),%edi
	movq %r15,%rsi
	leaq -511(%rbp),%r15
	movb %dil,(%rsi)
	jmp L109
L112:
	movl $10,%edx
	cmpl $108,-592(%rbp)	 # spill
	jnz L114
L113:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movq -8(%r10),%rsi
	jmp L118
L114:
	addq $8,-576(%rbp)	 # spill
	movq -576(%rbp),%r10	 # spill
	movl -8(%r10),%esi
	movslq %esi,%rdi
	movq %rdi,%rsi
	cmpl $104,-592(%rbp)	 # spill
	jnz L118
L116:
	movswq %di,%rsi
L118:
	cmpq $0,%rsi
	jge L120
L119:
	negq %rsi
	addl $-1,-520(%rbp)
	jmp L122
L120:
	addl $1,-520(%rbp)
L122:
	cmpl $0,%r13d
	jnz L154
L155:
	cmpq $0,%rsi
	jz L109
L154:
	cmpl $-1,%r13d
	jz L162
L160:
	movl $32,-568(%rbp)	 # spill
L162:
	movq -600(%rbp),%rdi	 # spill
	call _convert
	movq %rax,%rsi
	movq %rsi,%r15
	subq -600(%rbp),%rsi	 # spill
	movq %rsi,%rdi
	movl %r13d,%esi
	subl %edi,%esi
	movl %esi,-624(%rbp)	 # spill
	cmpl $0,%esi
	jge L109
L163:
	xorl %r10d,%r10d
	movl %r10d,-624(%rbp)	 # spill
L109:
	movq %r15,%rsi
	subq %r14,%rsi
	movq %rsi,%rax
	movl -520(%rbp),%edi
	cmpl $0,%edi
	jz L208
L209:
	cmpl $-1,%edi
	jz L206
L217:
	cmpl $0,-552(%rbp)	 # spill
	jnz L206
L213:
	cmpl $0,-544(%rbp)	 # spill
	jz L208
L206:
	leal 1(%rax),%esi
	movl $1,-608(%rbp)	 # spill
L208:
	cmpl $0,-616(%rbp)	 # spill
	jz L223
L221:
	addl $1,%esi
	addl $1,-608(%rbp)	 # spill
	cmpl $111,-616(%rbp)	 # spill
	jz L223
L224:
	addl $1,%esi
L223:
	movl -584(%rbp),%edi	 # spill
	subl -624(%rbp),%edi	 # spill
	subl %esi,%edi
	movl %edi,%r13d
	cmpl $0,%edi
	jge L229
L227:
	xorl %r13d,%r13d
L229:
	addl %r13d,%esi
	addl -624(%rbp),%esi	 # spill
	addl %esi,-536(%rbp)	 # spill
	cmpl $0,-560(%rbp)	 # spill
	jnz L232
L233:
	cmpl $0,%r13d
	jle L232
L230:
	cmpl $0,-608(%rbp)	 # spill
	jz L244
L240:
	cmpl $48,-568(%rbp)	 # spill
	jnz L244
L237:
	addl %r13d,-624(%rbp)	 # spill
	jmp L232
L244:
	movl %r13d,%esi
	addl $-1,%r13d
	cmpl $0,%esi
	jle L232
L245:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L248
L247:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movl -568(%rbp),%r10d	 # spill
	movb %r10b,(%rdi)
	jmp L244
L248:
	movl -568(%rbp),%edi	 # spill
	movq %r12,%rsi
	call ___flushbuf
	jmp L244
L232:
	movl -520(%rbp),%esi
	cmpl $0,%esi
	jz L252
L250:
	cmpl $-1,%esi
	jnz L254
L253:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L257
L256:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb $45,(%rdi)
	jmp L252
L257:
	movl $45,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L252
L254:
	cmpl $0,-552(%rbp)	 # spill
	jz L260
L259:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L263
L262:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb $43,(%rdi)
	jmp L252
L263:
	movl $43,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L252
L260:
	cmpl $0,-544(%rbp)	 # spill
	jz L252
L265:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L269
L268:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb $32,(%rdi)
	jmp L252
L269:
	movl $32,%edi
	movq %r12,%rsi
	call ___flushbuf
L252:
	cmpl $0,-616(%rbp)	 # spill
	jz L283
L271:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L275
L274:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb $48,(%rdi)
	jmp L276
L275:
	movl $48,%edi
	movq %r12,%rsi
	call ___flushbuf
L276:
	cmpl $111,-616(%rbp)	 # spill
	jz L283
L277:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L281
L280:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movl -616(%rbp),%r10d	 # spill
	movb %r10b,(%rdi)
	jmp L283
L281:
	movl -616(%rbp),%edi	 # spill
	movq %r12,%rsi
	call ___flushbuf
L283:
	movl -624(%rbp),%esi	 # spill
	addl $-1,-624(%rbp)	 # spill
	cmpl $0,%esi
	jle L285
L284:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L287
L286:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb $48,(%rdi)
	jmp L283
L287:
	movl $48,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L283
L285:
	movq %r15,%rsi
	subq %r14,%rsi
	movl %esi,%r15d
L289:
	movl %r15d,%esi
	addl $-1,%r15d
	cmpl $0,%esi
	jle L291
L290:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L293
L292:
	movq %r14,%rsi
	addq $1,%r14
	movzbl (%rsi),%esi
	movq 24(%r12),%rdi
	movq %rdi,%rax
	addq $1,%rdi
	movq %rdi,24(%r12)
	movb %sil,(%rax)
	jmp L289
L293:
	movq %r14,%rsi
	addq $1,%r14
	movzbl (%rsi),%esi
	movl %esi,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L289
L291:
	cmpl $0,-560(%rbp)	 # spill
	jz L28
L298:
	movl %r13d,%esi
	addl $-1,%r13d
	cmpl $0,%esi
	jle L28
L299:
	movl (%r12),%esi
	addl $-1,%esi
	movl %esi,(%r12)
	cmpl $0,%esi
	jl L302
L301:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	addq $1,%rsi
	movq %rsi,24(%r12)
	movb $32,(%rdi)
	jmp L298
L302:
	movl $32,%edi
	movq %r12,%rsi
	call ___flushbuf
	jmp L298
L54:
	movl $48,-568(%rbp)	 # spill
	jmp L39
L46:
	addl $1,-560(%rbp)	 # spill
	jmp L39
L48:
	addl $1,-552(%rbp)	 # spill
	jmp L39
L52:
	addl $1,%eax
	jmp L39
L50:
	addl $1,-544(%rbp)	 # spill
	jmp L39
L341:
L179:
	.byte 123,78,85,76,76,125,0
.globl _vfprintf
.globl ___dtefg
.globl ___flushbuf

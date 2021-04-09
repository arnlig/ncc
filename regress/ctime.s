.data
.align 1
_tzdstdef:
	.byte 49,46,49,46,52,58,45,49
	.byte 46,49,46,49,48,58,50,58
	.byte 54,48,46,46,46,46,46,46
	.byte 0
.align 1
_daynames:
	.byte 83,117,110,77,111,110,84,117
	.byte 101,87,101,100,84,104,117,70
	.byte 114,105,83,97,116,0
.align 1
_dpm:
	.byte 31
	.byte 28
	.byte 31
	.byte 30
	.byte 31
	.byte 30
	.byte 31
	.byte 31
	.byte 30
	.byte 31
	.byte 30
	.byte 31
.align 4
_dstadjust:
	.int 3600
.align 1
_dsthour:
	.byte 2
.align 1
_dsttimes:
	.byte 1
	.byte 0
	.byte 3
	.byte 255
	.byte 0
	.byte 9
.align 1
_months:
	.byte 74,97,110,70,101,98,77,97
	.byte 114,65,112,114,77,97,121,74
	.byte 117,110,74,117,108,65,117,103
	.byte 83,101,112,79,99,116,78,111
	.byte 118,68,101,99,0
.align 1
_timestr:
	.byte 65,65,65,32,65,65,65,32
	.byte 68,68,32,68,68,58,68,68
	.byte 58,68,68,32,68,68,68,68
	.byte 10,0
.align 1
_tz0:
	.byte 71,77,84,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
.align 1
_tz1:
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
.align 8
_tzname:
	.quad _tz0
	.quad _tz1
.text
_isleap:
L13:
	pushq %rbp
	movq %rsp,%rbp
L14:
	movl $4000,%esi
	movl %edi,%eax
	cltd
	idivl %esi
	cmpl $0,%edx
	jnz L18
L16:
	xorl %eax,%eax
	jmp L15
L18:
	movl $400,%esi
	movl %edi,%eax
	cltd
	idivl %esi
	cmpl $0,%edx
	jz L21
L20:
	movl $100,%esi
	movl %edi,%eax
	cltd
	idivl %esi
	cmpl $0,%edx
	jz L22
L24:
	movl $4,%esi
	movl %edi,%eax
	cltd
	idivl %esi
	cmpl $0,%edx
	jnz L22
L21:
	movl $1,%eax
	jmp L15
L22:
	xorl %eax,%eax
L15:
	popq %rbp
	ret
L32:
_nthday:
L34:
	pushq %rbp
	movq %rsp,%rbp
L35:
	movzbl (%rdi),%esi
	movl %esi,%ecx
	cmpl $0,%esi
	jnz L39
L37:
	movzbl 1(%rdi),%eax
	jmp L36
L39:
	movl _tm+12(%rip),%eax
	movl _tm+24(%rip),%edx
	subl %edx,%eax
	movzbl 1(%rdi),%edi
	addl %edi,%eax
	cmpl $0,%esi
	jle L50
L44:
	cmpl $0,%eax
	jle L47
L45:
	addl $-7,%eax
	jmp L44
L47:
	addl $7,%eax
	addl $-1,%ecx
	cmpl $0,%ecx
	jle L36
	jg L47
L50:
	movl _tm+16(%rip),%esi
	movslq %esi,%rsi
	movzbl _dpm(%rsi),%esi
	cmpl %esi,%eax
	jge L53
L51:
	addl $7,%eax
	jmp L50
L53:
	addl $-7,%eax
	addl $1,%ecx
	cmpl $0,%ecx
	jl L53
L36:
	popq %rbp
	ret
L60:
_isdaylight:
L62:
	pushq %rbp
	movq %rsp,%rbp
L63:
	movq _tzname+8(%rip),%rsi
	movzbl (%rsi),%esi
	cmpl $0,%esi
	jnz L67
L65:
	xorl %eax,%eax
	jmp L64
L67:
	movl _tm+16(%rip),%esi
	movzbl _dsttimes+2(%rip),%edi
	movzbl _dsttimes+5(%rip),%eax
	cmpl %eax,%edi
	jg L72
L76:
	cmpl %edi,%esi
	jl L69
L80:
	cmpl %eax,%esi
	jg L69
L72:
	cmpl %eax,%edi
	jle L70
L84:
	cmpl %edi,%esi
	jge L70
L88:
	cmpl %eax,%esi
	jle L70
L69:
	xorl %eax,%eax
	jmp L64
L70:
	cmpl %edi,%esi
	jnz L94
L93:
	movq $_dsttimes,%rdi
	call _nthday
	movl _tm+12(%rip),%esi
	cmpl %eax,%esi
	jz L98
L96:
	cmpl %eax,%esi
	setg %sil
	movzbl %sil,%eax
	jmp L64
L98:
	movl _tm+8(%rip),%esi
	movzbl _dsthour(%rip),%edi
	cmpl %edi,%esi
	setge %sil
	movzbl %sil,%eax
	jmp L64
L94:
	cmpl %eax,%esi
	jnz L102
L101:
	movq $_dsttimes+3,%rdi
	call _nthday
	movl _tm+12(%rip),%esi
	cmpl %eax,%esi
	jz L106
L104:
	cmpl %eax,%esi
	setl %sil
	movzbl %sil,%eax
	jmp L64
L106:
	movl _tm+8(%rip),%esi
	movzbl _dsthour(%rip),%edi
	addl $-1,%edi
	cmpl %edi,%esi
	setl %sil
	movzbl %sil,%eax
	jmp L64
L102:
	movl $1,%eax
L64:
	popq %rbp
	ret
L113:
_setdst:
L115:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L180:
	movq %rdi,%rbx
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L120
L118:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes(%rip)
L121:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L123
L124:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $46,%esi
	jnz L121
L123:
	movq %rbx,%rdi
	call _atoi
	leal -1(%rax),%esi
	movb %sil,_dsttimes+1(%rip)
L128:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L130
L131:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $46,%esi
	jnz L128
L130:
	movq %rbx,%rdi
	call _atoi
	leal -1(%rax),%esi
	movb %sil,_dsttimes+2(%rip)
L135:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L120
L138:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $58,%esi
	jnz L135
L120:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L144
L142:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsttimes+3(%rip)
L145:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L147
L148:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $46,%esi
	jnz L145
L147:
	movq %rbx,%rdi
	call _atoi
	leal -1(%rax),%esi
	movb %sil,_dsttimes+4(%rip)
L152:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L154
L155:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $46,%esi
	jnz L152
L154:
	movq %rbx,%rdi
	call _atoi
	leal -1(%rax),%esi
	movb %sil,_dsttimes+5(%rip)
L159:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L144
L162:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $58,%esi
	jnz L159
L144:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L168
L166:
	movq %rbx,%rdi
	call _atoi
	movb %al,_dsthour(%rip)
L169:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L168
L172:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $58,%esi
	jnz L169
L168:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L117
L176:
	movq %rbx,%rdi
	call _atoi
	imull $60,%eax
	movl %eax,_dstadjust(%rip)
L117:
	popq %rbx
	popq %rbp
	ret
L182:
.data
.align 4
L186:
	.int 0
.text
_tzset:
L183:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L184:
	movl L186(%rip),%esi
	cmpl $0,%esi
	jnz L185
L189:
	movl $1,L186(%rip)
	movq $L194,%rdi
	call _getenv
	movq %rax,%rbx
	cmpq $0,%rax
	jz L185
L193:
	movq $0,_timezone(%rip)
	movq _tzname(%rip),%rsi
L196:
	movzbl (%rbx),%edi
	cmpl $0,%edi
	jz L198
L203:
	cmpl $58,%edi
	jz L198
L199:
	movq _tzname(%rip),%rdi
	addq $31,%rdi
	cmpq %rdi,%rsi
	jae L198
L197:
	movq %rbx,%rdi
	addq $1,%rbx
	movzbl (%rdi),%edi
	movq %rsi,%rax
	addq $1,%rsi
	movb %dil,(%rax)
	jmp L196
L198:
	movb $0,(%rsi)
L207:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L209
L210:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $58,%esi
	jnz L207
L209:
	movq %rbx,%rdi
	call _atoi
	movslq %eax,%rsi
	imulq $60,%rsi
	movq %rsi,_timezone(%rip)
L214:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L216
L217:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $58,%esi
	jnz L214
L216:
	movq _tzname+8(%rip),%rdi
L221:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L223
L228:
	cmpl $58,%esi
	jz L223
L224:
	movq _tzname+8(%rip),%rsi
	addq $31,%rsi
	cmpq %rsi,%rdi
	jae L223
L222:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	movq %rdi,%rax
	addq $1,%rdi
	movb %sil,(%rax)
	jmp L221
L223:
	movb $0,(%rdi)
L232:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L234
L235:
	movq %rbx,%rsi
	addq $1,%rbx
	movzbl (%rsi),%esi
	cmpl $58,%esi
	jnz L232
L234:
	movq _tzname+8(%rip),%rsi
	movzbl (%rsi),%esi
	cmpl $0,%esi
	jz L185
L241:
	movq $_tzdstdef,%rdi
	call _setdst
	movq %rbx,%rdi
	call _setdst
L185:
	popq %rbx
	popq %rbp
	ret
L246:
_gmtime:
L247:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L248:
	movq (%rdi),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jge L252
L250:
	xorl %esi,%esi
L252:
	movl $86400,%edi
	movq %rsi,%rax
	cqto
	idivq %rdi
	movq %rax,%rdi
	movl %edi,%ebx
	movl $86400,%ecx
	movq %rsi,%rax
	cqto
	idivq %rcx
	movq %rdx,%rsi
	movl $3600,%ecx
	movq %rsi,%rax
	cqto
	idivq %rcx
	movl %eax,_tm+8(%rip)
	movl $3600,%ecx
	movq %rsi,%rax
	cqto
	idivq %rcx
	movq %rdx,%rsi
	movl $60,%ecx
	movq %rsi,%rax
	cqto
	idivq %rcx
	movl %eax,_tm+4(%rip)
	movl $60,%ecx
	movq %rsi,%rax
	cqto
	idivq %rcx
	movl %edx,_tm(%rip)
	leal 4(%rdi),%eax
	movl $7,%esi
	xorl %edx,%edx
	divl %esi
	movl %edx,%r12d
	movl $1970,%r13d
L254:
	movl %r13d,%edi
	call _isleap
	cmpl $0,%eax
	jz L258
L257:
	movl $366,%esi
	jmp L259
L258:
	movl $365,%esi
L259:
	cmpl %esi,%ebx
	jae L262
L256:
	leal -1900(%r13),%esi
	movl %esi,_tm+20(%rip)
	movl %ebx,_tm+28(%rip)
	movl %r12d,_tm+24(%rip)
	movl %r13d,%edi
	call _isleap
	cmpl $0,%eax
	jz L265
L264:
	movb $29,_dpm+1(%rip)
	jmp L266
L265:
	movb $28,_dpm+1(%rip)
L266:
	movq $_dpm,%rdi
L267:
	cmpq $_dpm+12,%rdi
	jae L270
L271:
	movzbl (%rdi),%esi
	cmpl %esi,%ebx
	jb L270
L268:
	subl %esi,%ebx
	addq $1,%rdi
	jmp L267
L270:
	subq $_dpm,%rdi
	movl %edi,_tm+16(%rip)
	leal 1(%rbx),%esi
	movl %esi,_tm+12(%rip)
	movq $_tm,%rax
L249:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L262:
	addl $1,%r13d
	subl %esi,%ebx
	jmp L254
L279:
_localtime:
L280:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L288:
	movq %rdi,%rbx
	call _tzset
	movq (%rbx),%rsi
	movq _timezone(%rip),%rdi
	subq %rdi,%rsi
	leaq -8(%rbp),%r12
	movq %rsi,-8(%rbp)
	movq %r12,%rdi
	call _gmtime
	call _isdaylight
	cmpl $0,%eax
	jz L284
L283:
	movq (%rbx),%rsi
	movq _timezone(%rip),%rdi
	subq %rdi,%rsi
	movl _dstadjust(%rip),%edi
	movslq %edi,%rdi
	addq %rdi,%rsi
	movq %rsi,-8(%rbp)
	movq %r12,%rdi
	call _gmtime
	movl $1,_tm+32(%rip)
	jmp L285
L284:
	movl $0,_tm+32(%rip)
L285:
	movq $_tm,%rax
L282:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L290:
_asctime:
L291:
	pushq %rbp
	movq %rsp,%rbp
L292:
	movl 24(%rdi),%esi
	movl %esi,%eax
	cmpl $7,%esi
	jb L296
L294:
	xorl %eax,%eax
L296:
	imull $3,%eax
	movl %eax,%esi
	leaq _daynames(%rsi),%rcx
	leaq _daynames+1(%rsi),%rax
	movzbl (%rcx),%ecx
	movb %cl,_timestr(%rip)
	movzbl (%rax),%eax
	movb %al,_timestr+1(%rip)
	movzbl _daynames+2(%rsi),%esi
	movb %sil,_timestr+2(%rip)
	movb $32,_timestr+3(%rip)
	movl 16(%rdi),%esi
	movl %esi,%eax
	cmpl $12,%esi
	jb L299
L297:
	xorl %eax,%eax
L299:
	imull $3,%eax
	movl %eax,%esi
	leaq _months(%rsi),%rcx
	leaq _months+1(%rsi),%rax
	movzbl (%rcx),%ecx
	movb %cl,_timestr+4(%rip)
	movzbl (%rax),%eax
	movb %al,_timestr+5(%rip)
	movzbl _months+2(%rsi),%esi
	movb %sil,_timestr+6(%rip)
	movb $32,_timestr+7(%rip)
	movl 12(%rdi),%esi
	cmpl $10,%esi
	jb L301
L300:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+8(%rip)
	jmp L302
L301:
	movb $32,_timestr+8(%rip)
L302:
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	leal 48(%rdx),%esi
	movb %sil,_timestr+9(%rip)
	movb $32,_timestr+10(%rip)
	movl 8(%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+11(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	leal 48(%rdx),%esi
	movb %sil,_timestr+12(%rip)
	movb $58,_timestr+13(%rip)
	movl 4(%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+14(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	leal 48(%rdx),%esi
	movb %sil,_timestr+15(%rip)
	movb $58,_timestr+16(%rip)
	movl (%rdi),%esi
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	addl $48,%eax
	movb %al,_timestr+17(%rip)
	movl $10,%ecx
	movl %esi,%eax
	xorl %edx,%edx
	divl %ecx
	leal 48(%rdx),%esi
	movb %sil,_timestr+18(%rip)
	movb $32,_timestr+19(%rip)
	movl 20(%rdi),%esi
	addl $1900,%esi
	movl $1000,%edi
	movl %esi,%eax
	xorl %edx,%edx
	divl %edi
	leal 48(%rax),%edi
	movb %dil,_timestr+20(%rip)
	movl $1000,%edi
	movl %esi,%eax
	xorl %edx,%edx
	divl %edi
	movl %edx,%esi
	movl $100,%edi
	movl %esi,%eax
	xorl %edx,%edx
	divl %edi
	leal 48(%rax),%edi
	movb %dil,_timestr+21(%rip)
	movl $100,%edi
	movl %esi,%eax
	xorl %edx,%edx
	divl %edi
	movl %edx,%esi
	movl $10,%edi
	movl %esi,%eax
	xorl %edx,%edx
	divl %edi
	leal 48(%rax),%edi
	movb %dil,_timestr+22(%rip)
	movl $10,%edi
	movl %esi,%eax
	xorl %edx,%edx
	divl %edi
	leal 48(%rdx),%esi
	movb %sil,_timestr+23(%rip)
	movb $10,_timestr+24(%rip)
	movb $0,_timestr+25(%rip)
	movq $_timestr,%rax
L293:
	popq %rbp
	ret
L307:
_ctime:
L308:
	pushq %rbp
	movq %rsp,%rbp
L309:
	call _localtime
	movq %rax,%rdi
	call _asctime
L310:
	popq %rbp
	ret
L315:
L194:
	.byte 84,73,77,69,90,79,78,69
	.byte 0
.globl _tzset
.comm _timezone, 8, 8
.globl _timezone
.local _tm
.comm _tm, 36, 4
.globl _tzname
.globl _gmtime
.globl _localtime
.globl _ctime
.globl _asctime
.globl _getenv
.globl _atoi

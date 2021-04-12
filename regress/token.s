.data
.align 8
_pool:
	.quad 0
	.quad _pool
.text
_alloc:
L3:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L20:
	movl %edi,%ebx
	movq _pool(%rip),%rsi
	cmpq $0,%rsi
	jnz L7
L6:
	movl $48,%edi
	call _safe_malloc
	movq %rax,%r12
	jmp L8
L7:
	movq %rsi,%r12
	movq 32(%rsi),%rdi
	cmpq $0,%rdi
	jz L13
L12:
	movq 40(%rsi),%rax
	movq %rax,40(%rdi)
	jmp L14
L13:
	movq 40(%rsi),%rdi
	movq %rdi,_pool+8(%rip)
L14:
	movq 32(%rsi),%rdi
	movq 40(%rsi),%rsi
	movq %rdi,(%rsi)
L8:
	movl %ebx,(%r12)
	testl $2147483648,%ebx
	jnz L17
L15:
	leaq 8(%r12),%rdi
	call _vstring_init
L17:
	movq %r12,%rax
L5:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L22:
_token_number:
L23:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
L24:
	leaq -24(%rbp),%rbx
	pushq %rdi
	pushq $L26
	pushq %rbx
	call _sprintf
	addq $24,%rsp
	movl $51,%edi
	call _alloc
	movq %rax,%r12
	leaq 8(%r12),%rdi
	movq %rbx,%rsi
	call _vstring_puts
	movq %r12,%rax
L25:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L31:
_backslash:
L33:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L44:
	movl %esi,%ebx
	movq %rdi,%r12
	cmpl $92,%ebx
	jz L36
L39:
	cmpl $34,%ebx
	jnz L38
L36:
	movq %r12,%rdi
	movl $92,%esi
	call _vstring_putc
L38:
	movq %r12,%rdi
	movl %ebx,%esi
	call _vstring_putc
L35:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L46:
_token_string:
L47:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L55:
	movq %rdi,%rbx
	movl $52,%edi
	call _alloc
	movq %rax,%r12
	leaq 8(%rax),%rdi
	movl $34,%esi
	call _vstring_putc
L50:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jz L52
L51:
	movzbl (%rbx),%esi
	addq $1,%rbx
	leaq 8(%r12),%rdi
	call _backslash
	jmp L50
L52:
	leaq 8(%r12),%rdi
	movl $34,%esi
	call _vstring_putc
	movq %r12,%rax
L49:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L57:
_token_int:
L58:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L63:
	movq %rdi,%rbx
	movl $-2147483592,%edi
	call _alloc
	movq %rbx,8(%rax)
L60:
	popq %rbx
	popq %rbp
	ret
L65:
_token_convert_number:
L66:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L90:
	movq %rdi,%r12
	movl $-2147483592,%r13d
	movl $0,_errno(%rip)
	leaq -8(%rbp),%rsi
	movl 8(%r12),%edi
	testl $1,%edi
	jz L70
L69:
	leaq 9(%r12),%rdi
	jmp L71
L70:
	movq 24(%r12),%rdi
L71:
	xorl %edx,%edx
	call _strtoul
	movq %rax,%rbx
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $76,%eax
	jnz L74
L72:
	addq $1,-8(%rbp)
L74:
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $85,%eax
	jnz L77
L75:
	movl $-2147483591,%r13d
L77:
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $76,%eax
	jnz L80
L78:
	addq $1,-8(%rbp)
L80:
	movq -8(%rbp),%rsi
	movzbl (%rsi),%esi
	cmpl $0,%esi
	jnz L81
L84:
	movl _errno(%rip),%esi
	cmpl $0,%esi
	jz L83
L81:
	pushq $L88
	call _error
	addq $8,%rsp
L83:
	leaq 8(%r12),%rdi
	call _vstring_free
	movl %r13d,(%r12)
	movq %rbx,8(%r12)
L68:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L92:
_token_convert_char:
L93:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L108:
	movq %rdi,%r12
	movl 8(%r12),%esi
	testl $1,%esi
	jz L97
L96:
	leaq 9(%r12),%rsi
	jmp L98
L97:
	movq 24(%r12),%rsi
L98:
	leaq -8(%rbp),%rdi
	movq %rsi,-8(%rbp)
	addq $1,%rsi
	movq %rsi,-8(%rbp)
	call _escape
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L101
L99:
	pushq $L102
	call _error
	addq $8,%rsp
L101:
	movq -8(%rbp),%rsi
	movzbl (%rsi),%esi
	cmpl $39,%esi
	jz L105
L103:
	pushq $L106
	call _error
	addq $8,%rsp
L105:
	leaq 8(%r12),%rdi
	call _vstring_free
	movl $-2147483592,(%r12)
	movslq %ebx,%rsi
	movq %rsi,8(%r12)
L95:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L110:
_token_free:
L111:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L124:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L117
L114:
	leaq 8(%rbx),%rdi
	call _vstring_free
L117:
	movq _pool(%rip),%rdi
	leaq 32(%rbx),%rsi
	movq %rdi,32(%rbx)
	cmpq $0,%rdi
	jz L121
L120:
	movq _pool(%rip),%rdi
	movq %rsi,40(%rdi)
	jmp L122
L121:
	movq %rsi,_pool+8(%rip)
L122:
	movq %rbx,_pool(%rip)
	movq $_pool,40(%rbx)
L113:
	popq %rbx
	popq %rbp
	ret
L126:
_token_space:
L127:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L128:
	movl $48,%edi
	call _alloc
	movq %rax,%rbx
	leaq 8(%rbx),%rdi
	movl $32,%esi
	call _vstring_putc
	movq %rbx,%rax
L129:
	popq %rbx
	popq %rbp
	ret
L134:
.data
.align 4
_modifiers:
	.int 536870935
	.int 536870937
	.int 536870936
	.int 536870938
	.int 0
	.int 536870939
	.int 0
	.int 536870940
	.int 0
	.int 536870941
	.int 536873247
	.int 536870942
	.int 536873505
	.int 536870944
	.int 0
	.int 536870946
	.int 536871689
	.int 536871971
	.int 0
	.int 536870948
	.int 536871691
	.int 536871973
	.int 0
	.int 536870950
	.int 1610612778
	.int 0
	.int 0
	.int 536872213
	.int 0
	.int 536872214
.text
_token_separate:
L136:
	pushq %rbp
	movq %rsp,%rbp
L246:
	cmpl $49,%edi
	jz L143
L247:
	cmpl $51,%edi
	jz L152
L248:
	cmpl $536870952,%edi
	jz L170
L249:
	cmpl $536871425,%edi
	jnz L140
L184:
	cmpl $536871944,%esi
	jz L185
L196:
	cmpl $536871971,%esi
	jz L185
L192:
	cmpl $536871689,%esi
	jz L185
L188:
	cmpl $536870948,%esi
	jnz L140
L185:
	movl $1,%eax
	jmp L138
L140:
	movl %edi,%eax
	andl $255,%eax
	movslq %eax,%rcx
	cmpq $15,%rcx
	jae L141
L203:
	movslq %eax,%rcx
	movl _modifiers+4(,%rcx,8),%ecx
	cmpl $0,%ecx
	jz L207
L208:
	cmpl $536870925,%esi
	jz L205
L212:
	cmpl $536872213,%esi
	jnz L207
L205:
	movl $1,%eax
	jmp L138
L207:
	movslq %eax,%rcx
	movl _modifiers(,%rcx,8),%eax
	cmpl $0,%eax
	jz L141
L217:
	cmpl %edi,%esi
	jz L220
L227:
	cmpl %eax,%esi
	jz L220
L223:
	movl _modifiers+4(,%rcx,8),%edi
	cmpl %edi,%esi
	jnz L222
L220:
	movl $1,%eax
	jmp L138
L222:
	andl $255,%eax
	movslq %eax,%rdi
	cmpq $15,%rdi
	jae L141
L234:
	movslq %eax,%rdi
	movl _modifiers(,%rdi,8),%eax
	cmpl %eax,%esi
	jz L236
L239:
	movl _modifiers+4(,%rdi,8),%edi
	cmpl %edi,%esi
	jnz L141
L236:
	movl $1,%eax
	jmp L138
L170:
	cmpl $536870952,%esi
	jz L171
L178:
	cmpl $536870953,%esi
	jz L171
L174:
	cmpl $51,%esi
	jnz L141
L171:
	movl $1,%eax
	jmp L138
L143:
	cmpl $49,%esi
	jz L144
L147:
	cmpl $51,%esi
	jnz L152
L144:
	movl $1,%eax
	jmp L138
L152:
	cmpl $49,%esi
	jz L153
L164:
	cmpl $51,%esi
	jz L153
L160:
	cmpl $536870952,%esi
	jz L153
L156:
	cmpl $536870953,%esi
	jnz L141
L153:
	movl $1,%eax
	jmp L138
L141:
	xorl %eax,%eax
L138:
	popq %rbp
	ret
L253:
.data
.align 4
_classes:
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 48
	.int 0
	.int 48
	.int 48
	.int 48
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 0
	.int 48
	.int 536870926
	.int 52
	.int 1610612748
	.int 1073741883
	.int 536871172
	.int 536872453
	.int 53
	.int 536870927
	.int 536870928
	.int 536871170
	.int 536871424
	.int 536870959
	.int 536871425
	.int 536870952
	.int 536871171
	.int 51
	.int 51
	.int 51
	.int 51
	.int 51
	.int 51
	.int 51
	.int 51
	.int 51
	.int 51
	.int 536870956
	.int 536870955
	.int 536871946
	.int 536870925
	.int 536871944
	.int 536870957
	.int 1073741883
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 536870931
	.int 1073741883
	.int 536870932
	.int 536872711
	.int 49
	.int 1073741883
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 49
	.int 536870929
	.int 536872966
	.int 536870930
	.int 536870958
	.int 0
.text
_token_scan:
L255:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L384:
	movq %rsi,%r15
	movq %rdi,%r14
	movq %r14,%rbx
	movzbl (%r14),%esi
	movl %esi,%edi
	cmpl $0,%edi
	jle L259
L261:
	movzbq %sil,%rdi
	cmpq $128,%rdi
	jae L259
L258:
	movzbq %sil,%rsi
	movl _classes(,%rsi,4),%r12d
	jmp L375
L259:
	xorl %r12d,%r12d
L375:
	cmpl $0,%r12d
	jz L371
L376:
	cmpl $48,%r12d
	jz L334
L377:
	cmpl $49,%r12d
	jz L339
L378:
	cmpl $51,%r12d
	jz L310
L379:
	cmpl $52,%r12d
	jb L380
L381:
	cmpl $53,%r12d
	ja L380
L270:
	movl $1,%r13d
L272:
	movzbl (%rbx),%esi
	cmpl $0,%esi
	jnz L277
L275:
	cmpl $52,%r12d
	jnz L279
L278:
	pushq $L281
	call _error
	addq $8,%rsp
	jmp L277
L279:
	pushq $L282
	call _error
	addq $8,%rsp
L277:
	movzbl (%rbx),%esi
	movzbl (%r14),%edi
	addq $1,%rbx
	cmpl %edi,%esi
	jnz L285
L286:
	cmpl $0,%r13d
	jz L267
L285:
	cmpl $0,%r13d
	jnz L293
L291:
	movzbl -1(%rbx),%esi
	cmpl $92,%esi
	jnz L293
L292:
	movl $1,%r13d
	jmp L272
L293:
	xorl %r13d,%r13d
	jmp L272
L380:
	cmpl $536870952,%r12d
	jz L296
L382:
	cmpl $536871425,%r12d
	jnz L266
L347:
	movzbl 1(%r14),%esi
	cmpl $62,%esi
	jnz L266
L348:
	movl $536870951,%r12d
	leaq 2(%r14),%rbx
	jmp L267
L266:
	leaq 1(%r14),%rbx
L352:
	movl %r12d,%edi
	andl $255,%edi
	movslq %edi,%rsi
	cmpq $15,%rsi
	jae L267
L353:
	movzbl (%rbx),%esi
	movzbl (%r14),%eax
	cmpl %eax,%esi
	jnz L356
L358:
	movslq %edi,%rsi
	movl _modifiers(,%rsi,8),%esi
	cmpl $0,%esi
	jz L356
L355:
	movl %esi,%r12d
	addq $1,%rbx
	jmp L352
L356:
	movzbl (%rbx),%esi
	cmpl $61,%esi
	jnz L267
L365:
	movslq %edi,%rsi
	movl _modifiers+4(,%rsi,8),%esi
	cmpl $0,%esi
	jz L267
L362:
	movl %esi,%r12d
	addq $1,%rbx
	jmp L352
L296:
	movzbl 1(%r14),%esi
	cmpl $46,%esi
	jnz L298
L300:
	movzbl 2(%r14),%esi
	cmpl $46,%esi
	jnz L298
L297:
	leaq 3(%r14),%rbx
	movl $536870953,%r12d
	jmp L267
L298:
	movzbl (%r14),%esi
	addl $-48,%esi
	cmpl $10,%esi
	jb L310
L305:
	leaq 1(%r14),%rbx
	jmp L267
L310:
	movzbq (%rbx),%rsi
	movl %esi,%edi
	movzbl ___ctype+1(%rdi),%edi
	testl $7,%edi
	jnz L311
L317:
	movzbl %sil,%esi
	cmpl $46,%esi
	jz L311
L313:
	cmpl $95,%esi
	jnz L267
L311:
	movzbl (%rbx),%edi
	call _toupper
	cmpl $69,%eax
	jnz L323
L324:
	movzbl 1(%rbx),%esi
	cmpl $45,%esi
	jz L321
L328:
	cmpl $43,%esi
	jnz L323
L321:
	addq $1,%rbx
L323:
	addq $1,%rbx
	jmp L310
L339:
	movzbq (%rbx),%rsi
	movl %esi,%edi
	movzbl ___ctype+1(%rdi),%edi
	testl $7,%edi
	jnz L340
L342:
	movzbl %sil,%esi
	cmpl $95,%esi
	jnz L267
L340:
	addq $1,%rbx
	jmp L339
L334:
	movzbq (%rbx),%rsi
	movzbl ___ctype+1(%rsi),%esi
	testl $8,%esi
	jz L267
L335:
	addq $1,%rbx
	jmp L334
L371:
	movzbl (%r14),%esi
	andl $255,%esi
	pushq %rsi
	pushq $L372
	call _error
	addq $16,%rsp
L267:
	movl %r12d,%edi
	call _alloc
	movq %rax,%r12
	movq %rbx,%rdx
	subq %r14,%rdx
	leaq 8(%r12),%rdi
	movq %r14,%rsi
	call _vstring_put
	movq %rbx,(%r15)
	movq %r12,%rax
L257:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L386:
_token_paste:
L387:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L406:
	movq %rsi,%rbx
	leaq -24(%rbp),%r12
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	orl $1,-24(%rbp)
	movq %r12,%rsi
	call _token_text
	movq %rbx,%rdi
	movq %r12,%rsi
	call _token_text
	leaq -32(%rbp),%rsi
	movl -24(%rbp),%edi
	testl $1,%edi
	jz L391
L390:
	leaq -23(%rbp),%rdi
	jmp L392
L391:
	movq -8(%rbp),%rdi
L392:
	call _token_scan
	movq %rax,%rbx
	movq -32(%rbp),%rsi
	movzbl (%rsi),%esi
	cmpl $0,%esi
	jnz L393
L396:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jz L395
L393:
	movl -24(%rbp),%esi
	testl $1,%esi
	jz L402
L401:
	leaq -23(%rbp),%rsi
	jmp L403
L402:
	movq -8(%rbp),%rsi
L403:
	pushq %rsi
	pushq $L400
	call _error
	addq $16,%rsp
L395:
	movq %rbx,%rax
L389:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L408:
_token_same:
L409:
	pushq %rbp
	movq %rsp,%rbp
L410:
	movl (%rdi),%eax
	movl (%rsi),%ecx
	cmpl %ecx,%eax
	jnz L414
L412:
	testl $536870912,%eax
	jz L417
L415:
	movl $1,%eax
	jmp L411
L417:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L421
L419:
	movq 8(%rdi),%rdi
	movq 8(%rsi),%rsi
	cmpq %rsi,%rdi
	setz %sil
	movzbl %sil,%eax
	jmp L411
L421:
	addq $8,%rsi
	addq $8,%rdi
	call _vstring_same
	jmp L411
L414:
	xorl %eax,%eax
L411:
	popq %rbp
	ret
L428:
_token_copy:
L429:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L437:
	movq %rdi,%rbx
	movl (%rbx),%edi
	call _alloc
	movq %rax,%r12
	movl (%r12),%esi
	testl $2147483648,%esi
	jz L433
L432:
	movq 8(%rbx),%rsi
	movq %rsi,8(%r12)
	jmp L434
L433:
	leaq 8(%rbx),%rsi
	leaq 8(%r12),%rdi
	call _vstring_concat
L434:
	movq %r12,%rax
L431:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L439:
_token_text:
L440:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L454:
	movq %rsi,%r12
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L445
L443:
	pushq $L446
	call _error
	addq $8,%rsp
L445:
	movl 8(%rbx),%esi
	testl $1,%esi
	jz L448
L447:
	shll $24,%esi
	sarl $25,%esi
	movslq %esi,%rdx
	jmp L449
L448:
	movq 16(%rbx),%rdx
L449:
	movl 8(%rbx),%esi
	testl $1,%esi
	jz L451
L450:
	leaq 9(%rbx),%rsi
	jmp L452
L451:
	movq 24(%rbx),%rsi
L452:
	movq %r12,%rdi
	call _vstring_put
L442:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L456:
_token_dequote:
L457:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L475:
	movq %rsi,%r14
	movq %rdi,%rbx
	movl (%rbx),%esi
	cmpl $52,%esi
	jz L462
L460:
	pushq $L463
	call _error
	addq $8,%rsp
L462:
	movl 8(%rbx),%esi
	testl $1,%esi
	jz L465
L464:
	shll $24,%esi
	sarl $25,%esi
	movslq %esi,%r12
	jmp L466
L465:
	movq 16(%rbx),%r12
L466:
	movl 8(%rbx),%esi
	testl $1,%esi
	jz L468
L467:
	addq $9,%rbx
	jmp L469
L468:
	movq 24(%rbx),%rbx
L469:
	movl $1,%r13d
L470:
	leaq -1(%r12),%rsi
	cmpq %rsi,%r13
	jae L459
L471:
	addq $1,%rbx
	movzbl (%rbx),%esi
	movq %r14,%rdi
	call _vstring_putc
	addq $1,%r13
	jmp L470
L459:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L477:
_list_cut:
L478:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L495:
	movq %rdi,%rbx
	movq %rsi,%r12
L481:
	movq (%rbx),%rdi
	cmpq $0,%rdi
	jz L480
L482:
	cmpq %rdi,%r12
	jz L480
L488:
	movq 32(%rdi),%rsi
	cmpq $0,%rsi
	jz L492
L491:
	movq 40(%rdi),%rax
	movq %rax,40(%rsi)
	jmp L493
L492:
	movq 40(%rdi),%rsi
	movq %rsi,8(%rbx)
L493:
	movq 32(%rdi),%rsi
	movq 40(%rdi),%rax
	movq %rsi,(%rax)
	call _token_free
	jmp L481
L480:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L497:
_list_skip_spaces:
L498:
	pushq %rbp
	movq %rsp,%rbp
L510:
	movq %rdi,%rax
L501:
	cmpq $0,%rax
	jz L500
L504:
	movl (%rax),%esi
	cmpl $48,%esi
	jnz L500
L502:
	movq 32(%rax),%rax
	jmp L501
L500:
	popq %rbp
	ret
L512:
_list_fold_spaces:
L513:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L537:
	movq %rdi,%r12
	movq (%r12),%rbx
L516:
	cmpq $0,%rbx
	jz L515
L517:
	movl (%rbx),%esi
	cmpl $48,%esi
	jnz L518
L520:
	leaq 8(%rbx),%r13
	movq %r13,%rdi
	call _vstring_free
	movq %r13,%rdi
	call _vstring_init
	movq %r13,%rdi
	movl $32,%esi
	call _vstring_putc
L523:
	movq 32(%rbx),%rdi
	cmpq $0,%rdi
	jz L518
L526:
	movl (%rdi),%esi
	cmpl $48,%esi
	jnz L518
L530:
	movq 32(%rdi),%rsi
	cmpq $0,%rsi
	jz L534
L533:
	movq 40(%rdi),%rax
	movq %rax,40(%rsi)
	jmp L535
L534:
	movq 40(%rdi),%rsi
	movq %rsi,8(%r12)
L535:
	movq 32(%rdi),%rsi
	movq 40(%rdi),%rax
	movq %rsi,(%rax)
	call _token_free
	jmp L523
L518:
	movq 32(%rbx),%rbx
	jmp L516
L515:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L539:
_list_strip_ends:
L540:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L565:
	movq %rdi,%rbx
L543:
	movq (%rbx),%rsi
	movq %rsi,%rdi
	cmpq $0,%rsi
	jz L546
L550:
	movl (%rsi),%esi
	cmpl $48,%esi
	jz L558
L546:
	movq 8(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	movq %rsi,%rdi
	cmpq $0,%rsi
	jz L542
L554:
	movl (%rsi),%esi
	cmpl $48,%esi
	jnz L542
L558:
	movq 32(%rdi),%rsi
	cmpq $0,%rsi
	jz L562
L561:
	movq 40(%rdi),%rax
	movq %rax,40(%rsi)
	jmp L563
L562:
	movq 40(%rdi),%rsi
	movq %rsi,8(%rbx)
L563:
	movq 32(%rdi),%rsi
	movq 40(%rdi),%rax
	movq %rsi,(%rax)
	call _token_free
	jmp L543
L542:
	popq %rbx
	popq %rbp
	ret
L567:
_list_strip_all:
L568:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L595:
	movq %rdi,%rbx
	movq (%rbx),%rdi
L571:
	cmpq $0,%rdi
	jz L570
L572:
	movq 32(%rdi),%r12
	movl (%rdi),%esi
	cmpl $48,%esi
	jz L588
L577:
	cmpl $1073741883,%esi
	jnz L576
L581:
	movl 8(%rdi),%esi
	testl $1,%esi
	jz L586
L585:
	shll $24,%esi
	sarl $25,%esi
	movslq %esi,%rsi
	jmp L587
L586:
	movq 16(%rdi),%rsi
L587:
	cmpq $0,%rsi
	jnz L576
L588:
	movq 32(%rdi),%rsi
	cmpq $0,%rsi
	jz L592
L591:
	movq 40(%rdi),%rax
	movq %rax,40(%rsi)
	jmp L593
L592:
	movq 40(%rdi),%rsi
	movq %rsi,8(%rbx)
L593:
	movq 32(%rdi),%rsi
	movq 40(%rdi),%rax
	movq %rsi,(%rax)
	call _token_free
L576:
	movq %r12,%rdi
	jmp L571
L570:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L597:
_list_strip_around:
L598:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L616:
	movq %rdi,%r12
	movq %rsi,%rbx
L601:
	movq 40(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	cmpq $0,%rsi
	jz L608
L604:
	movl (%rsi),%edi
	cmpl $48,%edi
	jnz L608
L602:
	movq %r12,%rdi
	call _list_drop
	jmp L601
L608:
	movq 32(%rbx),%rsi
	cmpq $0,%rsi
	jz L600
L611:
	movl (%rsi),%edi
	cmpl $48,%edi
	jnz L600
L609:
	movq %r12,%rdi
	call _list_drop
	jmp L608
L600:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L618:
_list_pop:
L619:
	pushq %rbp
	movq %rsp,%rbp
L632:
	movq %rdi,%rcx
	movq (%rcx),%rdi
	movq 32(%rdi),%rax
	cmpq $0,%rax
	jz L626
L625:
	movq 40(%rdi),%rcx
	movq %rcx,40(%rax)
	jmp L627
L626:
	movq 40(%rdi),%rax
	movq %rax,8(%rcx)
L627:
	movq 32(%rdi),%rax
	movq 40(%rdi),%rcx
	movq %rax,(%rcx)
	cmpq $0,%rsi
	jz L629
L628:
	movq %rdi,(%rsi)
	jmp L621
L629:
	call _token_free
L621:
	popq %rbp
	ret
L634:
_list_drop:
L635:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L646:
	movq %rdi,%rax
	movq %rsi,%rdi
	movq 32(%rdi),%rbx
	cmpq $0,%rbx
	jz L642
L641:
	movq 40(%rdi),%rsi
	movq %rsi,40(%rbx)
	jmp L643
L642:
	movq 40(%rdi),%rsi
	movq %rsi,8(%rax)
L643:
	movq 32(%rdi),%rsi
	movq 40(%rdi),%rax
	movq %rsi,(%rax)
	call _token_free
	movq %rbx,%rax
L637:
	popq %rbx
	popq %rbp
	ret
L648:
_list_match:
L649:
	pushq %rbp
	movq %rsp,%rbp
L661:
	movl %esi,%eax
	movq %rdx,%rsi
	movq (%rdi),%rcx
	cmpq $0,%rcx
	jz L653
L655:
	movl (%rcx),%ecx
	cmpl %eax,%ecx
	jnz L653
L652:
	call _list_pop
	jmp L651
L653:
	pushq $L659
	call _error
	addq $8,%rsp
L651:
	popq %rbp
	ret
L663:
_list_same:
L664:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L665:
	movq (%rdi),%rbx
	movq (%rsi),%r12
L667:
	cmpq $0,%rbx
	jz L669
L674:
	cmpq $0,%r12
	jz L669
L670:
	movq %rbx,%rdi
	movq %r12,%rsi
	call _token_same
	cmpl $0,%eax
	jz L669
L668:
	movq 32(%rbx),%rbx
	movq 32(%r12),%r12
	jmp L667
L669:
	cmpq $0,%rbx
	jnz L678
L681:
	cmpq $0,%r12
	jz L679
L678:
	xorl %eax,%eax
	jmp L666
L679:
	movl $1,%eax
L666:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L690:
_list_normalize:
L691:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L717:
	movq %rdi,%r15
	movq %rsi,%rbx
	movq %r15,%rdi
	call _list_strip_ends
	movq %r15,%rdi
	call _list_fold_spaces
	movq (%r15),%rsi
L694:
	cmpq $0,%rsi
	jz L697
L695:
	movl (%rsi),%edi
	cmpl $1610612748,%edi
	jnz L700
L698:
	movl $1610612790,(%rsi)
L700:
	movl (%rsi),%edi
	cmpl $1610612778,%edi
	jnz L696
L701:
	movl $1610612791,(%rsi)
L696:
	movq 32(%rsi),%rsi
	jmp L694
L697:
	movq (%rbx),%r12
	xorl %r14d,%r14d
L704:
	cmpq $0,%r12
	jz L693
L705:
	movq (%r15),%rbx
	movslq %r14d,%r13
L708:
	cmpq $0,%rbx
	jz L706
L709:
	movq %r12,%rdi
	movq %rbx,%rsi
	call _token_same
	cmpl $0,%eax
	jz L710
L712:
	leaq 8(%rbx),%rdi
	call _vstring_free
	movl $-2147483590,(%rbx)
	movq %r13,8(%rbx)
L710:
	movq 32(%rbx),%rbx
	jmp L708
L706:
	movq 32(%r12),%r12
	addl $1,%r14d
	jmp L704
L693:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L719:
_list_stringize:
L720:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L758:
	movq %rdi,%r14
	movl $52,%edi
	call _alloc
	movq %rax,%r13
	leaq 8(%rax),%rdi
	movl $34,%esi
	call _vstring_putc
	movq (%r14),%rbx
L723:
	cmpq $0,%rbx
	jz L726
L724:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L729
L727:
	pushq $L730
	call _error
	addq $8,%rsp
L729:
	movl (%rbx),%esi
	cmpl $48,%esi
	jnz L733
L734:
	cmpq %rbx,(%r14)
	jz L725
L738:
	cmpq $0,32(%rbx)
	jz L725
L733:
	movl 8(%rbx),%esi
	testl $1,%esi
	jz L744
L743:
	leaq 9(%rbx),%r12
	jmp L746
L744:
	movq 24(%rbx),%r12
L746:
	movzbl (%r12),%esi
	cmpl $0,%esi
	jz L725
L747:
	movl (%rbx),%esi
	cmpl $52,%esi
	jz L749
L752:
	cmpl $53,%esi
	jnz L750
L749:
	movzbl (%r12),%esi
	addq $1,%r12
	leaq 8(%r13),%rdi
	call _backslash
	jmp L746
L750:
	movzbl (%r12),%esi
	addq $1,%r12
	leaq 8(%r13),%rdi
	call _vstring_putc
	jmp L746
L725:
	movq 32(%rbx),%rbx
	jmp L723
L726:
	leaq 8(%r13),%rdi
	movl $34,%esi
	call _vstring_putc
	movq %r13,%rax
L722:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L760:
_list_ennervate:
L761:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L776:
	movq %rsi,%r12
	movq (%rdi),%rbx
L764:
	cmpq $0,%rbx
	jz L763
L765:
	movl (%rbx),%esi
	cmpl $49,%esi
	jnz L766
L771:
	leaq 8(%rbx),%rdi
	movq %r12,%rsi
	call _vstring_same
	cmpl $0,%eax
	jz L766
L768:
	movl $1073741883,(%rbx)
L766:
	movq 32(%rbx),%rbx
	jmp L764
L763:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L778:
_list_copy:
L779:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L790:
	movq %rdi,%r12
	movq (%rsi),%rbx
L782:
	cmpq $0,%rbx
	jz L781
L783:
	movq %rbx,%rdi
	call _token_copy
	leaq 32(%rax),%rsi
	movq $0,32(%rax)
	movq 8(%r12),%rdi
	movq %rdi,40(%rax)
	movq 8(%r12),%rdi
	movq %rax,(%rdi)
	movq %rsi,8(%r12)
	movq 32(%rbx),%rbx
	jmp L782
L781:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L792:
_list_move:
L793:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L813:
	movq %rsi,%r14
	movq %rdi,%rbx
	movl %edx,%r13d
L796:
	movl %r13d,%esi
	addl $-1,%r13d
	cmpl $0,%esi
	jz L795
L797:
	movq (%r14),%r12
	cmpq $0,%r12
	jnz L803
L799:
	pushq $L802
	call _error
	addq $8,%rsp
L803:
	movq 32(%r12),%rsi
	cmpq $0,%rsi
	jz L807
L806:
	movq 40(%r12),%rdi
	movq %rdi,40(%rsi)
	jmp L808
L807:
	movq 40(%r12),%rsi
	movq %rsi,8(%r14)
L808:
	leaq 32(%r12),%rsi
	movq 32(%r12),%rdi
	movq 40(%r12),%rax
	movq %rdi,(%rax)
	movq $0,32(%r12)
	movq 8(%rbx),%rdi
	movq %rdi,40(%r12)
	movq 8(%rbx),%rdi
	movq %r12,(%rdi)
	movq %rsi,8(%rbx)
	jmp L796
L795:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L815:
_list_next_is:
L816:
	pushq %rbp
	movq %rsp,%rbp
L817:
	movq 32(%rsi),%rsi
L819:
	cmpq $0,%rsi
	jz L821
L822:
	movl (%rsi),%edi
	cmpl $48,%edi
	jnz L821
L820:
	movq 32(%rsi),%rsi
	jmp L819
L821:
	cmpq $0,%rsi
	jz L827
L829:
	movl (%rsi),%esi
	cmpl %edx,%esi
	jnz L827
L826:
	movl $1,%eax
	jmp L818
L827:
	xorl %eax,%eax
L818:
	popq %rbp
	ret
L838:
_list_prev_is:
L839:
	pushq %rbp
	movq %rsp,%rbp
L840:
	movq 40(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
L842:
	cmpq $0,%rsi
	jz L844
L845:
	movl (%rsi),%edi
	cmpl $48,%edi
	jnz L844
L843:
	movq 40(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	jmp L842
L844:
	cmpq $0,%rsi
	jz L850
L852:
	movl (%rsi),%esi
	cmpl %edx,%esi
	jnz L850
L849:
	movl $1,%eax
	jmp L841
L850:
	xorl %eax,%eax
L841:
	popq %rbp
	ret
L861:
_list_insert:
L862:
	pushq %rbp
	movq %rsp,%rbp
L863:
	cmpq $0,%rsi
	jz L871
L868:
	movq 40(%rsi),%rdi
	movq %rdi,40(%rdx)
	leaq 32(%rdx),%rdi
	movq %rsi,32(%rdx)
	movq 40(%rsi),%rax
	movq %rdx,(%rax)
	movq %rdi,40(%rsi)
	jmp L864
L871:
	leaq 32(%rdx),%rsi
	movq $0,32(%rdx)
	movq 8(%rdi),%rax
	movq %rax,40(%rdx)
	movq 8(%rdi),%rax
	movq %rdx,(%rax)
	movq %rsi,8(%rdi)
L864:
	popq %rbp
	ret
L877:
_list_insert_list:
L878:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L891:
	movq %rdx,%rbx
	movq %rdi,%r13
	movq %rsi,%r12
L881:
	movq (%rbx),%rdx
	cmpq $0,%rdx
	jz L880
L884:
	movq 32(%rdx),%rsi
	cmpq $0,%rsi
	jz L888
L887:
	movq 40(%rdx),%rdi
	movq %rdi,40(%rsi)
	jmp L889
L888:
	movq 40(%rdx),%rsi
	movq %rsi,8(%rbx)
L889:
	movq 32(%rdx),%rsi
	movq 40(%rdx),%rdi
	movq %rsi,(%rdi)
	movq %r13,%rdi
	movq %r12,%rsi
	call _list_insert
	jmp L881
L880:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L893:
_list_placeholder:
L894:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L904:
	movq %rdi,%rbx
	cmpq $0,(%rbx)
	jnz L896
L897:
	movl $1073741883,%edi
	call _alloc
	leaq 32(%rax),%rsi
	movq $0,32(%rax)
	movq 8(%rbx),%rdi
	movq %rdi,40(%rax)
	movq 8(%rbx),%rdi
	movq %rax,(%rdi)
	movq %rsi,8(%rbx)
L896:
	popq %rbx
	popq %rbp
	ret
L906:
L372:
	.byte 105,110,118,97,108,105,100,32
	.byte 99,104,97,114,97,99,116,101
	.byte 114,32,40,65,83,67,73,73
	.byte 32,37,100,41,32,105,110,32
	.byte 105,110,112,117,116,0
L802:
	.byte 67,80,80,32,73,78,84,69
	.byte 82,78,65,76,58,32,108,105
	.byte 115,116,95,109,111,118,101,0
L659:
	.byte 115,121,110,116,97,120,0
L282:
	.byte 117,110,116,101,114,109,105,110
	.byte 97,116,101,100,32,99,104,97
	.byte 114,32,99,111,110,115,116,97
	.byte 110,116,0
L106:
	.byte 109,117,108,116,105,45,99,104
	.byte 97,114,97,99,116,101,114,32
	.byte 99,111,110,115,116,97,110,116
	.byte 115,32,117,110,115,117,112,112
	.byte 111,114,116,101,100,0
L88:
	.byte 109,97,108,102,111,114,109,101
	.byte 100,32,105,110,116,101,103,101
	.byte 114,32,99,111,110,115,116,97
	.byte 110,116,0
L26:
	.byte 37,100,0
L102:
	.byte 105,110,118,97,108,105,100,32
	.byte 101,115,99,97,112,101,32,115
	.byte 101,113,117,101,110,99,101,0
L281:
	.byte 117,110,116,101,114,109,105,110
	.byte 97,116,101,100,32,115,116,114
	.byte 105,110,103,32,108,105,116,101
	.byte 114,97,108,0
L730:
	.byte 67,80,80,32,73,78,84,69
	.byte 82,78,65,76,58,32,99,97
	.byte 110,39,116,32,115,116,114,105
	.byte 110,103,105,122,101,32,97,32
	.byte 116,101,120,116,108,101,115,115
	.byte 32,116,111,107,101,110,0
L463:
	.byte 67,80,80,32,73,78,84,69
	.byte 82,78,65,76,58,32,99,97
	.byte 110,39,116,32,100,101,113,117
	.byte 111,116,101,32,110,111,110,45
	.byte 115,116,114,105,110,103,32,116
	.byte 111,107,101,110,0
L446:
	.byte 67,80,80,32,73,78,84,69
	.byte 82,78,65,76,58,32,99,97
	.byte 110,39,116,32,103,101,116,32
	.byte 116,101,120,116,32,111,102,32
	.byte 110,111,110,45,116,101,120,116
	.byte 32,116,111,107,101,110,0
L400:
	.byte 114,101,115,117,108,116,32,111
	.byte 102,32,112,97,115,116,101,32
	.byte 40,35,35,41,32,39,37,115
	.byte 39,32,105,115,32,110,111,116
	.byte 32,97,32,116,111,107,101,110
	.byte 0
.globl _list_drop
.globl _list_pop
.globl _list_placeholder
.globl _token_convert_char
.globl _token_convert_number
.globl _token_number
.globl _error
.globl _toupper
.globl _list_fold_spaces
.globl _list_skip_spaces
.globl _list_prev_is
.globl _list_next_is
.globl _vstring_putc
.globl _list_insert_list
.globl _list_strip_around
.globl _list_cut
.globl _vstring_concat
.globl _vstring_init
.globl _vstring_put
.globl _list_ennervate
.globl _list_move
.globl _list_stringize
.globl _list_normalize
.globl _token_separate
.globl _token_dequote
.globl _token_paste
.globl _escape
.globl ___ctype
.globl _sprintf
.globl _token_string
.globl _list_strip_all
.globl _errno
.globl _list_strip_ends
.globl _vstring_puts
.globl _safe_malloc
.globl _list_insert
.globl _token_text
.globl _token_int
.globl _list_same
.globl _token_space
.globl _token_same
.globl _token_free
.globl _vstring_same
.globl _vstring_free
.globl _list_match
.globl _list_copy
.globl _token_copy
.globl _strtoul
.globl _token_scan

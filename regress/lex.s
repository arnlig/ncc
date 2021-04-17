.data
.align 8
_begin:
	.quad _buf+4096
.align 8
_pos:
	.quad _buf+4096
.align 8
_invalid:
	.quad _buf+4096
.text
_refill:
L7:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L8:
	movq _pos(%rip),%rdi
	movq _invalid(%rip),%rdx
	movq %rdx,%rsi
	subq %rdi,%rsi
	cmpq $3,%rsi
	jge L9
L13:
	movl _fd(%rip),%esi
	cmpl $-1,%esi
	jz L9
L10:
	movq _begin(%rip),%rsi
	movq %rsi,%rbx
	subq $_buf,%rbx
	subq %rsi,%rdx
	movq $_buf,%rdi
	call _memmove
	subq %rbx,_begin(%rip)
	subq %rbx,_pos(%rip)
	movq _invalid(%rip),%rsi
	subq %rbx,%rsi
	movq %rsi,_invalid(%rip)
	movq $_buf+4096,%rbx
	subq %rsi,%rbx
	cmpq $0,%rbx
	jnz L19
L17:
	pushq $L20
	pushq $1
	call _error
	addq $16,%rsp
L19:
	movl _fd(%rip),%edi
	movq _invalid(%rip),%rsi
	movq %rbx,%rdx
	call _read
	movq %rax,%r12
	cmpq $-1,%r12
	jnz L23
L21:
	pushq $L24
	pushq $1
	call _error
	addq $16,%rsp
L23:
	movq _invalid(%rip),%rsi
	addq %r12,%rsi
	movq %rsi,_invalid(%rip)
	cmpq %rbx,%r12
	jae L9
L25:
	movb $0,(%rsi)
	movl _fd(%rip),%edi
	call _close
	movl $-1,_fd(%rip)
L9:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L31:
_ident:
L33:
	pushq %rbp
	movq %rsp,%rbp
L36:
	movq _pos(%rip),%rsi
	movzbq (%rsi),%rdi
	movl %edi,%eax
	movzbl ___ctype+1(%rax),%eax
	testl $7,%eax
	jnz L43
L39:
	movzbl %dil,%edi
	cmpl $95,%edi
	jnz L38
L43:
	movq _pos(%rip),%rdi
	incq %rdi
	movq %rdi,_pos(%rip)
	movq _invalid(%rip),%rsi
	subq %rdi,%rsi
	cmpq $3,%rsi
	jge L36
L46:
	call _refill
	jmp L36
L38:
	movq _begin(%rip),%rdi
	subq %rdi,%rsi
	call _string_new
	movq %rax,_token+8(%rip)
	movl 16(%rax),%eax
	testl $536870912,%eax
	jz L35
L49:
	movl $262145,%eax
L35:
	popq %rbp
	ret
L57:
_delimit:
L59:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L60:
	movq _pos(%rip),%rsi
	movzbl (%rsi),%r13d
	movl $1,%ebx
L62:
	movq _pos(%rip),%rsi
	movzbl (%rsi),%r12d
	cmpl $0,%r12d
	jz L64
L65:
	leaq 1(%rsi),%rdi
	movq %rdi,_pos(%rip)
	movq _invalid(%rip),%rsi
	subq %rdi,%rsi
	cmpq $3,%rsi
	jge L66
L68:
	call _refill
L66:
	cmpl %r13d,%r12d
	jnz L73
L74:
	cmpl $0,%ebx
	jz L61
L73:
	cmpl $0,%ebx
	jz L80
L79:
	xorl %ebx,%ebx
	jmp L62
L80:
	cmpl $92,%r12d
	setz %sil
	movzbl %sil,%ebx
	jmp L62
L64:
	cmpl $39,%r13d
	jnz L83
L82:
	pushq $L85
	pushq $1
	call _error
	addq $16,%rsp
	jmp L61
L83:
	pushq $L86
	pushq $1
	call _error
	addq $16,%rsp
L61:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L90:
_strlit:
L92:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L95:
	movq _pos(%rip),%rsi
	movzbl (%rsi),%esi
	cmpl $34,%esi
	jnz L97
L96:
	call _delimit
	movq _pos(%rip),%rbx
	subq _begin(%rip),%rbx
L98:
	movq _pos(%rip),%rsi
	movzbq (%rsi),%rdi
	movzbl ___ctype+1(%rdi),%edi
	testl $8,%edi
	jz L95
L101:
	leaq 1(%rsi),%rdi
	movq %rdi,_pos(%rip)
	movq _invalid(%rip),%rsi
	subq %rdi,%rsi
	cmpq $3,%rsi
	jge L98
L104:
	call _refill
	jmp L98
L97:
	movq _begin(%rip),%rsi
	addq %rbx,%rsi
	movq %rsi,_pos(%rip)
	movq _begin(%rip),%rsi
	movq %rsi,%r12
	incq %rsi
	movq %rsi,-8(%rbp)
L107:
	movq _pos(%rip),%rsi
	cmpq -8(%rbp),%rsi
	jz L109
L110:
	leaq -8(%rbp),%rdi
	movq -8(%rbp),%rsi
	movzbl (%rsi),%esi
	cmpl $34,%esi
	jz L117
L111:
	call _escape
	movl %eax,%ebx
	cmpl $-1,%ebx
	jnz L115
L113:
	pushq $L116
	pushq $1
	call _error
	addq $16,%rsp
L115:
	movb %bl,(%r12)
	incq %r12
	jmp L110
L117:
	movq -8(%rbp),%rsi
	incq %rsi
	movq %rsi,-8(%rbp)
	cmpq %rsi,_pos(%rip)
	jz L107
L120:
	movzbq (%rsi),%rsi
	movl %esi,%edi
	movzbl ___ctype+1(%rdi),%edi
	testl $8,%edi
	jz L107
L118:
	movzbl %sil,%esi
	cmpl $10,%esi
	jnz L117
L124:
	incl _error_line_no(%rip)
	jmp L117
L109:
	movq _begin(%rip),%rdi
	subq %rdi,%r12
	movq %r12,%rsi
	call _string_new
	movq %rax,_token+8(%rip)
	movl $2,%eax
L94:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L131:
_ccon:
L133:
	pushq %rbp
	movq %rsp,%rbp
L134:
	call _delimit
	incq _begin(%rip)
	movq $_begin,%rdi
	call _escape
	movslq %eax,%rsi
	movq %rsi,_token+8(%rip)
	cmpq $-1,%rsi
	jnz L138
L136:
	pushq $L139
	pushq $1
	call _error
	addq $16,%rsp
L138:
	movq _begin(%rip),%rsi
	movzbl (%rsi),%esi
	cmpl $39,%esi
	jz L142
L140:
	pushq $L143
	pushq $1
	call _error
	addq $16,%rsp
L142:
	movl $3,%eax
L135:
	popq %rbp
	ret
L148:
_number:
L150:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L151:
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L153:
	movq _pos(%rip),%rsi
	movzbq (%rsi),%rsi
	movl %esi,%edi
	movzbl ___ctype+1(%rdi),%edi
	testl $7,%edi
	jnz L154
L160:
	movzbl %sil,%esi
	cmpl $46,%esi
	jz L154
L156:
	cmpl $95,%esi
	jnz L155
L154:
	movq _pos(%rip),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $69,%eax
	jnz L175
L167:
	movq _pos(%rip),%rsi
	movzbl 1(%rsi),%esi
	cmpl $43,%esi
	jz L164
L171:
	cmpl $45,%esi
	jnz L175
L164:
	incq _pos(%rip)
L175:
	movq _pos(%rip),%rdi
	incq %rdi
	movq %rdi,_pos(%rip)
	movq _invalid(%rip),%rsi
	subq %rdi,%rsi
	cmpq $3,%rsi
	jge L153
L178:
	call _refill
	jmp L153
L155:
	movl $0,_errno(%rip)
	leaq -8(%rbp),%rsi
	movq _begin(%rip),%rdi
	xorl %edx,%edx
	call _strtoul
	movq %rax,_token+8(%rip)
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $85,%eax
	jnz L183
L181:
	movl $1,%r12d
	incq -8(%rbp)
L183:
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $76,%eax
	jnz L186
L184:
	movl $1,%ebx
	incq -8(%rbp)
L186:
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $85,%eax
	jnz L189
L187:
	movl $1,%r12d
	incq -8(%rbp)
L189:
	movq _pos(%rip),%rsi
	cmpq -8(%rbp),%rsi
	jnz L197
L193:
	movl _errno(%rip),%esi
	cmpl $0,%esi
	jz L192
L197:
	movl $0,_errno(%rip)
	leaq -8(%rbp),%rbx
	movq _begin(%rip),%rdi
	movq %rbx,%rsi
	call _strtod
	movsd %xmm0,_token+8(%rip)
	movq -8(%rbp),%rsi
	movzbl (%rsi),%edi
	call _toupper
	cmpl $70,%eax
	jz L246
L260:
	cmpl $76,%eax
	jz L244
L241:
	movl $8,_token(%rip)
	jmp L242
L244:
	movl $9,_token(%rip)
	incq -8(%rbp)
	jmp L242
L246:
	movq _begin(%rip),%rdi
	movq %rbx,%rsi
	call _strtof
	cvtss2sd %xmm0,%xmm0
	movsd %xmm0,_token+8(%rip)
	movl $7,_token(%rip)
	incq -8(%rbp)
L242:
	movq _pos(%rip),%rsi
	cmpq -8(%rbp),%rsi
	jz L251
L249:
	pushq $L252
	pushq $1
	call _error
	addq $16,%rsp
L251:
	movl _errno(%rip),%esi
	cmpl $0,%esi
	jz L255
L253:
	pushq $L256
	pushq $1
	call _error
	addq $16,%rsp
L255:
	movl _token(%rip),%eax
	jmp L152
L192:
	movzbl %bl,%esi
	cmpl $0,%esi
	jz L200
L202:
	movzbl %r12b,%esi
	cmpl $0,%esi
	jz L200
L199:
	movl $6,%eax
	jmp L152
L200:
	movzbl %bl,%esi
	cmpl $0,%esi
	jz L208
L207:
	movq _token+8(%rip),%rsi
	movq $9223372036854775807,%rdi
	cmpq %rdi,%rsi
	jbe L211
L210:
	movl $6,%eax
	jmp L152
L211:
	movl $5,%eax
	jmp L152
L208:
	movzbl %r12b,%esi
	cmpl $0,%esi
	jz L216
L215:
	movq _token+8(%rip),%rsi
	movl $4294967295,%edi
	cmpq %rdi,%rsi
	jbe L219
L218:
	movl $6,%eax
	jmp L152
L219:
	movl $4,%eax
	jmp L152
L216:
	movq _token+8(%rip),%rsi
	movq $9223372036854775807,%rdi
	cmpq %rdi,%rsi
	jbe L224
L223:
	movl $6,%eax
	jmp L152
L224:
	movl $4294967295,%edi
	cmpq %rdi,%rsi
	jbe L228
L227:
	movl $5,%eax
	jmp L152
L228:
	cmpq $2147483647,%rsi
	jbe L232
L231:
	movq _begin(%rip),%rsi
	movzbl (%rsi),%esi
	cmpl $48,%esi
	jnz L235
L234:
	movl $4,%eax
	jmp L152
L235:
	movl $5,%eax
	jmp L152
L232:
	movl $3,%eax
L152:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L264:
_lex0:
L266:
	pushq %rbp
	movq %rsp,%rbp
L267:
	movq _pos(%rip),%rsi
	movq %rsi,_begin(%rip)
	call _refill
L269:
	movq _pos(%rip),%rdi
	movzbq (%rdi),%rsi
	movl %esi,%eax
	movzbl ___ctype+1(%rax),%eax
	testl $8,%eax
	jz L271
L272:
	movzbl %sil,%esi
	cmpl $10,%esi
	jz L271
L276:
	incq %rdi
	movq %rdi,_pos(%rip)
	movq _invalid(%rip),%rsi
	subq %rdi,%rsi
	cmpq $3,%rsi
	jge L277
L279:
	call _refill
L277:
	movq _pos(%rip),%rsi
	movq %rsi,_begin(%rip)
	jmp L269
L271:
	movq _pos(%rip),%rdi
	movzbl (%rdi),%esi
	cmpl $48,%esi
	jae L686
L618:
	cmpl $40,%esi
	jz L298
	jb L619
L636:
	cmpl $44,%esi
	jz L296
	jb L637
L644:
	cmpl $46,%esi
	jz L532
	jb L645
L648:
	cmpl $47,%esi
	jnz L283
L470:
	leaq 1(%rdi),%rsi
	movzbl 1(%rdi),%eax
	cmpl $61,%eax
	jnz L474
L472:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $45088819,%eax
	jmp L268
L474:
	movq %rsi,_pos(%rip)
	movl $202375198,%eax
	jmp L268
L645:
	cmpl $45,%esi
	jnz L283
L511:
	leaq 1(%rdi),%rax
	movzbl 1(%rdi),%ecx
	cmpl $62,%ecx
	jnz L521
L512:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $26,%eax
	jmp L268
L521:
	cmpl %esi,%ecx
	jnz L525
L523:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $28,%eax
	jmp L268
L525:
	cmpl $61,%ecx
	jnz L529
L527:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $95420464,%eax
	jmp L268
L529:
	movq %rax,_pos(%rip)
	movl $253755425,%eax
	jmp L268
L532:
	movzbl 1(%rdi),%esi
	cmpl $46,%esi
	jnz L535
L536:
	movzbl 2(%rdi),%esi
	cmpl $46,%esi
	jnz L535
L533:
	leaq 3(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $19,%eax
	jmp L268
L535:
	movq _pos(%rip),%rdi
	leaq 1(%rdi),%rsi
	movzbl 1(%rdi),%edi
	addl $-48,%edi
	cmpl $10,%edi
	jb L554
L541:
	movq %rsi,_pos(%rip)
	movl $18,%eax
	jmp L268
L637:
	cmpl $42,%esi
	jz L453
	jb L638
L641:
	cmpl $43,%esi
	jnz L283
L500:
	leaq 1(%rdi),%rax
	movzbl 1(%rdi),%ecx
	cmpl %esi,%ecx
	jnz L504
L502:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $27,%eax
	jmp L268
L504:
	cmpl $61,%ecx
	jnz L508
L506:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $78643249,%eax
	jmp L268
L508:
	movq %rax,_pos(%rip)
	movl $236978208,%eax
	jmp L268
L638:
	cmpl $41,%esi
	jnz L283
L300:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $13,%eax
	jmp L268
L453:
	leaq 1(%rdi),%rsi
	movzbl 1(%rdi),%eax
	cmpl $61,%eax
	jnz L457
L455:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $28311602,%eax
	jmp L268
L457:
	movq %rsi,_pos(%rip)
	movl $219414559,%eax
	jmp L268
L296:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $524309,%eax
	jmp L268
L619:
	cmpl $35,%esi
	jz L288
	jb L620
L629:
	cmpl $38,%esi
	jz L432
	jb L630
L633:
	cmpl $39,%esi
	jnz L283
L312:
	call _ccon
	jmp L268
L630:
	cmpl $37,%esi
	jnz L283
L487:
	leaq 1(%rdi),%rsi
	movzbl 1(%rdi),%eax
	cmpl $61,%eax
	jnz L491
L489:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $61866039,%eax
	jmp L268
L491:
	movq %rsi,_pos(%rip)
	movl $470810678,%eax
	jmp L268
L432:
	leaq 1(%rdi),%rax
	movzbl 1(%rdi),%ecx
	cmpl %esi,%ecx
	jnz L436
L434:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $395313195,%eax
	jmp L268
L436:
	cmpl $61,%ecx
	jnz L440
L438:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $145752108,%eax
	jmp L268
L440:
	movq %rax,_pos(%rip)
	movl $375390250,%eax
	jmp L268
L620:
	cmpl $33,%esi
	jz L343
	jb L621
L626:
	cmpl $34,%esi
	jnz L283
L314:
	call _strlit
	jmp L268
L621:
	cmpl $10,%esi
	jz L286
	ja L283
L622:
	cmpl $0,%esi
	jnz L283
L610:
	cmpq %rdi,_invalid(%rip)
	jnz L283
L611:
	xorl %eax,%eax
	jmp L268
L286:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $11,%eax
	jmp L268
L343:
	leaq 1(%rdi),%rsi
	movzbl 1(%rdi),%eax
	cmpl $61,%eax
	jnz L347
L345:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $424673333,%eax
	jmp L268
L347:
	movq %rsi,_pos(%rip)
	movl $29,%eax
	jmp L268
L288:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $10,%eax
	jmp L268
L298:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $262156,%eax
	jmp L268
L686:
	cmpl $57,%esi
	jbe L554
L651:
	cmpl $93,%esi
	jz L308
	jb L652
L670:
	cmpl $123,%esi
	jz L302
	jb L671
L679:
	cmpl $125,%esi
	jz L304
	jb L680
L683:
	cmpl $126,%esi
	jnz L283
L310:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $25,%eax
	jmp L268
L680:
	cmpl $124,%esi
	jnz L283
L415:
	leaq 1(%rdi),%rax
	movzbl 1(%rdi),%ecx
	cmpl %esi,%ecx
	jnz L419
L417:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $463470638,%eax
	jmp L268
L419:
	cmpl $61,%ecx
	jnz L423
L421:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $162529327,%eax
	jmp L268
L423:
	movq %rax,_pos(%rip)
	movl $444596269,%eax
	jmp L268
L304:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $17,%eax
	jmp L268
L671:
	cmpl $95,%esi
	jz L608
	jb L672
L675:
	cmpl $97,%esi
	jb L283
L678:
	cmpl $122,%esi
	jbe L608
	ja L283
L672:
	cmpl $94,%esi
	jnz L283
L402:
	leaq 1(%rdi),%rsi
	movzbl 1(%rdi),%eax
	cmpl $61,%eax
	jnz L406
L404:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $179306552,%eax
	jmp L268
L406:
	movq %rsi,_pos(%rip)
	movl $191889428,%eax
	jmp L268
L302:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $16,%eax
	jmp L268
L652:
	cmpl $62,%esi
	jz L372
	jb L653
L662:
	cmpl $65,%esi
	jae L669
L663:
	cmpl $63,%esi
	jnz L283
L290:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $24,%eax
	jmp L268
L669:
	cmpl $90,%esi
	jbe L608
L666:
	cmpl $91,%esi
	jnz L283
L306:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $14,%eax
	jmp L268
L608:
	call _ident
	jmp L268
L653:
	cmpl $60,%esi
	jz L351
	jb L654
L659:
	cmpl $61,%esi
	jnz L283
L322:
	leaq 1(%rdi),%rax
	movzbl 1(%rdi),%ecx
	cmpl %esi,%ecx
	jnz L330
L324:
	leaq 2(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $407896116,%eax
	jmp L268
L330:
	movq %rax,_pos(%rip)
	movl $11534393,%eax
	jmp L268
L654:
	cmpl $59,%esi
	jz L294
	ja L283
L655:
	cmpl $58,%esi
	jz L292
L283:
	movq _pos(%rip),%rsi
	movzbl (%rsi),%esi
	andl $255,%esi
	pushq %rsi
	pushq $L615
	pushq $1
	call _error
	addq $24,%rsp
	jmp L268
L292:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $486539286,%eax
	jmp L268
L294:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $524311,%eax
	jmp L268
L351:
	movzbl 1(%rdi),%eax
	cmpl %esi,%eax
	jnz L356
L357:
	movzbl 2(%rdi),%esi
	cmpl $61,%esi
	jnz L356
L354:
	leaq 3(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $112197673,%eax
	jmp L268
L356:
	movq _pos(%rip),%rcx
	leaq 1(%rcx),%rsi
	movzbl 1(%rcx),%edi
	movzbl (%rcx),%eax
	cmpl %eax,%edi
	jnz L364
L362:
	leaq 2(%rcx),%rsi
	movq %rsi,_pos(%rip)
	movl $338690087,%eax
	jmp L268
L364:
	cmpl $61,%edi
	jnz L368
L366:
	leaq 2(%rcx),%rsi
	movq %rsi,_pos(%rip)
	movl $356515880,%eax
	jmp L268
L368:
	movq %rsi,_pos(%rip)
	movl $322961446,%eax
	jmp L268
L372:
	movzbl 1(%rdi),%eax
	cmpl %esi,%eax
	jnz L377
L378:
	movzbl 2(%rdi),%esi
	cmpl $61,%esi
	jnz L377
L375:
	leaq 3(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $128974885,%eax
	jmp L268
L377:
	movq _pos(%rip),%rcx
	leaq 1(%rcx),%rsi
	movzbl 1(%rcx),%edi
	movzbl (%rcx),%eax
	cmpl %eax,%edi
	jnz L385
L383:
	leaq 2(%rcx),%rsi
	movq %rsi,_pos(%rip)
	movl $288358435,%eax
	jmp L268
L385:
	cmpl $61,%edi
	jnz L389
L387:
	leaq 2(%rcx),%rsi
	movq %rsi,_pos(%rip)
	movl $306184228,%eax
	jmp L268
L389:
	movq %rsi,_pos(%rip)
	movl $272629794,%eax
	jmp L268
L308:
	leaq 1(%rdi),%rsi
	movq %rsi,_pos(%rip)
	movl $15,%eax
	jmp L268
L554:
	call _number
L268:
	popq %rbp
	ret
L689:
.data
.align 8
_next:
	.int 11
	.space 12, 0
.text
_lex1:
L692:
	pushq %rbp
	movq %rsp,%rbp
L699:
	movl _next(%rip),%esi
	cmpl $0,%esi
	jnz L696
L695:
	call _lex0
	movl %eax,_token(%rip)
	jmp L694
L696:
	movups _next(%rip),%xmm0
	movups %xmm0,_token(%rip)
	movl $0,_next(%rip)
L694:
	popq %rbp
	ret
L701:
_lex_peek:
L702:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L710:
	movq %rdi,%rbx
	movl _next(%rip),%esi
	cmpl $0,%esi
	jnz L707
L705:
	movups _token(%rip),%xmm0
	movups %xmm0,-16(%rbp)
	call _lex
	movups _token(%rip),%xmm0
	movups %xmm0,_next(%rip)
	movups -16(%rbp),%xmm0
	movups %xmm0,_token(%rip)
L707:
	movups _next(%rip),%xmm0
	movups %xmm0,(%rbx)
L704:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L712:
_lex:
L713:
	pushq %rbp
	movq %rsp,%rbp
L733:
	call _lex1
L716:
	movl _token(%rip),%esi
	cmpl $11,%esi
	jnz L715
L717:
	incl _error_line_no(%rip)
	call _lex1
	movl _token(%rip),%esi
	cmpl $10,%esi
	jnz L716
L719:
	call _lex1
	movl _token(%rip),%esi
	cmpl $3,%esi
	jnz L724
L722:
	movq _token+8(%rip),%rsi
	movl %esi,_error_line_no(%rip)
	call _lex1
	movl _token(%rip),%esi
	cmpl $2,%esi
	jnz L724
L725:
	movq _token+8(%rip),%rsi
	movq %rsi,_error_path(%rip)
	call _lex1
L724:
	movl _token(%rip),%esi
	cmpl $11,%esi
	jz L730
L728:
	pushq $L731
	pushq $1
	call _error
	addq $16,%rsp
L730:
	call _lex1
	jmp L716
L715:
	popq %rbp
	ret
L735:
_lex_init:
L736:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L744:
	movq %rdi,%rbx
	pushq $0
	pushq %rbx
	call _open
	addq $16,%rsp
	movl %eax,_fd(%rip)
	cmpl $-1,%eax
	jnz L741
L739:
	pushq %rbx
	pushq $L742
	pushq $1
	call _error
	addq $24,%rsp
L741:
	movq %rbx,%rdi
	call _strlen
	movq %rbx,%rdi
	movq %rax,%rsi
	call _string_new
	movq %rax,_error_path(%rip)
	call _lex
L738:
	popq %rbx
	popq %rbp
	ret
L746:
.data
.align 8
_text:
	.quad L748
	.quad L749
	.quad L750
	.quad L751
	.quad L751
	.quad L751
	.quad L751
	.quad L755
	.quad L755
	.quad L755
	.quad 0
	.quad 0
	.quad L758
	.quad L759
	.quad L760
	.quad L761
	.quad L762
	.quad L763
	.quad L764
	.quad L765
	.quad L766
	.quad L767
	.quad L768
	.quad L769
	.quad L770
	.quad L771
	.quad L772
	.quad L773
	.quad L774
	.quad L775
	.quad L776
	.quad L777
	.quad L778
	.quad L779
	.quad L780
	.quad L781
	.quad L782
	.quad L783
	.quad L784
	.quad L785
	.quad L786
	.quad L787
	.quad L788
	.quad L789
	.quad L790
	.quad L791
	.quad L792
	.quad L793
	.quad L794
	.quad L795
	.quad L796
	.quad L797
	.quad L798
	.quad L799
	.quad L800
	.quad L801
	.quad L802
	.quad L803
.text
_lex_print_k:
L804:
	pushq %rbp
	movq %rsp,%rbp
L818:
	movq %rdi,%rax
	movl %esi,%edi
	andl $255,%edi
	movslq %edi,%rcx
	cmpq $58,%rcx
	jae L808
L807:
	movslq %edi,%rsi
	movq _text(,%rsi,8),%rdi
	cmpq $0,%rdi
	jz L806
L810:
	movzbq (%rdi),%rsi
	movzbl ___ctype+1(%rsi),%esi
	testl $7,%esi
	jz L814
L813:
	movq %rax,%rsi
	call _fputs
	jmp L806
L814:
	pushq %rdi
	pushq $L816
	pushq %rax
	call _fprintf
	addq $24,%rsp
	jmp L806
L808:
	movq %rax,%rdi
	call _string_print_k
L806:
	popq %rbp
	ret
L820:
_lex_print_token:
L821:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L853:
	movq %rdi,%rbx
	movl _token(%rip),%esi
	movq %rbx,%rdi
	call _lex_print_k
	movl _token(%rip),%esi
	cmpl $3,%esi
	jz L829
L846:
	cmpl $4,%esi
	jz L833
L847:
	cmpl $5,%esi
	jz L829
L848:
	cmpl $6,%esi
	jz L833
L849:
	cmpl $7,%esi
	jb L850
L851:
	cmpl $9,%esi
	ja L850
L838:
	movsd _token+8(%rip),%xmm0
	subq $8,%rsp
	movsd %xmm0,(%rsp)
	pushq $L839
	pushq %rbx
	call _fprintf
	addq $24,%rsp
	jmp L823
L850:
	cmpl $262145,%esi
	jnz L823
L841:
	movq _token+8(%rip),%rsi
	addq $48,%rsi
	pushq %rsi
	pushq $L842
	pushq %rbx
	call _fprintf
	addq $24,%rsp
	jmp L823
L833:
	movq _token+8(%rip),%rsi
	pushq %rsi
	pushq $L834
	pushq %rbx
	call _fprintf
	addq $24,%rsp
	jmp L823
L829:
	movq _token+8(%rip),%rsi
	pushq %rsi
	pushq $L830
	pushq %rbx
	call _fprintf
	addq $24,%rsp
L823:
	popq %rbx
	popq %rbp
	ret
L855:
_lex_expect:
L856:
	pushq %rbp
	movq %rsp,%rbp
L857:
	movl _token(%rip),%esi
	cmpl %edi,%esi
	jz L858
L859:
	subq $16,%rsp
	movups _token(%rip),%xmm0
	movups %xmm0,(%rsp)
	pushq %rdi
	pushq $L862
	pushq $1
	call _error
	addq $40,%rsp
L858:
	popq %rbp
	ret
L866:
_lex_match:
L867:
	pushq %rbp
	movq %rsp,%rbp
L868:
	call _lex_expect
	call _lex
L869:
	popq %rbp
	ret
L873:
_k_decl:
L874:
	pushq %rbp
	movq %rsp,%rbp
L875:
	movl 16(%rbp),%esi
	testl $131072,%esi
	jnz L877
L880:
	cmpl $262145,%esi
	jnz L879
L884:
	movq 24(%rbp),%rdi
	call _symbol_typename
	cmpq $0,%rax
	jz L879
L877:
	movl $1,%eax
	jmp L876
L879:
	xorl %eax,%eax
L876:
	popq %rbp
	ret
L893:
L775:
	.byte 33,0
L749:
	.byte 105,100,101,110,116,105,102,105
	.byte 101,114,0
L800:
	.byte 37,0
L748:
	.byte 101,110,100,45,111,102,45,102
	.byte 105,108,101,0
L731:
	.byte 109,97,108,102,111,114,109,101
	.byte 100,32,100,105,114,101,99,116
	.byte 105,118,101,0
L789:
	.byte 38,38,0
L788:
	.byte 38,0
L20:
	.byte 116,111,107,101,110,32,116,111
	.byte 111,32,108,111,110,103,0
L758:
	.byte 40,0
L862:
	.byte 101,120,112,101,99,116,101,100
	.byte 32,37,107,32,40,102,111,117
	.byte 110,100,32,37,116,41,0
L759:
	.byte 41,0
L615:
	.byte 105,110,118,97,108,105,100,32
	.byte 99,104,97,114,97,99,116,101
	.byte 114,32,40,65,83,67,73,73
	.byte 32,37,100,41,0
L777:
	.byte 42,0
L778:
	.byte 43,0
L767:
	.byte 44,0
L834:
	.byte 32,91,37,108,117,93,0
L801:
	.byte 37,61,0
L799:
	.byte 33,61,0
L798:
	.byte 61,61,0
L797:
	.byte 47,61,0
L795:
	.byte 43,61,0
L794:
	.byte 45,61,0
L779:
	.byte 45,0
L772:
	.byte 45,62,0
L765:
	.byte 46,46,46,0
L764:
	.byte 46,0
L776:
	.byte 47,0
L755:
	.byte 102,108,111,97,116,105,110,103
	.byte 45,112,111,105,110,116,32,99
	.byte 111,110,115,116,97,110,116,0
L751:
	.byte 105,110,116,101,103,114,97,108
	.byte 32,99,111,110,115,116,97,110
	.byte 116,0
L252:
	.byte 109,97,108,102,111,114,109,101
	.byte 100,32,110,117,109,101,114,105
	.byte 99,32,99,111,110,115,116,97
	.byte 110,116,0
L143:
	.byte 109,117,108,116,105,45,99,104
	.byte 97,114,97,99,116,101,114,32
	.byte 99,111,110,115,116,97,110,116
	.byte 0
L139:
	.byte 109,97,108,102,111,114,109,101
	.byte 100,32,101,115,99,97,112,101
	.byte 32,115,101,113,117,101,110,99
	.byte 101,32,105,110,32,99,104,97
	.byte 114,97,99,116,101,114,32,99
	.byte 111,110,115,116,97,110,116,0
L85:
	.byte 117,110,116,101,114,109,105,110
	.byte 97,116,101,100,32,99,104,97
	.byte 114,97,99,116,101,114,32,99
	.byte 111,110,115,116,97,110,116,0
L256:
	.byte 102,108,111,97,116,105,110,103
	.byte 45,112,111,105,110,116,32,99
	.byte 111,110,115,116,97,110,116,32
	.byte 111,117,116,32,111,102,32,114
	.byte 97,110,103,101,0
L842:
	.byte 32,39,37,115,39,0
L816:
	.byte 39,37,115,39,0
L742:
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,39,37,115,39,32
	.byte 40,37,69,41,0
L24:
	.byte 105,110,112,117,116,32,73,47
	.byte 79,32,101,114,114,111,114,32
	.byte 40,37,69,41,0
L768:
	.byte 58,0
L773:
	.byte 43,43,0
L769:
	.byte 59,0
L762:
	.byte 123,0
L760:
	.byte 91,0
L792:
	.byte 124,124,0
L791:
	.byte 124,0
L785:
	.byte 60,60,0
L784:
	.byte 60,0
L750:
	.byte 115,116,114,105,110,103,32,108
	.byte 105,116,101,114,97,108,0
L116:
	.byte 109,97,108,102,111,114,109,101
	.byte 100,32,101,115,99,97,112,101
	.byte 32,115,101,113,117,101,110,99
	.byte 101,32,105,110,32,115,116,114
	.byte 105,110,103,32,108,105,116,101
	.byte 114,97,108,0
L86:
	.byte 117,110,116,101,114,109,105,110
	.byte 97,116,101,100,32,115,116,114
	.byte 105,110,103,32,108,105,116,101
	.byte 114,97,108,0
L839:
	.byte 32,91,37,102,93,0
L830:
	.byte 32,91,37,108,100,93,0
L803:
	.byte 61,0
L802:
	.byte 94,61,0
L796:
	.byte 42,61,0
L793:
	.byte 124,61,0
L790:
	.byte 38,61,0
L787:
	.byte 60,60,61,0
L786:
	.byte 60,61,0
L783:
	.byte 62,62,61,0
L782:
	.byte 62,61,0
L774:
	.byte 45,45,0
L763:
	.byte 125,0
L761:
	.byte 93,0
L781:
	.byte 62,62,0
L780:
	.byte 62,0
L771:
	.byte 126,0
L766:
	.byte 94,0
L770:
	.byte 63,0
.globl _error
.globl _toupper
.local _fd
.comm _fd, 4, 4
.globl _lex_expect
.globl _lex_init
.globl _escape
.globl ___ctype
.globl _memmove
.globl _fprintf
.globl _string_new
.globl _lex
.comm _error_path, 8, 8
.globl _error_path
.comm _error_line_no, 4, 4
.globl _error_line_no
.globl _errno
.globl _fputs
.globl _read
.globl _strtod
.globl _symbol_typename
.globl _close
.local _buf
.comm _buf, 4096, 1
.globl _strtof
.globl _lex_match
.globl _string_print_k
.globl _lex_print_k
.globl _lex_peek
.globl _k_decl
.globl _strtoul
.globl _lex_print_token
.comm _token, 16, 8
.globl _token
.globl _open
.globl _strlen

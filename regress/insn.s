.text
_operand_new:
L2:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L7:
	movl %edi,%r12d
	movq %rsi,%r13
	movl $40,%edi
	call _safe_malloc
	movq %rax,%rbx
	movl %r12d,(%rbx)
	movq %r13,%rdi
	call _type_machine_bits
	movq %rax,8(%rbx)
	andq $131071,%rax
	movq %rax,8(%rbx)
	movl $0,16(%rbx)
	movq %rbx,%rax
L4:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L9:
_operand_dup:
L10:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L18:
	movq %rdi,%rbx
	xorl %edx,%edx
	cmpq $0,%rbx
	jz L15
L13:
	movl $40,%edi
	call _safe_malloc
	movq %rax,%rdx
	movq %rbx,%rsi
	movq %rax,%rdi
	movl $40,%ecx
	rep
	movsb
L15:
	movq %rdx,%rax
L12:
	popq %rbx
	popq %rbp
	ret
L20:
_operand_reg:
L21:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L26:
	movq %rdi,%rax
	movl %esi,%ebx
	movl $2,%edi
	movq %rax,%rsi
	call _operand_new
	movl %ebx,24(%rax)
L23:
	popq %rbx
	popq %rbp
	ret
L28:
_operand_con:
L29:
	pushq %rbp
	movq %rsp,%rbp
L34:
	movq %rdi,%rsi
	movl $1,%edi
	call _operand_new
	leaq 24(%rax),%rdi
	leaq 16(%rbp),%rsi
	movl $8,%ecx
	rep
	movsb
L31:
	popq %rbp
	ret
L36:
_operand_f:
L37:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm10,-8(%rbp)
L42:
	movsd %xmm0,%xmm10
	movq %rdi,%rsi
	movl $1,%edi
	call _operand_new
	movsd %xmm10,24(%rax)
L39:
	movsd -8(%rbp),%xmm10
	movq %rbp,%rsp
	popq %rbp
	ret
L44:
_operand_i:
L45:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L50:
	movq %rsi,%rbx
	movq %rdi,%rsi
	movq %rdx,%r12
	movl $1,%edi
	call _operand_new
	movq %rbx,24(%rax)
	movq %r12,32(%rax)
L47:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L52:
.align 8
L64:
	.quad 0x0 # 0.000000
_operand_zero:
L53:
	pushq %rbp
	movq %rsp,%rbp
L54:
	testq $7168,%rdi
	jz L57
L56:
	movsd L64(%rip),%xmm0
	call _operand_f
	jmp L55
L57:
	xorl %esi,%esi
	xorl %edx,%edx
	call _operand_i
L55:
	popq %rbp
	ret
L66:
.align 8
L78:
	.quad 0x3ff0000000000000 # 1.000000
_operand_one:
L67:
	pushq %rbp
	movq %rsp,%rbp
L68:
	testq $7168,%rdi
	jz L71
L70:
	movsd L78(%rip),%xmm0
	call _operand_f
	jmp L69
L71:
	movl $1,%esi
	xorl %edx,%edx
	call _operand_i
L69:
	popq %rbp
	ret
L80:
_operand_sym:
L81:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L86:
	movq %rdi,%rbx
	movq %rbx,%rdi
	call _symbol_reg
	movq 32(%rbx),%rsi
	movq (%rsi),%rdi
	movl %eax,%esi
	call _operand_reg
L83:
	popq %rbx
	popq %rbp
	ret
L88:
_operand_leaf:
L89:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L90:
	movq 8(%rdi),%rsi
	movq (%rsi),%rbx
	movl (%rdi),%esi
	cmpl $-2147483647,%esi
	jz L96
L106:
	cmpl $-2147483646,%esi
	jnz L91
L102:
	movq 32(%rdi),%rdi
	call _symbol_reg
	movq %rbx,%rdi
	movl %eax,%esi
	call _operand_reg
	jmp L91
L96:
	testq $7168,%rbx
	jz L98
L97:
	movsd 24(%rdi),%xmm0
	movq %rbx,%rdi
	call _operand_f
	jmp L91
L98:
	movq 32(%rdi),%rdx
	movq 24(%rdi),%rsi
	movq %rbx,%rdi
	call _operand_i
L91:
	popq %rbx
	popq %rbp
	ret
L110:
_operand_is_zero:
L111:
	pushq %rbp
	movq %rsp,%rbp
L112:
	cmpq $0,%rdi
	jz L115
L121:
	movl (%rdi),%esi
	cmpl $1,%esi
	jnz L115
L117:
	cmpq $0,32(%rdi)
	jnz L115
L114:
	movq 8(%rdi),%rsi
	testq $7168,%rsi
	jz L126
L125:
	movsd 24(%rdi),%xmm0
	ucomisd L64(%rip),%xmm0
	setz %sil
	movzbl %sil,%eax
	jmp L113
L126:
	movq 24(%rdi),%rsi
	cmpq $0,%rsi
	setz %sil
	movzbl %sil,%eax
	jmp L113
L115:
	xorl %eax,%eax
L113:
	popq %rbp
	ret
L135:
_operand_is_one:
L136:
	pushq %rbp
	movq %rsp,%rbp
L137:
	cmpq $0,%rdi
	jz L140
L146:
	movl (%rdi),%esi
	cmpl $1,%esi
	jnz L140
L142:
	cmpq $0,32(%rdi)
	jnz L140
L139:
	movq 8(%rdi),%rsi
	testq $7168,%rsi
	jz L151
L150:
	movsd 24(%rdi),%xmm0
	ucomisd L78(%rip),%xmm0
	setz %sil
	movzbl %sil,%eax
	jmp L138
L151:
	movq 24(%rdi),%rsi
	cmpq $1,%rsi
	setz %sil
	movzbl %sil,%eax
	jmp L138
L140:
	xorl %eax,%eax
L138:
	popq %rbp
	ret
L160:
_operand_is_same:
L161:
	pushq %rbp
	movq %rsp,%rbp
L162:
	cmpq $0,%rdi
	jnz L166
L167:
	cmpq $0,%rsi
	jnz L166
L164:
	movl $1,%eax
	jmp L163
L166:
	cmpq $0,%rdi
	jz L172
L179:
	cmpq $0,%rsi
	jz L172
L175:
	movq 8(%rdi),%rax
	movq 8(%rsi),%rcx
	cmpq %rcx,%rax
	jz L174
L172:
	xorl %eax,%eax
	jmp L163
L174:
	cmpq $0,%rdi
	jz L186
L195:
	movl (%rdi),%eax
	cmpl $2,%eax
	jnz L186
L191:
	cmpq $0,%rsi
	jz L186
L199:
	movl (%rsi),%eax
	cmpl $2,%eax
	jnz L186
L187:
	movl 24(%rdi),%eax
	movl 24(%rsi),%ecx
	cmpl %ecx,%eax
	jnz L186
L184:
	movl $1,%eax
	jmp L163
L186:
	cmpq $0,%rdi
	jz L206
L211:
	movl (%rdi),%eax
	cmpl $1,%eax
	jnz L206
L207:
	cmpq $0,%rsi
	jz L206
L215:
	movl (%rsi),%eax
	cmpl $1,%eax
	jnz L206
L204:
	movq 8(%rdi),%rax
	testq $1022,%rax
	jz L221
L226:
	movq 32(%rsi),%rax
	cmpq 32(%rdi),%rax
	jnz L221
L222:
	movq 24(%rdi),%rax
	movq 24(%rsi),%rcx
	cmpq %rcx,%rax
	jnz L221
L219:
	movl $1,%eax
	jmp L163
L221:
	movq 8(%rdi),%rax
	testq $7168,%rax
	jz L206
L231:
	movsd 24(%rdi),%xmm0
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setz %sil
	movzbl %sil,%eax
	jmp L163
L206:
	xorl %eax,%eax
L163:
	popq %rbp
	ret
L239:
_operand_free:
L240:
	pushq %rbp
	movq %rsp,%rbp
L241:
	cmpq $0,%rdi
	jz L242
L243:
	call _free
L242:
	popq %rbp
	ret
L249:
_insn_construct:
L251:
	pushq %rbp
	movq %rsp,%rbp
L267:
	movl %esi,%eax
	movq %rdx,%rsi
	movl %eax,(%rdi)
	testl $2147483648,%eax
	jz L255
L254:
	movq _target(%rip),%rax
	movq 40(%rax),%rax
	call *%rax
	jmp L253
L255:
	testl $1073741824,%eax
	jz L259
L257:
	addq $8,%rsi
	movq -8(%rsi),%rcx
	movq %rcx,16(%rdi)
L259:
	testl $536870912,%eax
	jz L262
L260:
	addq $8,%rsi
	movq -8(%rsi),%rcx
	movq %rcx,24(%rdi)
L262:
	testl $268435456,%eax
	jz L253
L263:
	addq $8,%rsi
	movq -8(%rsi),%rsi
	movq %rsi,32(%rdi)
L253:
	popq %rbp
	ret
L269:
_insn_destruct:
L271:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L278:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L275
L274:
	movq _target(%rip),%rsi
	movq 48(%rsi),%rsi
	movq %rbx,%rdi
	call *%rsi
	jmp L273
L275:
	movq 16(%rbx),%rdi
	call _operand_free
	movq 24(%rbx),%rdi
	call _operand_free
	movq 32(%rbx),%rdi
	call _operand_free
L273:
	popq %rbx
	popq %rbp
	ret
L280:
_insn_new:
L281:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L282:
	leaq 24(%rbp),%rbx
	movl $56,%edi
	call _safe_malloc
	movq %rax,%r12
	movl 16(%rbp),%esi
	movq %r12,%rdi
	movq %rbx,%rdx
	call _insn_construct
	movq %r12,%rax
L283:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L288:
_insn_dup:
L289:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L298:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L293
L292:
	movq _target(%rip),%rsi
	movq 56(%rsi),%rsi
	movq %rbx,%rdi
	call *%rsi
	jmp L291
L293:
	movl $56,%edi
	call _safe_malloc
	movq %rax,%r12
	movl (%rbx),%esi
	movl %esi,(%r12)
	movq 16(%rbx),%rdi
	call _operand_dup
	movq %rax,16(%r12)
	movq 24(%rbx),%rdi
	call _operand_dup
	movq %rax,24(%r12)
	movq 32(%rbx),%rdi
	call _operand_dup
	movq %rax,32(%r12)
	movq %r12,%rax
L291:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L300:
_insn_replace:
L301:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L305:
	movq 16(%rbp),%r15
	movl 8(%r15),%r14d
	leaq -16(%rbp),%r13
	leaq 40(%r15),%rbx
	movq %rbx,%rsi
	movq %r13,%rdi
	movl $16,%ecx
	rep
	movsb
	leaq 32(%rbp),%r12
	movq %r15,%rdi
	call _insn_destruct
	movq %r15,%rdi
	xorl %esi,%esi
	movl $56,%edx
	call _memset
	movl 24(%rbp),%esi
	movq %r15,%rdi
	movq %r12,%rdx
	call _insn_construct
	movl %r14d,8(%r15)
	movq %r13,%rsi
	movq %rbx,%rdi
	movl $16,%ecx
	rep
	movsb
L303:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L307:
_insn_free:
L308:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L312:
	movq %rdi,%rbx
	movq %rbx,%rdi
	call _insn_destruct
	movq %rbx,%rdi
	call _free
L310:
	popq %rbx
	popq %rbp
	ret
L314:
_insns_remove:
L315:
	pushq %rbp
	movq %rsp,%rbp
L328:
	movq %rdi,%rax
	movq %rsi,%rdi
	movq 40(%rdi),%rsi
	movq %rsi,%rcx
	cmpq $0,%rsi
	jz L322
L321:
	movq 48(%rdi),%rdx
	movq %rdx,48(%rsi)
	jmp L323
L322:
	movq 48(%rdi),%rsi
	movq %rsi,8(%rax)
L323:
	movq 40(%rdi),%rsi
	movq 48(%rdi),%rdx
	movq %rsi,(%rdx)
L324:
	cmpq $0,%rcx
	jz L326
L325:
	addl $-1,8(%rcx)
	movq 40(%rcx),%rcx
	jmp L324
L326:
	addl $-1,16(%rax)
	call _insn_free
L317:
	popq %rbp
	ret
L330:
_renumber0:
L332:
	pushq %rbp
	movq %rsp,%rbp
L333:
	movl $2,%esi
	movq (%rdi),%rax
L335:
	cmpq $0,%rax
	jz L338
L336:
	movl %esi,%ecx
	addl $1,%esi
	movl %ecx,8(%rax)
	movq 40(%rax),%rax
	jmp L335
L338:
	movl %esi,16(%rdi)
L334:
	popq %rbp
	ret
L342:
_insns_insert_before:
L343:
	pushq %rbp
	movq %rsp,%rbp
L346:
	movq (%rdx),%rax
	cmpq $0,%rax
	jz L361
L349:
	movq 40(%rax),%rcx
	cmpq $0,%rcx
	jz L353
L352:
	movq 48(%rax),%r8
	movq %r8,48(%rcx)
	jmp L354
L353:
	movq 48(%rax),%rcx
	movq %rcx,8(%rdx)
L354:
	leaq 40(%rax),%rcx
	movq 40(%rax),%r8
	movq 48(%rax),%r9
	movq %r8,(%r9)
	movq 48(%rsi),%r8
	movq %r8,48(%rax)
	movq %rsi,40(%rax)
	movq 48(%rsi),%r8
	movq %rax,(%r8)
	movq %rcx,48(%rsi)
	jmp L346
L361:
	movq $0,(%rdx)
	movq %rdx,8(%rdx)
	movl $2,16(%rdx)
	call _renumber0
L345:
	popq %rbp
	ret
L367:
_insns_insert_after:
L368:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L371:
	movq (%rdx),%rax
	movq %rax,%r9
	cmpq $0,%rax
	jz L389
L374:
	movq 40(%rax),%rcx
	cmpq $0,%rcx
	jz L378
L377:
	movq 48(%rax),%r8
	movq %r8,48(%rcx)
	jmp L379
L378:
	movq 48(%rax),%rcx
	movq %rcx,8(%rdx)
L379:
	leaq 40(%rax),%rcx
	movq 40(%rax),%r8
	movq 48(%rax),%rbx
	movq %r8,(%rbx)
	movq 40(%rsi),%r8
	movq %r8,40(%rax)
	cmpq $0,%r8
	jz L384
L383:
	movq %rcx,48(%r8)
	jmp L385
L384:
	movq %rcx,8(%rdi)
L385:
	leaq 40(%rsi),%rcx
	movq %rax,40(%rsi)
	movq %rcx,48(%rax)
	movq %r9,%rsi
	jmp L371
L389:
	movq $0,(%rdx)
	movq %rdx,8(%rdx)
	movl $2,16(%rdx)
	call _renumber0
L370:
	popq %rbx
	popq %rbp
	ret
L395:
_insn_append:
L396:
	pushq %rbp
	movq %rsp,%rbp
L397:
	movl 16(%rdi),%eax
	movl %eax,%ecx
	addl $1,%eax
	movl %eax,16(%rdi)
	movl %ecx,8(%rsi)
	leaq 40(%rsi),%rax
	movq $0,40(%rsi)
	movq 8(%rdi),%rcx
	movq %rcx,48(%rsi)
	movq 8(%rdi),%rcx
	movq %rsi,(%rcx)
	movq %rax,8(%rdi)
L398:
	popq %rbp
	ret
L405:
_insn_prepend:
L406:
	pushq %rbp
	movq %rsp,%rbp
L409:
	movq (%rdi),%rcx
	leaq 40(%rsi),%rax
	movq %rcx,40(%rsi)
	cmpq $0,%rcx
	jz L413
L412:
	movq (%rdi),%rcx
	movq %rax,48(%rcx)
	jmp L414
L413:
	movq %rax,8(%rdi)
L414:
	movq %rsi,(%rdi)
	movq %rdi,48(%rsi)
	call _renumber0
L408:
	popq %rbp
	ret
L418:
_insns_append:
L419:
	pushq %rbp
	movq %rsp,%rbp
L422:
	movq (%rsi),%rax
	cmpq $0,%rax
	jz L434
L425:
	movq 8(%rdi),%rcx
	movq %rax,(%rcx)
	movq 8(%rdi),%rax
	movq (%rsi),%rcx
	movq %rax,48(%rcx)
	movq 8(%rsi),%rax
	movq %rax,8(%rdi)
	movq $0,(%rsi)
	movq %rsi,8(%rsi)
L434:
	movq $0,(%rsi)
	movq %rsi,8(%rsi)
	movl $2,16(%rsi)
	call _renumber0
L421:
	popq %rbp
	ret
L440:
_insns_push:
L441:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L460:
	movq %rdi,%rbx
L444:
	movl %edx,%edi
	addl $-1,%edx
	cmpl $0,%edi
	jz L446
L445:
	movq 8(%rsi),%rdi
	movq 8(%rdi),%rdi
	movq (%rdi),%rdi
	movq 40(%rdi),%rax
	cmpq $0,%rax
	jz L451
L450:
	movq 48(%rdi),%rcx
	movq %rcx,48(%rax)
	jmp L452
L451:
	movq 48(%rdi),%rax
	movq %rax,8(%rsi)
L452:
	leaq 40(%rdi),%rax
	movq 40(%rdi),%rcx
	movq 48(%rdi),%r8
	movq %rcx,(%r8)
	movq (%rbx),%rcx
	movq %rcx,40(%rdi)
	cmpq $0,%rcx
	jz L457
L456:
	movq (%rbx),%rcx
	movq %rax,48(%rcx)
	jmp L458
L457:
	movq %rax,8(%rbx)
L458:
	movq %rdi,(%rbx)
	movq %rbx,48(%rdi)
	jmp L444
L446:
	movq %rsi,%rdi
	call _renumber0
	movq %rbx,%rdi
	call _renumber0
L443:
	popq %rbx
	popq %rbp
	ret
L462:
_insns_swap:
L463:
	pushq %rbp
	movq %rsp,%rbp
L464:
	movq 40(%rsi),%rax
	movq 40(%rax),%rcx
	cmpq $0,%rcx
	jz L470
L469:
	movq 48(%rax),%rdi
	movq %rdi,48(%rcx)
	jmp L471
L470:
	movq 48(%rax),%rcx
	movq %rcx,8(%rdi)
L471:
	leaq 40(%rax),%rdi
	movq 40(%rax),%rcx
	movq 48(%rax),%rdx
	movq %rcx,(%rdx)
	movq 48(%rsi),%rcx
	movq %rcx,48(%rax)
	movq %rsi,40(%rax)
	movq 48(%rsi),%rcx
	movq %rax,(%rcx)
	movq %rdi,48(%rsi)
	addl $1,8(%rsi)
	addl $-1,8(%rax)
L465:
	popq %rbp
	ret
L478:
_insns_clear:
L479:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L492:
	movq %rdi,%rbx
L482:
	movq (%rbx),%rdi
	cmpq $0,%rdi
	jz L484
L485:
	movq 40(%rdi),%rsi
	cmpq $0,%rsi
	jz L489
L488:
	movq 48(%rdi),%rax
	movq %rax,48(%rsi)
	jmp L490
L489:
	movq 48(%rdi),%rsi
	movq %rsi,8(%rbx)
L490:
	movq 40(%rdi),%rsi
	movq 48(%rdi),%rax
	movq %rsi,(%rax)
	call _insn_free
	jmp L482
L484:
	movl $2,16(%rbx)
L481:
	popq %rbx
	popq %rbp
	ret
L494:
_insn_commute:
L495:
	pushq %rbp
	movq %rsp,%rbp
L496:
	movq 24(%rdi),%rsi
	movq 32(%rdi),%rax
	movq %rax,24(%rdi)
	movq %rsi,32(%rdi)
L497:
	popq %rbp
	ret
L501:
_insn_normalize:
L502:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L525:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $1048576,%esi
	jz L504
L505:
	movq 24(%rbx),%rsi
	cmpq $0,%rsi
	jz L510
L515:
	movl (%rsi),%edi
	cmpl $1,%edi
	jnz L510
L511:
	cmpq $0,32(%rsi)
	jnz L510
L508:
	movq %rbx,%rdi
	call _insn_commute
	jmp L504
L510:
	movq 32(%rbx),%rsi
	movq 16(%rbx),%rdi
	call _operand_is_same
	cmpl $0,%eax
	jz L504
L520:
	movq %rbx,%rdi
	call _insn_commute
L504:
	popq %rbx
	popq %rbp
	ret
L527:
_insn_side_effects:
L528:
	pushq %rbp
	movq %rsp,%rbp
L529:
	movl 4(%rdi),%esi
	testl $1,%esi
	jz L533
L531:
	movl $1,%eax
	jmp L530
L533:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L536
L535:
	movq _target(%rip),%rsi
	movq 192(%rsi),%rsi
	call *%rsi
	jmp L530
L536:
	movl (%rdi),%esi
	testl $2097152,%esi
	setnz %sil
	movzbl %sil,%eax
L530:
	popq %rbp
	ret
L543:
_insn_copy:
L544:
	pushq %rbp
	movq %rsp,%rbp
L545:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L548
L547:
	movq _target(%rip),%rax
	movq 112(%rax),%rax
	call *%rax
	jmp L546
L548:
	movl (%rdi),%eax
	cmpl $1611268107,%eax
	jnz L552
L554:
	movq 24(%rdi),%rax
	cmpq $0,%rax
	jz L552
L558:
	movl (%rax),%eax
	cmpl $2,%eax
	jnz L552
L551:
	movq 16(%rdi),%rax
	movl 24(%rax),%eax
	movl %eax,(%rsi)
	movq 24(%rdi),%rsi
	movl 24(%rsi),%esi
	movl %esi,(%rdx)
	movl $1,%eax
	jmp L546
L552:
	xorl %eax,%eax
L546:
	popq %rbp
	ret
L567:
_insn_con:
L568:
	pushq %rbp
	movq %rsp,%rbp
L569:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L572
L571:
	movq _target(%rip),%rax
	movq 120(%rax),%rax
	call *%rax
	jmp L570
L572:
	movl (%rdi),%eax
	cmpl $1611268107,%eax
	jnz L576
L578:
	movq 24(%rdi),%rax
	cmpq $0,%rax
	jz L576
L582:
	movl (%rax),%eax
	cmpl $1,%eax
	jnz L576
L575:
	movq 16(%rdi),%rax
	movl 24(%rax),%eax
	movl %eax,(%rsi)
	movq 24(%rdi),%rdi
	call _operand_dup
	jmp L570
L576:
	xorl %eax,%eax
L570:
	popq %rbp
	ret
L591:
_insn_substitute_con:
L592:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L646:
	movq %rdx,%r12
	movl %esi,%r13d
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L596
L595:
	movq _target(%rip),%rsi
	movq 128(%rsi),%rax
	movq %rbx,%rdi
	movl %r13d,%esi
	movq %r12,%rdx
	call *%rax
	jmp L594
L596:
	xorl %eax,%eax
	movl (%rbx),%esi
	testl $4194304,%esi
	jz L616
L602:
	movq 16(%rbx),%rdi
	cmpq $0,%rdi
	jz L616
L612:
	movl (%rdi),%esi
	cmpl $2,%esi
	jnz L616
L608:
	movl 24(%rdi),%esi
	cmpl %r13d,%esi
	jnz L616
L605:
	call _operand_free
	movq %r12,%rdi
	call _operand_dup
	movq %rax,16(%rbx)
	movl $1,%eax
L616:
	movq 24(%rbx),%rdi
	cmpq $0,%rdi
	jz L630
L626:
	movl (%rdi),%esi
	cmpl $2,%esi
	jnz L630
L622:
	movl 24(%rdi),%esi
	cmpl %r13d,%esi
	jnz L630
L619:
	call _operand_free
	movq %r12,%rdi
	call _operand_dup
	movq %rax,24(%rbx)
	movl $1,%eax
L630:
	movq 32(%rbx),%rdi
	cmpq $0,%rdi
	jz L594
L640:
	movl (%rdi),%esi
	cmpl $2,%esi
	jnz L594
L636:
	movl 24(%rdi),%esi
	cmpl %r13d,%esi
	jnz L594
L633:
	call _operand_free
	movq %r12,%rdi
	call _operand_dup
	movq %rax,32(%rbx)
	movl $1,%eax
L594:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L648:
_insn_substitute_reg:
L649:
	pushq %rbp
	movq %rsp,%rbp
L650:
	xorl %eax,%eax
	movl (%rdi),%r8d
	testl $2147483648,%r8d
	jz L653
L652:
	movq _target(%rip),%rax
	movq 136(%rax),%rax
	call *%rax
	jmp L651
L653:
	testl $2,%ecx
	jz L658
L659:
	movl (%rdi),%r8d
	testl $4194304,%r8d
	jnz L658
L663:
	movq 16(%rdi),%r8
	cmpq $0,%r8
	jz L658
L673:
	movl (%r8),%r9d
	cmpl $2,%r9d
	jnz L658
L669:
	movl 24(%r8),%r9d
	cmpl %esi,%r9d
	jnz L658
L666:
	movl %edx,24(%r8)
	movl $1,%eax
L658:
	testl $1,%ecx
	jz L651
L677:
	movl (%rdi),%ecx
	testl $4194304,%ecx
	jz L697
L683:
	movq 16(%rdi),%rcx
	cmpq $0,%rcx
	jz L697
L693:
	movl (%rcx),%r8d
	cmpl $2,%r8d
	jnz L697
L689:
	movl 24(%rcx),%r8d
	cmpl %esi,%r8d
	jnz L697
L686:
	movl %edx,24(%rcx)
	movl $1,%eax
L697:
	movq 24(%rdi),%rcx
	cmpq $0,%rcx
	jz L711
L707:
	movl (%rcx),%r8d
	cmpl $2,%r8d
	jnz L711
L703:
	movl 24(%rcx),%r8d
	cmpl %esi,%r8d
	jnz L711
L700:
	movl %edx,24(%rcx)
	movl $1,%eax
L711:
	movq 32(%rdi),%rdi
	cmpq $0,%rdi
	jz L651
L721:
	movl (%rdi),%ecx
	cmpl $2,%ecx
	jnz L651
L717:
	movl 24(%rdi),%ecx
	cmpl %esi,%ecx
	jnz L651
L714:
	movl %edx,24(%rdi)
	movl $1,%eax
L651:
	popq %rbp
	ret
L729:
_insn_defs_cc:
L730:
	pushq %rbp
	movq %rsp,%rbp
L731:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L734
L733:
	movq _target(%rip),%rsi
	movq 160(%rsi),%rsi
	call *%rsi
	jmp L732
L734:
	movl (%rdi),%esi
	testl $67108864,%esi
	setnz %sil
	movzbl %sil,%eax
L732:
	popq %rbp
	ret
L741:
_insn_uses_cc:
L742:
	pushq %rbp
	movq %rsp,%rbp
L743:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L746
L745:
	movq _target(%rip),%rsi
	movq 168(%rsi),%rsi
	call *%rsi
	jmp L744
L746:
	xorl %eax,%eax
	movl (%rdi),%esi
	testl $8388608,%esi
	jz L744
L749:
	leal -1082654746(%rsi),%ecx
	movl $1,%eax
	shll %cl,%eax
L744:
	popq %rbp
	ret
L756:
_insn_defs_mem:
L757:
	pushq %rbp
	movq %rsp,%rbp
L758:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L761
L760:
	movq _target(%rip),%rsi
	movq 176(%rsi),%rsi
	call *%rsi
	jmp L759
L761:
	movl (%rdi),%esi
	testl $16777216,%esi
	setnz %sil
	movzbl %sil,%eax
L759:
	popq %rbp
	ret
L768:
_insn_uses_mem:
L769:
	pushq %rbp
	movq %rsp,%rbp
L770:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L773
L772:
	movq _target(%rip),%rsi
	movq 184(%rsi),%rsi
	call *%rsi
	jmp L771
L773:
	movl (%rdi),%esi
	testl $33554432,%esi
	setnz %sil
	movzbl %sil,%eax
L771:
	popq %rbp
	ret
L780:
_insn_test_con:
L781:
	pushq %rbp
	movq %rsp,%rbp
L782:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L785
L784:
	movq _target(%rip),%rax
	movq 208(%rax),%rax
	call *%rax
	jmp L783
L785:
	movl (%rdi),%eax
	cmpl $872415247,%eax
	jnz L789
L791:
	movq 24(%rdi),%rax
	cmpq $0,%rax
	jz L795
L807:
	movl (%rax),%ecx
	cmpl $1,%ecx
	jnz L795
L803:
	cmpq $0,32(%rax)
	jnz L795
L799:
	movq 32(%rdi),%rax
	cmpq $0,%rax
	jz L795
L811:
	movl (%rax),%eax
	cmpl $2,%eax
	jz L788
L795:
	movq 32(%rdi),%rax
	cmpq $0,%rax
	jz L789
L823:
	movl (%rax),%ecx
	cmpl $1,%ecx
	jnz L789
L819:
	cmpq $0,32(%rax)
	jnz L789
L815:
	movq 24(%rdi),%rax
	cmpq $0,%rax
	jz L789
L827:
	movl (%rax),%eax
	cmpl $2,%eax
	jnz L789
L788:
	cmpq $0,%rsi
	jz L833
L831:
	movq 24(%rdi),%rax
	cmpq $0,%rax
	jz L835
L837:
	movl (%rax),%ecx
	cmpl $2,%ecx
	jnz L835
L834:
	movl 24(%rax),%edi
	movl %edi,(%rsi)
	jmp L833
L835:
	movq 32(%rdi),%rdi
	movl 24(%rdi),%edi
	movl %edi,(%rsi)
L833:
	movl $1,%eax
	jmp L783
L789:
	xorl %eax,%eax
L783:
	popq %rbp
	ret
L846:
_insn_test_z:
L847:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L864:
	movq %rdi,%rbx
	movl (%rbx),%edi
	testl $2147483648,%edi
	jz L851
L850:
	movq _target(%rip),%rdi
	movq 200(%rdi),%rax
	movq %rbx,%rdi
	call *%rax
	jmp L849
L851:
	movq %rbx,%rdi
	call _insn_test_con
	cmpl $0,%eax
	jz L855
L854:
	movq 24(%rbx),%rdi
	call _operand_is_zero
	cmpl $0,%eax
	jnz L858
L857:
	movq 32(%rbx),%rdi
	call _operand_is_zero
	cmpl $0,%eax
	jz L859
L858:
	movl $1,%eax
	jmp L849
L859:
	xorl %eax,%eax
	jmp L849
L855:
	xorl %eax,%eax
L849:
	popq %rbx
	popq %rbp
	ret
L866:
_insn_defs_regs:
L867:
	pushq %rbp
	movq %rsp,%rbp
L868:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L871
L870:
	movq _target(%rip),%rax
	movq 144(%rax),%rax
	call *%rax
	jmp L869
L871:
	movq 16(%rdi),%rax
	cmpq $0,%rax
	jz L875
L881:
	cmpq $0,%rax
	jz L875
L885:
	movl (%rax),%ecx
	cmpl $2,%ecx
	jnz L875
L877:
	movl (%rdi),%edi
	testl $4194304,%edi
	jnz L875
L874:
	cmpq $0,%rsi
	jz L891
L889:
	movl 24(%rax),%eax
	movq %rsi,%rdi
	movl %eax,%esi
	movl $1,%edx
	call _regs_lookup
L891:
	movl $1,%eax
	jmp L869
L875:
	xorl %eax,%eax
L869:
	popq %rbp
	ret
L897:
_insn_uses_regs:
L898:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L961:
	movq %rsi,%r12
	movq %rdi,%rbx
	xorl %r13d,%r13d
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L902
L901:
	movq _target(%rip),%rsi
	movq 152(%rsi),%rax
	movq %rbx,%rdi
	movq %r12,%rsi
	call *%rax
	jmp L900
L902:
	movl (%rbx),%esi
	testl $4194304,%esi
	jz L925
L908:
	movq 16(%rbx),%rsi
	cmpq $0,%rsi
	jz L925
L914:
	cmpq $0,%rsi
	jz L925
L918:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L925
L911:
	movl $1,%r13d
	cmpq $0,%r12
	jz L925
L922:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L925:
	movq 24(%rbx),%rsi
	cmpq $0,%rsi
	jz L942
L931:
	cmpq $0,%rsi
	jz L942
L935:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L942
L928:
	movl $1,%r13d
	cmpq $0,%r12
	jz L942
L939:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L942:
	movq 32(%rbx),%rsi
	cmpq $0,%rsi
	jz L943
L948:
	cmpq $0,%rsi
	jz L943
L952:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L943
L945:
	movl $1,%r13d
	cmpq $0,%r12
	jz L943
L956:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L943:
	movl %r13d,%eax
L900:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L963:
.globl _regs_lookup
.globl _insns_swap
.globl _insn_dup
.globl _operand_dup
.globl _insns_clear
.globl _insns_insert_after
.globl _insn_uses_regs
.globl _insn_defs_regs
.globl _target
.globl _insns_append
.globl _insn_prepend
.globl _insn_append
.globl _memset
.globl _insn_normalize
.globl _insn_commute
.globl _insns_insert_before
.globl _insns_remove
.globl _operand_is_one
.globl _operand_one
.globl _insn_new
.globl _insn_test_z
.globl _operand_is_zero
.globl _operand_zero
.globl _insn_side_effects
.globl _insn_uses_cc
.globl _insn_defs_cc
.globl _type_machine_bits
.globl _safe_malloc
.globl _insn_free
.globl _insn_replace
.globl _operand_free
.globl _operand_is_same
.globl _free
.globl _operand_leaf
.globl _operand_f
.globl _symbol_reg
.globl _insn_substitute_reg
.globl _operand_reg
.globl _insns_push
.globl _insn_copy
.globl _operand_i
.globl _insn_uses_mem
.globl _insn_defs_mem
.globl _operand_sym
.globl _insn_substitute_con
.globl _insn_con
.globl _insn_test_con
.globl _operand_con

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
	xorl %esi,%esi
	cmpq $0,%rbx
	jz L15
L13:
	movl $40,%edi
	call _safe_malloc
	movq %rax,%rsi
	movups (%rbx),%xmm0
	movups %xmm0,(%rax)
	movups 16(%rbx),%xmm0
	movups %xmm0,16(%rax)
	movq 32(%rbx),%rdi
	movq %rdi,32(%rax)
L15:
	movq %rsi,%rax
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
	movq 16(%rbp),%rsi
	movq %rsi,24(%rax)
L31:
	popq %rbp
	ret
L36:
_operand_f:
L37:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
L42:
	movsd %xmm0,%xmm8
	movq %rdi,%rsi
	movl $1,%edi
	call _operand_new
	movsd %xmm8,24(%rax)
L39:
	movsd -8(%rbp),%xmm8
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
	.quad 0x0
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
	.quad 0x3ff0000000000000
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
	pushq %rbx
L270:
	movl %esi,%eax
	movq %rdx,%rsi
	movq %rdi,%rbx
	movl %eax,(%rbx)
	testl $2147483648,%eax
	jz L255
L254:
	movq _target(%rip),%rdi
	movq 56(%rdi),%rax
	movq %rbx,%rdi
	call *%rax
	jmp L256
L255:
	testl $1073741824,%eax
	jz L259
L257:
	addq $8,%rsi
	movq -8(%rsi),%rdi
	movq %rdi,48(%rbx)
L259:
	testl $536870912,%eax
	jz L262
L260:
	addq $8,%rsi
	movq -8(%rsi),%rdi
	movq %rdi,56(%rbx)
L262:
	testl $268435456,%eax
	jz L265
L263:
	addq $8,%rsi
	movq -8(%rsi),%rsi
	movq %rsi,64(%rbx)
L265:
	cmpl $2097190,%eax
	jnz L256
L266:
	call _asm_new
	movq %rax,40(%rbx)
L256:
	leaq 16(%rbx),%rdi
	call _sched_init
L253:
	popq %rbx
	popq %rbp
	ret
L272:
_insn_destruct:
L274:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L284:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L278
L277:
	movq _target(%rip),%rsi
	movq 64(%rsi),%rsi
	movq %rbx,%rdi
	call *%rsi
	jmp L279
L278:
	movq 48(%rbx),%rdi
	call _operand_free
	movq 56(%rbx),%rdi
	call _operand_free
	movq 64(%rbx),%rdi
	call _operand_free
	movl (%rbx),%esi
	cmpl $2097190,%esi
	jnz L279
L280:
	movq 40(%rbx),%rdi
	call _asm_free
L279:
	leaq 16(%rbx),%rdi
	call _sched_clear
L276:
	popq %rbx
	popq %rbp
	ret
L286:
_insn_new:
L287:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L288:
	leaq 24(%rbp),%rbx
	movl $88,%edi
	call _safe_malloc
	movq %rax,%r12
	movl 16(%rbp),%esi
	movq %r12,%rdi
	movq %rbx,%rdx
	call _insn_construct
	movq %r12,%rax
L289:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L294:
_insn_dup:
L295:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L306:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L299
L298:
	movq _target(%rip),%rsi
	movq 72(%rsi),%rsi
	movq %rbx,%rdi
	call *%rsi
	movq %rax,%r12
	jmp L300
L299:
	pushq $524288
	call _insn_new
	addq $8,%rsp
	movq %rax,%r13
	movq %r13,%r12
	movl (%rbx),%esi
	movl %esi,(%r13)
	movq 48(%rbx),%rdi
	call _operand_dup
	movq %rax,48(%r13)
	movq 56(%rbx),%rdi
	call _operand_dup
	movq %rax,56(%r13)
	movq 64(%rbx),%rdi
	call _operand_dup
	movq %rax,64(%r13)
	movl (%r13),%esi
	cmpl $2097190,%esi
	jnz L300
L301:
	movq 40(%rbx),%rdi
	call _asm_dup
	movq %rax,40(%r13)
L300:
	movl 4(%rbx),%esi
	orl %esi,4(%r12)
	movq %r12,%rax
L297:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L308:
_insn_replace:
L309:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L313:
	movq 16(%rbp),%r13
	movl 8(%r13),%ebx
	movups 72(%r13),%xmm0
	movups %xmm0,-16(%rbp)
	leaq 32(%rbp),%r12
	movq %r13,%rdi
	call _insn_destruct
	movq %r13,%rdi
	xorl %esi,%esi
	movl $88,%edx
	call _memset
	movl 24(%rbp),%esi
	movq %r13,%rdi
	movq %r12,%rdx
	call _insn_construct
	movl %ebx,8(%r13)
	movups -16(%rbp),%xmm0
	movups %xmm0,72(%r13)
L311:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L315:
_insn_free:
L316:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L320:
	movq %rdi,%rbx
	call _insn_destruct
	movq %rbx,%rdi
	call _free
L318:
	popq %rbx
	popq %rbp
	ret
L322:
_insns_remove:
L323:
	pushq %rbp
	movq %rsp,%rbp
L336:
	movq %rdi,%rax
	movq %rsi,%rdi
	movq 72(%rdi),%rsi
	movq %rsi,%rcx
	cmpq $0,%rsi
	jz L330
L329:
	movq 80(%rdi),%rdx
	movq %rdx,80(%rsi)
	jmp L331
L330:
	movq 80(%rdi),%rsi
	movq %rsi,8(%rax)
L331:
	movq 72(%rdi),%rsi
	movq 80(%rdi),%rdx
	movq %rsi,(%rdx)
L332:
	cmpq $0,%rcx
	jz L334
L333:
	decl 8(%rcx)
	movq 72(%rcx),%rcx
	jmp L332
L334:
	decl 16(%rax)
	call _insn_free
L325:
	popq %rbp
	ret
L338:
_renumber0:
L340:
	pushq %rbp
	movq %rsp,%rbp
L341:
	movl $2,%esi
	movq (%rdi),%rax
L343:
	cmpq $0,%rax
	jz L346
L344:
	movl %esi,%ecx
	incl %esi
	movl %ecx,8(%rax)
	movq 72(%rax),%rax
	jmp L343
L346:
	movl %esi,16(%rdi)
L342:
	popq %rbp
	ret
L350:
_insns_insert_before:
L351:
	pushq %rbp
	movq %rsp,%rbp
L354:
	movq (%rdx),%rax
	cmpq $0,%rax
	jz L369
L357:
	movq 72(%rax),%rcx
	cmpq $0,%rcx
	jz L361
L360:
	movq 80(%rax),%r8
	movq %r8,80(%rcx)
	jmp L362
L361:
	movq 80(%rax),%rcx
	movq %rcx,8(%rdx)
L362:
	leaq 72(%rax),%rcx
	movq 72(%rax),%r8
	movq 80(%rax),%r9
	movq %r8,(%r9)
	movq 80(%rsi),%r8
	movq %r8,80(%rax)
	movq %rsi,72(%rax)
	movq 80(%rsi),%r8
	movq %rax,(%r8)
	movq %rcx,80(%rsi)
	jmp L354
L369:
	movq $0,(%rdx)
	movq %rdx,8(%rdx)
	movl $2,16(%rdx)
	call _renumber0
L353:
	popq %rbp
	ret
L375:
_insns_insert_after:
L376:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L379:
	movq (%rdx),%rax
	movq %rax,%r9
	cmpq $0,%rax
	jz L397
L382:
	movq 72(%rax),%rcx
	cmpq $0,%rcx
	jz L386
L385:
	movq 80(%rax),%r8
	movq %r8,80(%rcx)
	jmp L387
L386:
	movq 80(%rax),%rcx
	movq %rcx,8(%rdx)
L387:
	leaq 72(%rax),%rcx
	movq 72(%rax),%r8
	movq 80(%rax),%rbx
	movq %r8,(%rbx)
	movq 72(%rsi),%r8
	movq %r8,72(%rax)
	cmpq $0,%r8
	jz L392
L391:
	movq %rcx,80(%r8)
	jmp L393
L392:
	movq %rcx,8(%rdi)
L393:
	leaq 72(%rsi),%rcx
	movq %rax,72(%rsi)
	movq %rcx,80(%rax)
	movq %r9,%rsi
	jmp L379
L397:
	movq $0,(%rdx)
	movq %rdx,8(%rdx)
	movl $2,16(%rdx)
	call _renumber0
L378:
	popq %rbx
	popq %rbp
	ret
L403:
_insn_append:
L404:
	pushq %rbp
	movq %rsp,%rbp
L405:
	movl 16(%rdi),%eax
	movl %eax,%ecx
	incl %eax
	movl %eax,16(%rdi)
	movl %ecx,8(%rsi)
	leaq 72(%rsi),%rax
	movq $0,72(%rsi)
	movq 8(%rdi),%rcx
	movq %rcx,80(%rsi)
	movq 8(%rdi),%rcx
	movq %rsi,(%rcx)
	movq %rax,8(%rdi)
L406:
	popq %rbp
	ret
L413:
_insn_prepend:
L414:
	pushq %rbp
	movq %rsp,%rbp
L417:
	movq (%rdi),%rcx
	leaq 72(%rsi),%rax
	movq %rcx,72(%rsi)
	cmpq $0,%rcx
	jz L421
L420:
	movq (%rdi),%rcx
	movq %rax,80(%rcx)
	jmp L422
L421:
	movq %rax,8(%rdi)
L422:
	movq %rsi,(%rdi)
	movq %rdi,80(%rsi)
	call _renumber0
L416:
	popq %rbp
	ret
L426:
_insns_append:
L427:
	pushq %rbp
	movq %rsp,%rbp
L430:
	movq (%rsi),%rax
	cmpq $0,%rax
	jz L442
L433:
	movq 8(%rdi),%rcx
	movq %rax,(%rcx)
	movq 8(%rdi),%rax
	movq (%rsi),%rcx
	movq %rax,80(%rcx)
	movq 8(%rsi),%rax
	movq %rax,8(%rdi)
	movq $0,(%rsi)
	movq %rsi,8(%rsi)
L442:
	movq $0,(%rsi)
	movq %rsi,8(%rsi)
	movl $2,16(%rsi)
	call _renumber0
L429:
	popq %rbp
	ret
L448:
_insns_push:
L449:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L468:
	movq %rdi,%rbx
L452:
	movl %edx,%edi
	decl %edx
	cmpl $0,%edi
	jz L454
L453:
	movq 8(%rsi),%rdi
	movq 8(%rdi),%rdi
	movq (%rdi),%rdi
	movq 72(%rdi),%rax
	cmpq $0,%rax
	jz L459
L458:
	movq 80(%rdi),%rcx
	movq %rcx,80(%rax)
	jmp L460
L459:
	movq 80(%rdi),%rax
	movq %rax,8(%rsi)
L460:
	leaq 72(%rdi),%rax
	movq 72(%rdi),%rcx
	movq 80(%rdi),%r8
	movq %rcx,(%r8)
	movq (%rbx),%rcx
	movq %rcx,72(%rdi)
	cmpq $0,%rcx
	jz L465
L464:
	movq (%rbx),%rcx
	movq %rax,80(%rcx)
	jmp L466
L465:
	movq %rax,8(%rbx)
L466:
	movq %rdi,(%rbx)
	movq %rbx,80(%rdi)
	jmp L452
L454:
	movq %rsi,%rdi
	call _renumber0
	movq %rbx,%rdi
	call _renumber0
L451:
	popq %rbx
	popq %rbp
	ret
L470:
_insns_swap:
L471:
	pushq %rbp
	movq %rsp,%rbp
L472:
	movq 72(%rsi),%rax
	movq 72(%rax),%rcx
	cmpq $0,%rcx
	jz L478
L477:
	movq 80(%rax),%rdi
	movq %rdi,80(%rcx)
	jmp L479
L478:
	movq 80(%rax),%rcx
	movq %rcx,8(%rdi)
L479:
	leaq 72(%rax),%rdi
	movq 72(%rax),%rcx
	movq 80(%rax),%rdx
	movq %rcx,(%rdx)
	movq 80(%rsi),%rcx
	movq %rcx,80(%rax)
	movq %rsi,72(%rax)
	movq 80(%rsi),%rcx
	movq %rax,(%rcx)
	movq %rdi,80(%rsi)
	incl 8(%rsi)
	decl 8(%rax)
L473:
	popq %rbp
	ret
L486:
_insns_clear:
L487:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L500:
	movq %rdi,%rbx
L490:
	movq (%rbx),%rdi
	cmpq $0,%rdi
	jz L492
L493:
	movq 72(%rdi),%rsi
	cmpq $0,%rsi
	jz L497
L496:
	movq 80(%rdi),%rax
	movq %rax,80(%rsi)
	jmp L498
L497:
	movq 80(%rdi),%rsi
	movq %rsi,8(%rbx)
L498:
	movq 72(%rdi),%rsi
	movq 80(%rdi),%rax
	movq %rsi,(%rax)
	call _insn_free
	jmp L490
L492:
	movl $2,16(%rbx)
L489:
	popq %rbx
	popq %rbp
	ret
L502:
_insn_commute:
L503:
	pushq %rbp
	movq %rsp,%rbp
L504:
	movq 56(%rdi),%rsi
	movq 64(%rdi),%rax
	movq %rax,56(%rdi)
	movq %rsi,64(%rdi)
L505:
	popq %rbp
	ret
L509:
_insn_normalize:
L510:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L533:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $1048576,%esi
	jz L512
L513:
	movq 56(%rbx),%rsi
	cmpq $0,%rsi
	jz L518
L523:
	movl (%rsi),%edi
	cmpl $1,%edi
	jnz L518
L519:
	cmpq $0,32(%rsi)
	jnz L518
L516:
	movq %rbx,%rdi
	call _insn_commute
	jmp L512
L518:
	movq 64(%rbx),%rsi
	movq 48(%rbx),%rdi
	call _operand_is_same
	cmpl $0,%eax
	jz L512
L528:
	movq %rbx,%rdi
	call _insn_commute
L512:
	popq %rbx
	popq %rbp
	ret
L535:
_insn_side_effects:
L536:
	pushq %rbp
	movq %rsp,%rbp
L537:
	movl 4(%rdi),%esi
	testl $1,%esi
	jz L541
L539:
	movl $1,%eax
	jmp L538
L541:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L544
L543:
	movq _target(%rip),%rsi
	movq 216(%rsi),%rsi
	call *%rsi
	jmp L538
L544:
	movl (%rdi),%esi
	testl $2097152,%esi
	setnz %sil
	movzbl %sil,%eax
L538:
	popq %rbp
	ret
L551:
_insn_copy:
L552:
	pushq %rbp
	movq %rsp,%rbp
L553:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L556
L555:
	movq _target(%rip),%rax
	movq 128(%rax),%rax
	call *%rax
	jmp L554
L556:
	movl (%rdi),%eax
	cmpl $1611333643,%eax
	jnz L560
L562:
	movq 56(%rdi),%rax
	cmpq $0,%rax
	jz L560
L566:
	movl (%rax),%eax
	cmpl $2,%eax
	jnz L560
L559:
	movq 48(%rdi),%rax
	movl 24(%rax),%eax
	movl %eax,(%rsi)
	movq 56(%rdi),%rsi
	movl 24(%rsi),%esi
	movl %esi,(%rdx)
	movl $1,%eax
	jmp L554
L560:
	xorl %eax,%eax
L554:
	popq %rbp
	ret
L575:
_insn_con:
L576:
	pushq %rbp
	movq %rsp,%rbp
L577:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L580
L579:
	movq _target(%rip),%rax
	movq 136(%rax),%rax
	call *%rax
	jmp L578
L580:
	movl (%rdi),%eax
	cmpl $1611333643,%eax
	jnz L584
L586:
	movq 56(%rdi),%rax
	cmpq $0,%rax
	jz L584
L590:
	movl (%rax),%eax
	cmpl $1,%eax
	jnz L584
L583:
	movq 48(%rdi),%rax
	movl 24(%rax),%eax
	movl %eax,(%rsi)
	movq 56(%rdi),%rdi
	call _operand_dup
	jmp L578
L584:
	xorl %eax,%eax
L578:
	popq %rbp
	ret
L599:
_insn_substitute_con:
L600:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L654:
	movq %rdx,%r12
	movl %esi,%r13d
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L604
L603:
	movq _target(%rip),%rsi
	movq 144(%rsi),%rax
	movq %rbx,%rdi
	movl %r13d,%esi
	movq %r12,%rdx
	call *%rax
	jmp L602
L604:
	xorl %eax,%eax
	movl (%rbx),%esi
	testl $4194304,%esi
	jz L624
L610:
	movq 48(%rbx),%rdi
	cmpq $0,%rdi
	jz L624
L620:
	movl (%rdi),%esi
	cmpl $2,%esi
	jnz L624
L616:
	movl 24(%rdi),%esi
	cmpl %r13d,%esi
	jnz L624
L613:
	call _operand_free
	movq %r12,%rdi
	call _operand_dup
	movq %rax,48(%rbx)
	movl $1,%eax
L624:
	movq 56(%rbx),%rdi
	cmpq $0,%rdi
	jz L638
L634:
	movl (%rdi),%esi
	cmpl $2,%esi
	jnz L638
L630:
	movl 24(%rdi),%esi
	cmpl %r13d,%esi
	jnz L638
L627:
	call _operand_free
	movq %r12,%rdi
	call _operand_dup
	movq %rax,56(%rbx)
	movl $1,%eax
L638:
	movq 64(%rbx),%rdi
	cmpq $0,%rdi
	jz L602
L648:
	movl (%rdi),%esi
	cmpl $2,%esi
	jnz L602
L644:
	movl 24(%rdi),%esi
	cmpl %r13d,%esi
	jnz L602
L641:
	call _operand_free
	movq %r12,%rdi
	call _operand_dup
	movq %rax,64(%rbx)
	movl $1,%eax
L602:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L656:
_insn_substitute_reg:
L657:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L758:
	movl %ecx,%r15d
	movl %edx,%r12d
	movl %esi,%r13d
	movq %rdi,%rbx
	xorl %r14d,%r14d
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L661
L660:
	movq _target(%rip),%rsi
	movq 152(%rsi),%rax
	movq %rbx,%rdi
	movl %r13d,%esi
	movl %r12d,%edx
	movl %r15d,%ecx
	call *%rax
	jmp L659
L661:
	testl $2,%r15d
	jz L666
L664:
	movl (%rbx),%esi
	testl $4194304,%esi
	jnz L684
L670:
	movq 48(%rbx),%rsi
	cmpq $0,%rsi
	jz L684
L680:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L684
L676:
	movl 24(%rsi),%edi
	cmpl %r13d,%edi
	jnz L684
L673:
	movl %r12d,24(%rsi)
	movl $1,%r14d
L684:
	movl (%rbx),%esi
	cmpl $2097190,%esi
	jnz L666
L687:
	movq 40(%rbx),%rsi
	leaq 8(%rsi),%rdi
	movl %r13d,%esi
	movl %r12d,%edx
	call _regs_substitute
	cmpl $0,%eax
	jz L692
L690:
	movl $1,%r14d
L692:
	movq 40(%rbx),%rsi
	leaq 72(%rsi),%rdi
	movl %r13d,%esi
	movl %r12d,%edx
	call _regmaps_substitute
	cmpl $0,%eax
	jz L666
L693:
	movl $1,%r14d
L666:
	testl $1,%r15d
	jz L698
L696:
	movl (%rbx),%esi
	testl $4194304,%esi
	jz L716
L702:
	movq 48(%rbx),%rsi
	cmpq $0,%rsi
	jz L716
L712:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L716
L708:
	movl 24(%rsi),%edi
	cmpl %r13d,%edi
	jnz L716
L705:
	movl %r12d,24(%rsi)
	movl $1,%r14d
L716:
	movq 56(%rbx),%rsi
	cmpq $0,%rsi
	jz L730
L726:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L730
L722:
	movl 24(%rsi),%edi
	cmpl %r13d,%edi
	jnz L730
L719:
	movl %r12d,24(%rsi)
	movl $1,%r14d
L730:
	movq 64(%rbx),%rsi
	cmpq $0,%rsi
	jz L744
L740:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L744
L736:
	movl 24(%rsi),%edi
	cmpl %r13d,%edi
	jnz L744
L733:
	movl %r12d,24(%rsi)
	movl $1,%r14d
L744:
	movl (%rbx),%esi
	cmpl $2097190,%esi
	jnz L698
L747:
	movq 40(%rbx),%rsi
	leaq 32(%rsi),%rdi
	movl %r13d,%esi
	movl %r12d,%edx
	call _regs_substitute
	cmpl $0,%eax
	jz L752
L750:
	movl $1,%r14d
L752:
	movq 40(%rbx),%rsi
	leaq 56(%rsi),%rdi
	movl %r13d,%esi
	movl %r12d,%edx
	call _regmaps_substitute
	cmpl $0,%eax
	jz L698
L753:
	movl $1,%r14d
L698:
	movl %r14d,%eax
L659:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L760:
_insn_defs_cc:
L761:
	pushq %rbp
	movq %rsp,%rbp
L762:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L765
L764:
	movq _target(%rip),%rsi
	movq 176(%rsi),%rsi
	call *%rsi
	jmp L763
L765:
	movl (%rdi),%esi
	cmpl $2097190,%esi
	jnz L769
L768:
	movq 40(%rdi),%rsi
	movl 96(%rsi),%eax
	jmp L763
L769:
	testl $67108864,%esi
	setnz %sil
	movzbl %sil,%eax
L763:
	popq %rbp
	ret
L776:
_insn_uses_cc:
L777:
	pushq %rbp
	movq %rsp,%rbp
L778:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L781
L780:
	movq _target(%rip),%rsi
	movq 184(%rsi),%rsi
	call *%rsi
	jmp L779
L781:
	xorl %eax,%eax
	movl (%rdi),%esi
	testl $8388608,%esi
	jz L779
L784:
	leal -1082654746(%rsi),%ecx
	movl $1,%eax
	shll %cl,%eax
L779:
	popq %rbp
	ret
L791:
_insn_defs_mem:
L792:
	pushq %rbp
	movq %rsp,%rbp
L793:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L796
L795:
	movq _target(%rip),%rsi
	movq 192(%rsi),%rsi
	call *%rsi
	jmp L794
L796:
	movl (%rdi),%esi
	cmpl $2097190,%esi
	jnz L800
L799:
	movq 40(%rdi),%rsi
	movl 88(%rsi),%eax
	jmp L794
L800:
	testl $16777216,%esi
	setnz %sil
	movzbl %sil,%eax
L794:
	popq %rbp
	ret
L807:
_insn_uses_mem:
L808:
	pushq %rbp
	movq %rsp,%rbp
L809:
	movl (%rdi),%esi
	testl $2147483648,%esi
	jz L812
L811:
	movq _target(%rip),%rsi
	movq 200(%rsi),%rsi
	call *%rsi
	jmp L810
L812:
	movl (%rdi),%esi
	cmpl $2097190,%esi
	jnz L816
L815:
	movq 40(%rdi),%rsi
	movl 92(%rsi),%eax
	jmp L810
L816:
	testl $33554432,%esi
	setnz %sil
	movzbl %sil,%eax
L810:
	popq %rbp
	ret
L823:
_insn_strip_indices:
L824:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L864:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jz L830
L827:
	movq _target(%rip),%rsi
	movq 208(%rsi),%rsi
	movq %rbx,%rdi
	call *%rsi
	jmp L826
L830:
	movq 48(%rbx),%rsi
	cmpq $0,%rsi
	jz L840
L836:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L840
L833:
	andl $2149580799,24(%rsi)
L840:
	movq 56(%rbx),%rsi
	cmpq $0,%rsi
	jz L850
L846:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L850
L843:
	andl $2149580799,24(%rsi)
L850:
	movq 64(%rbx),%rsi
	cmpq $0,%rsi
	jz L851
L856:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L851
L853:
	andl $2149580799,24(%rsi)
L851:
	movl (%rbx),%esi
	cmpl $2097190,%esi
	jnz L826
L860:
	movq 40(%rbx),%rsi
	leaq 8(%rsi),%rdi
	call _regs_strip
	movq 40(%rbx),%rsi
	leaq 32(%rsi),%rdi
	call _regs_strip
	movq 40(%rbx),%rsi
	leaq 56(%rsi),%rdi
	call _regmaps_strip
	movq 40(%rbx),%rsi
	leaq 72(%rsi),%rdi
	call _regmaps_strip
L826:
	popq %rbx
	popq %rbp
	ret
L866:
_insn_test_con:
L867:
	pushq %rbp
	movq %rsp,%rbp
L868:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L871
L870:
	movq _target(%rip),%rax
	movq 232(%rax),%rax
	call *%rax
	jmp L869
L871:
	movl (%rdi),%eax
	cmpl $872415247,%eax
	jnz L875
L877:
	movq 56(%rdi),%rax
	cmpq $0,%rax
	jz L881
L893:
	movl (%rax),%ecx
	cmpl $1,%ecx
	jnz L881
L889:
	cmpq $0,32(%rax)
	jnz L881
L885:
	movq 64(%rdi),%rax
	cmpq $0,%rax
	jz L881
L897:
	movl (%rax),%eax
	cmpl $2,%eax
	jz L874
L881:
	movq 64(%rdi),%rax
	cmpq $0,%rax
	jz L875
L909:
	movl (%rax),%ecx
	cmpl $1,%ecx
	jnz L875
L905:
	cmpq $0,32(%rax)
	jnz L875
L901:
	movq 56(%rdi),%rax
	cmpq $0,%rax
	jz L875
L913:
	movl (%rax),%eax
	cmpl $2,%eax
	jnz L875
L874:
	cmpq $0,%rsi
	jz L919
L917:
	movq 56(%rdi),%rax
	cmpq $0,%rax
	jz L921
L923:
	movl (%rax),%ecx
	cmpl $2,%ecx
	jnz L921
L920:
	movl 24(%rax),%edi
	movl %edi,(%rsi)
	jmp L919
L921:
	movq 64(%rdi),%rdi
	movl 24(%rdi),%edi
	movl %edi,(%rsi)
L919:
	movl $1,%eax
	jmp L869
L875:
	xorl %eax,%eax
L869:
	popq %rbp
	ret
L932:
_insn_test_z:
L933:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L950:
	movq %rdi,%rbx
	movl (%rbx),%edi
	testl $2147483648,%edi
	jz L937
L936:
	movq _target(%rip),%rdi
	movq 224(%rdi),%rax
	movq %rbx,%rdi
	call *%rax
	jmp L935
L937:
	movq %rbx,%rdi
	call _insn_test_con
	cmpl $0,%eax
	jz L941
L940:
	movq 56(%rbx),%rdi
	call _operand_is_zero
	cmpl $0,%eax
	jnz L944
L943:
	movq 64(%rbx),%rdi
	call _operand_is_zero
	cmpl $0,%eax
	jz L945
L944:
	movl $1,%eax
	jmp L935
L945:
	xorl %eax,%eax
	jmp L935
L941:
	xorl %eax,%eax
L935:
	popq %rbx
	popq %rbp
	ret
L952:
_insn_defs_z:
L953:
	pushq %rbp
	movq %rsp,%rbp
L954:
	movl (%rdi),%eax
	testl $2147483648,%eax
	jz L957
L956:
	movq _target(%rip),%rax
	movq 240(%rax),%rax
	call *%rax
	jmp L955
L957:
	xorl %eax,%eax
L955:
	popq %rbp
	ret
L964:
_insn_defs_regs:
L965:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1024:
	movq %rsi,%r12
	movl %edx,%r13d
	movq %rdi,%r14
	xorl %ebx,%ebx
	movl (%r14),%esi
	testl $2147483648,%esi
	jz L969
L968:
	movq _target(%rip),%rsi
	movq 160(%rsi),%rax
	movq %r14,%rdi
	movq %r12,%rsi
	call *%rax
	movl %eax,%ebx
	jmp L996
L969:
	movq 48(%r14),%rsi
	cmpq $0,%rsi
	jz L973
L978:
	cmpq $0,%rsi
	jz L973
L982:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L973
L974:
	movl (%r14),%edi
	testl $4194304,%edi
	jnz L973
L971:
	movl $1,%ebx
	cmpq $0,%r12
	jz L973
L986:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L973:
	movl (%r14),%esi
	cmpl $2097190,%esi
	jnz L996
L992:
	movq 40(%r14),%rsi
	movl 8(%rsi),%edi
	cmpl $0,%edi
	jz L996
L989:
	addq $8,%rsi
	movq %r12,%rdi
	call _regs_union
	movl $1,%ebx
L996:
	testl $1,%r13d
	jz L1009
L1002:
	movq %r14,%rdi
	call _insn_defs_cc
	cmpl $0,%eax
	jz L1009
L999:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1009
L1006:
	movq %r12,%rdi
	movl $2147483648,%esi
	movl $1,%edx
	call _regs_lookup
L1009:
	testl $2,%r13d
	jz L1010
L1015:
	movq %r14,%rdi
	call _insn_defs_mem
	cmpl $0,%eax
	jz L1010
L1012:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1010
L1019:
	movq %r12,%rdi
	movl $2147483650,%esi
	movl $1,%edx
	call _regs_lookup
L1010:
	movl %ebx,%eax
L967:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L1026:
_insn_uses_regs:
L1027:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L1122:
	movq %rsi,%r12
	movl %edx,%r13d
	movq %rdi,%r14
	xorl %ebx,%ebx
	movl (%r14),%esi
	testl $2147483648,%esi
	jz L1031
L1030:
	movq _target(%rip),%rsi
	movq 168(%rsi),%rax
	movq %r14,%rdi
	movq %r12,%rsi
	call *%rax
	movl %eax,%ebx
	jmp L1094
L1031:
	movl (%r14),%esi
	testl $4194304,%esi
	jz L1053
L1036:
	movq 48(%r14),%rsi
	cmpq $0,%rsi
	jz L1053
L1042:
	cmpq $0,%rsi
	jz L1053
L1046:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L1053
L1039:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1053
L1050:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L1053:
	movq 56(%r14),%rsi
	cmpq $0,%rsi
	jz L1070
L1059:
	cmpq $0,%rsi
	jz L1070
L1063:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L1070
L1056:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1070
L1067:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L1070:
	movq 64(%r14),%rsi
	cmpq $0,%rsi
	jz L1071
L1076:
	cmpq $0,%rsi
	jz L1071
L1080:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L1071
L1073:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1071
L1084:
	movl 24(%rsi),%esi
	movq %r12,%rdi
	movl $1,%edx
	call _regs_lookup
L1071:
	movl (%r14),%esi
	cmpl $2097190,%esi
	jnz L1094
L1090:
	movq 40(%r14),%rsi
	movl 32(%rsi),%edi
	cmpl $0,%edi
	jz L1094
L1087:
	addq $32,%rsi
	movq %r12,%rdi
	call _regs_union
	movl $1,%ebx
L1094:
	testl $1,%r13d
	jz L1107
L1100:
	movq %r14,%rdi
	call _insn_uses_cc
	cmpl $0,%eax
	jz L1107
L1097:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1107
L1104:
	movq %r12,%rdi
	movl $2147483648,%esi
	movl $1,%edx
	call _regs_lookup
L1107:
	testl $2,%r13d
	jz L1108
L1113:
	movq %r14,%rdi
	call _insn_uses_mem
	cmpl $0,%eax
	jz L1108
L1110:
	movl $1,%ebx
	cmpq $0,%r12
	jz L1108
L1117:
	movq %r12,%rdi
	movl $2147483650,%esi
	movl $1,%edx
	call _regs_lookup
L1108:
	movl %ebx,%eax
L1029:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L1124:
.globl _asm_dup
.globl _regmaps_strip
.globl _regs_strip
.globl _regs_lookup
.globl _insns_swap
.globl _insn_dup
.globl _operand_dup
.globl _insns_clear
.globl _insns_insert_after
.globl _sched_clear
.globl _insn_strip_indices
.globl _insn_uses_regs
.globl _insn_defs_regs
.globl _target
.globl _insns_append
.globl _insn_prepend
.globl _insn_append
.globl _sched_init
.globl _memset
.globl _regmaps_substitute
.globl _regs_substitute
.globl _insn_normalize
.globl _insn_commute
.globl _insns_insert_before
.globl _insns_remove
.globl _operand_is_one
.globl _operand_one
.globl _asm_new
.globl _insn_new
.globl _insn_defs_z
.globl _insn_test_z
.globl _operand_is_zero
.globl _operand_zero
.globl _insn_side_effects
.globl _insn_uses_cc
.globl _insn_defs_cc
.globl _type_machine_bits
.globl _safe_malloc
.globl _asm_free
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
.globl _regs_union
.globl _insn_substitute_con
.globl _insn_con
.globl _insn_test_con
.globl _operand_con

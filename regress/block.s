.text
_cessor_new:
L3:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L11:
	movq %rdx,%r13
	movq %rdi,%r12
	movl %esi,%ebx
	movl $48,%edi
	call _safe_malloc
	movl %ebx,(%rax)
	movq %r13,8(%rax)
	leaq 32(%rax),%rsi
	movq $0,32(%rax)
	movq 8(%r12),%rdi
	movq %rdi,40(%rax)
	movq 8(%r12),%rdi
	movq %rax,(%rdi)
	movq %rsi,8(%r12)
L5:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L13:
_cessor_free:
L15:
	pushq %rbp
	movq %rsp,%rbp
L18:
	movq 32(%rsi),%rax
	cmpq $0,%rax
	jz L22
L21:
	movq 40(%rsi),%rdi
	movq %rdi,40(%rax)
	jmp L23
L22:
	movq 40(%rsi),%rax
	movq %rax,8(%rdi)
L23:
	movq 32(%rsi),%rdi
	movq 40(%rsi),%rax
	movq %rdi,(%rax)
	movq %rsi,%rdi
	call _free
L17:
	popq %rbp
	ret
L27:
_block_new:
L28:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L29:
	movl $528,%edi
	call _safe_malloc
	movq %rax,%rbx
	movl _last_asm_label(%rip),%esi
	addl $1,%esi
	movl %esi,_last_asm_label(%rip)
	movl %esi,(%rbx)
	leaq 8(%rbx),%rsi
	movq $0,8(%rbx)
	movq %rsi,16(%rbx)
	movl $2,24(%rbx)
	leaq 32(%rbx),%rdi
	call _live_init
	leaq 176(%rbx),%rsi
	movq $0,176(%rbx)
	movq %rsi,184(%rbx)
	movl $0,168(%rbx)
	leaq 416(%rbx),%rsi
	movq $0,416(%rbx)
	movq %rsi,424(%rbx)
	movl $0,408(%rbx)
	leaq 440(%rbx),%rsi
	movq $0,440(%rbx)
	movq %rsi,448(%rbx)
	movl $0,432(%rbx)
	leaq 464(%rbx),%rsi
	movq $0,464(%rbx)
	movq %rsi,472(%rbx)
	leaq 480(%rbx),%rsi
	movq $0,480(%rbx)
	movq %rsi,488(%rbx)
	leaq 512(%rbx),%rsi
	movq $0,512(%rbx)
	movq _blocks+8(%rip),%rdi
	movq %rdi,520(%rbx)
	movq _blocks+8(%rip),%rdi
	movq %rbx,(%rdi)
	movq %rsi,_blocks+8(%rip)
	movq %rbx,%rax
L30:
	popq %rbx
	popq %rbp
	ret
L68:
_block_free:
L69:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L82:
	movq %rdi,%rbx
	leaq 8(%rbx),%rdi
	call _insns_clear
	leaq 32(%rbx),%rdi
	call _live_clear
	leaq 168(%rbx),%rdi
	call _regs_clear
	leaq 408(%rbx),%rdi
	call _blks_clear
	leaq 432(%rbx),%rdi
	call _blks_clear
	movq 328(%rbx),%rdi
	call _operand_free
L72:
	movq %rbx,%rdi
	xorl %esi,%esi
	call _block_get_successor_n
	cmpq $0,%rax
	jz L75
L73:
	movq %rbx,%rdi
	movq %rax,%rsi
	call _block_remove_successor
	jmp L72
L75:
	movq 512(%rbx),%rsi
	cmpq $0,%rsi
	jz L79
L78:
	movq 520(%rbx),%rdi
	movq %rdi,520(%rsi)
	jmp L80
L79:
	movq 520(%rbx),%rsi
	movq %rsi,_blocks+8(%rip)
L80:
	movq 512(%rbx),%rsi
	movq 520(%rbx),%rdi
	movq %rsi,(%rdi)
	movq %rbx,%rdi
	call _free
L71:
	popq %rbx
	popq %rbp
	ret
L84:
_block_add_successor:
L85:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L90:
	movq %rdi,%r12
	movq %rdx,%rbx
	leaq 464(%r12),%rdi
	movq %rbx,%rdx
	call _cessor_new
	movq %rax,%r13
	leaq 480(%rbx),%rdi
	movl $11,%esi
	movq %r12,%rdx
	call _cessor_new
	movq %r13,%rax
L87:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L92:
_block_find_predecessor:
L94:
	pushq %rbp
	movq %rsp,%rbp
L95:
	movq 480(%rdi),%rax
L97:
	cmpq 8(%rax),%rsi
	jz L96
L99:
	movq 32(%rax),%rax
	jmp L97
L96:
	popq %rbp
	ret
L105:
_block_remove_successor:
L106:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L110:
	movq %rdi,%r12
	movq 8(%rsi),%rbx
	leaq 464(%r12),%rdi
	call _cessor_free
	movq %rbx,%rdi
	movq %r12,%rsi
	call _block_find_predecessor
	leaq 480(%rbx),%rdi
	movq %rax,%rsi
	call _cessor_free
L108:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L112:
_block_remove_successors:
L113:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L120:
	movq %rdi,%rbx
L116:
	movq 464(%rbx),%rsi
	cmpq $0,%rsi
	jz L118
L117:
	movq %rbx,%rdi
	call _block_remove_successor
	jmp L116
L118:
	movq 328(%rbx),%rdi
	call _operand_free
	movq $0,328(%rbx)
L115:
	popq %rbx
	popq %rbp
	ret
L122:
_block_switch_sort:
L124:
	pushq %rbp
	movq %rsp,%rbp
L127:
	movq 464(%rdi),%rsi
L128:
	cmpq $0,%rsi
	jz L126
L129:
	xorl %ecx,%ecx
	movl (%rsi),%eax
	cmpl $12,%eax
	jnz L130
L135:
	movq 32(%rsi),%rax
	cmpq $0,%rax
	jz L137
L142:
	movl (%rax),%edx
	cmpl $12,%edx
	jnz L137
L138:
	movq 16(%rax),%rdx
	cmpq 16(%rsi),%rdx
	jae L137
L146:
	cmpq $0,%rax
	jz L150
L149:
	movq 40(%rsi),%rcx
	movq %rcx,40(%rax)
	jmp L151
L150:
	movq 40(%rsi),%rcx
	movq %rcx,472(%rdi)
L151:
	leaq 32(%rsi),%rcx
	movq 32(%rsi),%rdx
	movq 40(%rsi),%r8
	movq %rdx,(%r8)
	movq 32(%rax),%rdx
	movq %rdx,32(%rsi)
	cmpq $0,%rdx
	jz L156
L155:
	movq %rcx,40(%rdx)
	jmp L157
L156:
	movq %rcx,472(%rdi)
L157:
	leaq 32(%rax),%rcx
	movq %rsi,32(%rax)
	movq %rcx,40(%rsi)
	movl $1,%ecx
	jmp L135
L137:
	cmpl $0,%ecx
	jnz L127
L130:
	movq 32(%rsi),%rsi
	jmp L128
L126:
	popq %rbp
	ret
L165:
_block_switch_coalesce:
L167:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L193:
	movq %rdi,%r12
	call _block_switch_sort
	movq 464(%r12),%rbx
L170:
	cmpq $0,%rbx
	jz L169
L171:
	movl (%rbx),%esi
	cmpl $12,%esi
	jnz L172
L174:
	movq 32(%rbx),%rsi
	cmpq $0,%rsi
	jz L172
L188:
	movl (%rsi),%edi
	cmpl $12,%edi
	jnz L172
L184:
	movq 8(%rbx),%rdi
	cmpq 8(%rsi),%rdi
	jnz L172
L180:
	movq 16(%rsi),%rdi
	movq 24(%rbx),%rax
	addq $1,%rax
	cmpq %rax,%rdi
	jnz L172
L177:
	movq 24(%rsi),%rdi
	movq %rdi,24(%rbx)
	movq %r12,%rdi
	call _block_remove_successor
L172:
	movq 32(%rbx),%rbx
	jmp L170
L169:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L195:
_block_coalesce_successors:
L197:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L219:
	movq %rdi,%rbx
	cmpq $0,328(%rbx)
	jz L202
L200:
	movq %rbx,%rdi
	call _block_switch_coalesce
L202:
	movq 464(%rbx),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jz L199
L206:
	movl (%rdi),%eax
	cmpl $10,%eax
	jz L199
L205:
	movq 8(%rdi),%r12
L211:
	movq 32(%rsi),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jz L213
L212:
	cmpq 8(%rdi),%r12
	jz L211
	jnz L199
L213:
	movq %rbx,%rdi
	call _block_remove_successors
	movq %rbx,%rdi
	movl $10,%esi
	movq %r12,%rdx
	call _block_add_successor
	movq 328(%rbx),%rdi
	call _operand_free
	movq $0,328(%rbx)
L199:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L221:
_block_known_ccs:
L222:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L236:
	movq %rdi,%rbx
	movl %esi,%r13d
	movq %rbx,%rdi
	call _block_conditional
	cmpl $0,%eax
	jz L224
L225:
	movq 464(%rbx),%rsi
L228:
	cmpq $0,%rsi
	jz L224
L229:
	movq 32(%rsi),%r12
	movl (%rsi),%ecx
	movl $1,%edi
	shll %cl,%edi
	testl %edi,%r13d
	jz L233
L232:
	movl $10,(%rsi)
	jmp L230
L233:
	movq %rbx,%rdi
	call _block_remove_successor
L230:
	movq %r12,%rsi
	jmp L228
L224:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L238:
_block_redirect_successors:
L239:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L259:
	movq %rdi,%r14
	movq %rdx,%r13
	movq %rsi,%r12
	movq 464(%r14),%rbx
L242:
	cmpq $0,%rbx
	jz L245
L243:
	cmpq 8(%rbx),%r12
	jnz L244
L246:
	movq %r12,%rdi
	movq %r14,%rsi
	call _block_find_predecessor
	movq 32(%rax),%rsi
	cmpq $0,%rsi
	jz L253
L252:
	movq 40(%rax),%rdi
	movq %rdi,40(%rsi)
	jmp L254
L253:
	movq 40(%rax),%rsi
	movq %rsi,488(%r12)
L254:
	leaq 32(%rax),%rsi
	movq 32(%rax),%rdi
	movq 40(%rax),%rcx
	movq %rdi,(%rcx)
	movq $0,32(%rax)
	movq 488(%r13),%rdi
	movq %rdi,40(%rax)
	movq 488(%r13),%rdi
	movq %rax,(%rdi)
	movq %rsi,488(%r13)
	movq %r13,8(%rbx)
L244:
	movq 32(%rbx),%rbx
	jmp L242
L245:
	movq %r14,%rdi
	call _block_coalesce_successors
L241:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L261:
_block_conditional:
L262:
	pushq %rbp
	movq %rsp,%rbp
L263:
	xorl %esi,%esi
	call _block_get_successor_n
	cmpq $0,%rax
	jz L266
L268:
	movl (%rax),%esi
	cmpl $10,%esi
	jge L266
L265:
	movl $1,%eax
	jmp L264
L266:
	xorl %eax,%eax
L264:
	popq %rbp
	ret
L277:
_block_ccs:
L278:
	pushq %rbp
	movq %rsp,%rbp
L279:
	xorl %eax,%eax
	movq 464(%rdi),%rdi
L281:
	cmpq $0,%rdi
	jz L280
L282:
	movl (%rdi),%ecx
	cmpl $10,%ecx
	jge L283
L285:
	movl $1,%esi
	shll %cl,%esi
	orl %esi,%eax
L283:
	movq 32(%rdi),%rdi
	jmp L281
L280:
	popq %rbp
	ret
L292:
_block_switch:
L293:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L297:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rdi
	movl $13,%esi
	call _block_add_successor
	movq %r12,%rdi
	call _operand_leaf
	movq %rax,328(%rbx)
L295:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L299:
_block_switch_case:
L300:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L311:
	movq %rdi,%r14
	movq %rsi,%r12
	movq %rdx,%r13
	movq 464(%r14),%rbx
L303:
	movq 32(%rbx),%rsi
	movq %rsi,%rbx
	cmpq $0,%rsi
	jz L305
L304:
	cmpq %r12,16(%rsi)
	jnz L303
L306:
	pushq $L309
	pushq $1
	call _error
	addq $16,%rsp
	jmp L303
L305:
	movq %r14,%rdi
	movl $12,%esi
	movq %r13,%rdx
	call _block_add_successor
	movq %r12,24(%rax)
	movq %r12,16(%rax)
L302:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L313:
_block_switch_done:
L314:
	pushq %rbp
	movq %rsp,%rbp
L315:
	call _block_coalesce_successors
L316:
	popq %rbp
	ret
L320:
_block_switch_lookup:
L321:
	pushq %rbp
	movq %rsp,%rbp
L322:
	movq 464(%rdi),%rax
	movq %rax,%rdi
	movq 8(%rax),%rax
L324:
	movq 32(%rdi),%rcx
	movq %rcx,%rdi
	cmpq $0,%rcx
	jz L323
L325:
	cmpq 16(%rcx),%rsi
	jb L324
L330:
	cmpq 24(%rcx),%rsi
	ja L324
L327:
	movq 8(%rcx),%rax
L323:
	popq %rbp
	ret
L339:
_get_cessor_n:
L341:
	pushq %rbp
	movq %rsp,%rbp
L342:
	movq (%rdi),%rax
L344:
	cmpl $0,%esi
	jz L343
L348:
	cmpq $0,%rax
	jz L343
L346:
	addl $-1,%esi
	movq 32(%rax),%rax
	jmp L344
L343:
	popq %rbp
	ret
L356:
_block_get_successor_n:
L357:
	pushq %rbp
	movq %rsp,%rbp
L358:
	addq $464,%rdi
	call _get_cessor_n
L359:
	popq %rbp
	ret
L364:
_block_get_predecessor_n:
L365:
	pushq %rbp
	movq %rsp,%rbp
L366:
	addq $480,%rdi
	call _get_cessor_n
L367:
	popq %rbp
	ret
L372:
_nr_cessors:
L374:
	pushq %rbp
	movq %rsp,%rbp
L375:
	xorl %eax,%eax
	movq (%rdi),%rsi
L377:
	cmpq $0,%rsi
	jz L376
L379:
	addl $1,%eax
	movq 32(%rsi),%rsi
	jmp L377
L376:
	popq %rbp
	ret
L385:
_block_nr_successors:
L386:
	pushq %rbp
	movq %rsp,%rbp
L387:
	addq $464,%rdi
	call _nr_cessors
L388:
	popq %rbp
	ret
L393:
_block_nr_predecessors:
L394:
	pushq %rbp
	movq %rsp,%rbp
L395:
	addq $480,%rdi
	call _nr_cessors
L396:
	popq %rbp
	ret
L401:
_block_cc_successor:
L402:
	pushq %rbp
	movq %rsp,%rbp
L403:
	movq 464(%rdi),%rax
L405:
	cmpq $0,%rax
	jz L408
L406:
	movl (%rax),%edi
	cmpl %esi,%edi
	jz L404
L407:
	movq 32(%rax),%rax
	jmp L405
L408:
	xorl %eax,%eax
L404:
	popq %rbp
	ret
L417:
_block_always_successor:
L418:
	pushq %rbp
	movq %rsp,%rbp
L419:
	movq 464(%rdi),%rax
	cmpq $0,%rax
	jz L422
L424:
	movl (%rax),%esi
	cmpl $10,%esi
	jz L420
L422:
	xorl %eax,%eax
L420:
	popq %rbp
	ret
L433:
_block_sole_predecessor:
L434:
	pushq %rbp
	movq %rsp,%rbp
L435:
	movq 480(%rdi),%rax
	cmpq $0,%rax
	jz L438
L440:
	cmpq $0,32(%rax)
	jz L436
L438:
	xorl %eax,%eax
L436:
	popq %rbp
	ret
L449:
_block_rewrite_zs:
L450:
	pushq %rbp
	movq %rsp,%rbp
L451:
	xorl %eax,%eax
	movq 464(%rdi),%rdi
L453:
	cmpq $0,%rdi
	jz L452
L454:
	movl (%rdi),%ecx
	cmpl $0,%ecx
	jz L461
L470:
	cmpl $1,%ecx
	jnz L452
L463:
	movl %esi,(%rdi)
	jmp L459
L461:
	movl %esi,%eax
	xorl $1,%eax
	movl %eax,(%rdi)
L459:
	movl $1,%eax
	movq 32(%rdi),%rdi
	jmp L453
L452:
	popq %rbp
	ret
L474:
_block_dup_successors:
L475:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L486:
	movq %rsi,%r12
	movq %rdi,%rbx
	call _block_remove_successors
	movq 464(%r12),%r13
L478:
	cmpq $0,%r13
	jz L481
L479:
	movq 8(%r13),%rdx
	movl (%r13),%esi
	movq %rbx,%rdi
	call _block_add_successor
	movq 32(%r13),%r13
	jmp L478
L481:
	movq 328(%r12),%rdi
	cmpq $0,%rdi
	jz L477
L482:
	call _operand_dup
	movq %rax,328(%rbx)
L477:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L488:
_block_substitute_reg:
L489:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L501:
	movl %edx,%r14d
	movl %esi,%r13d
	xorl %ebx,%ebx
	movq 8(%rdi),%r12
L492:
	cmpq $0,%r12
	jz L495
L493:
	movq %r12,%rdi
	movl %r13d,%esi
	movl %r14d,%edx
	movl $3,%ecx
	call _insn_substitute_reg
	cmpl $0,%eax
	jz L494
L496:
	movl $1,%ebx
L494:
	movq 40(%r12),%r12
	jmp L492
L495:
	movl %ebx,%eax
L491:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L503:
_blocks_substitute_reg:
L504:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L516:
	movl %esi,%r14d
	movl %edi,%r13d
	xorl %ebx,%ebx
	movq _blocks(%rip),%r12
L507:
	cmpq $0,%r12
	jz L510
L508:
	movq %r12,%rdi
	movl %r13d,%esi
	movl %r14d,%edx
	call _block_substitute_reg
	cmpl $0,%eax
	jz L509
L511:
	movl $1,%ebx
L509:
	movq 512(%r12),%r12
	jmp L507
L510:
	movl %ebx,%eax
L506:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L518:
_block_split:
L519:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L524:
	movq %rdi,%r12
	movl %esi,%r13d
	call _block_new
	movq %rax,%rbx
	movq %rbx,%rdi
	movq %r12,%rsi
	call _block_dup_successors
	movq %r12,%rdi
	call _block_remove_successors
	movq %r12,%rdi
	movl $10,%esi
	movq %rbx,%rdx
	call _block_add_successor
	leaq 8(%r12),%rsi
	movl 24(%r12),%edx
	subl %r13d,%edx
	leaq 8(%rbx),%rdi
	call _insns_push
	movq %rbx,%rax
L521:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L526:
_block_split_edge:
L527:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L532:
	movq %rdi,%r13
	movq %rsi,%r15
	movl (%r15),%r14d
	movq 8(%r15),%rbx
	call _block_new
	movq %rax,%r12
	movq %r12,%rdi
	movl $10,%esi
	movq %rbx,%rdx
	call _block_add_successor
	movq %r13,%rdi
	movq %r15,%rsi
	call _block_remove_successor
	movq %r13,%rdi
	movl %r14d,%esi
	movq %r12,%rdx
	call _block_add_successor
	movq %r12,%rax
L529:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L534:
_walk0:
L536:
	pushq %rbp
	movq %rsp,%rbp
L537:
	andl $-2,4(%rdi)
	xorl %eax,%eax
L538:
	popq %rbp
	ret
L543:
_walk1:
L545:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L562:
	movq %rdi,%r14
	movq %rdx,%r12
	movq %rsi,%rbx
	movl 4(%r14),%esi
	testl $1,%esi
	jnz L547
L548:
	orl $1,%esi
	movl %esi,4(%r14)
	cmpq $0,%rbx
	jz L553
L551:
	movq %r14,%rdi
	call *%rbx
L553:
	xorl %r13d,%r13d
L554:
	movq %r14,%rdi
	movl %r13d,%esi
	call _block_get_successor_n
	cmpq $0,%rax
	jz L557
L555:
	movq 8(%rax),%rdi
	movq %rbx,%rsi
	movq %r12,%rdx
	call _walk1
	addl $1,%r13d
	jmp L554
L557:
	cmpq $0,%r12
	jz L547
L558:
	movq %r14,%rdi
	call *%r12
L547:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L564:
_blocks_walk:
L565:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L569:
	movq %rsi,%rbx
	movq %rdi,%r12
	movq $_walk0,%rdi
	call _blocks_iter
	movq _entry_block(%rip),%rdi
	movq %r12,%rsi
	movq %rbx,%rdx
	call _walk1
L567:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L571:
_blocks_iter:
L572:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L594:
	movq %rdi,%r13
L575:
	xorl %ebx,%ebx
	movq _blocks(%rip),%rdi
L578:
	cmpq $0,%rdi
	jz L577
L579:
	movq 512(%rdi),%r12
	call *%r13
	cmpl $1,%eax
	jz L586
L592:
	cmpl $2,%eax
	jnz L580
L588:
	movl $1,%ebx
L580:
	movq %r12,%rdi
	jmp L578
L586:
	movl $1,%eax
	jmp L574
L577:
	cmpl $0,%ebx
	jnz L575
L576:
	xorl %eax,%eax
L574:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L596:
_sequence0:
L598:
	pushq %rbp
	movq %rsp,%rbp
L601:
	movq 512(%rdi),%rsi
	cmpq $0,%rsi
	jz L605
L604:
	movq 520(%rdi),%rax
	movq %rax,520(%rsi)
	jmp L606
L605:
	movq 520(%rdi),%rsi
	movq %rsi,_blocks+8(%rip)
L606:
	leaq 512(%rdi),%rsi
	movq 512(%rdi),%rax
	movq 520(%rdi),%rcx
	movq %rax,(%rcx)
	movq _blocks(%rip),%rax
	movq %rax,512(%rdi)
	cmpq $0,%rax
	jz L611
L610:
	movq _blocks(%rip),%rax
	movq %rsi,520(%rax)
	jmp L612
L611:
	movq %rsi,_blocks+8(%rip)
L612:
	movq %rdi,_blocks(%rip)
	movq $_blocks,520(%rdi)
L600:
	popq %rbp
	ret
L616:
_blocks_sequence:
L617:
	pushq %rbp
	movq %rsp,%rbp
L621:
	xorl %edi,%edi
	movq $_sequence0,%rsi
	call _blocks_walk
L619:
	popq %rbp
	ret
L623:
_func_new:
L624:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L625:
	leaq -16(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rbx,-8(%rbp)
	movq %rdi,_func_sym(%rip)
	movq $0,_func_ret_type(%rip)
	movq $_func_ret_type,_func_ret_type+8(%rip)
	leaq 32(%rdi),%rsi
	movq $_func_ret_type,%rdi
	call _type_deref
	movq $0,_blocks(%rip)
	movq $_blocks,_blocks+8(%rip)
	call _block_new
	movq %rax,_entry_block(%rip)
	call _block_new
	movq %rax,_current_block(%rip)
	movq _entry_block(%rip),%rdi
	movl $10,%esi
	movq %rax,%rdx
	call _block_add_successor
	call _block_new
	movq %rax,_exit_block(%rip)
	movq _target(%rip),%rsi
	movq 32(%rsi),%rsi
	call *%rsi
	movq _func_ret_type(%rip),%rsi
	movq (%rsi),%rsi
	testq $65536,%rsi
	jz L634
L633:
	movq %rbx,%rdi
	movq $_func_ret_type,%rsi
	call _type_ref
	movq %rbx,%rdi
	call _symbol_temp
	movq %rax,_func_strun_ret(%rip)
	orl $134217728,12(%rax)
	movq _target(%rip),%rsi
	movq 80(%rsi),%rsi
	movq _func_strun_ret(%rip),%rdi
	call *%rsi
	movq %rbx,%rdi
	call _type_clear
	jmp L639
L634:
	movq $0,_func_strun_ret(%rip)
L639:
	movq $0,_func_regs+8(%rip)
	movq $_func_regs+8,_func_regs+16(%rip)
	movl $0,_func_regs(%rip)
L626:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L645:
_func_free:
L646:
	pushq %rbp
	movq %rsp,%rbp
L649:
	movq _blocks(%rip),%rdi
	cmpq $0,%rdi
	jz L651
L650:
	call _block_free
	jmp L649
L651:
	movq $_func_ret_type,%rdi
	call _type_clear
	movq $0,_func_strun_ret(%rip)
	movq $_func_regs,%rdi
	call _regs_clear
L648:
	popq %rbp
	ret
L655:
L309:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,99,97,115,101,32,108
	.byte 97,98,101,108,0
.globl _block_switch_lookup
.globl _operand_dup
.globl _symbol_temp
.globl _blocks_iter
.globl _block_remove_successor
.globl _block_sole_predecessor
.globl _block_always_successor
.globl _block_cc_successor
.globl _block_add_successor
.globl _blks_clear
.globl _live_clear
.globl _regs_clear
.globl _insns_clear
.globl _type_clear
.globl _error
.local _blocks
.comm _blocks, 16, 8
.comm _func_regs, 24, 8
.globl _func_regs
.globl _block_known_ccs
.globl _block_ccs
.globl _target
.comm _func_strun_ret, 8, 8
.globl _func_strun_ret
.globl _block_split
.globl _live_init
.comm _func_ret_type, 16, 8
.globl _func_ret_type
.globl _block_switch_done
.globl _func_new
.globl _block_new
.globl _blocks_walk
.globl _block_nr_predecessors
.globl _block_nr_successors
.globl _block_dup_successors
.globl _block_rewrite_zs
.globl _block_remove_successors
.globl _block_redirect_successors
.globl _safe_malloc
.globl _func_free
.globl _blocks_sequence
.globl _block_switch_case
.globl _block_split_edge
.globl _block_free
.globl _operand_free
.globl _free
.globl _operand_leaf
.globl _type_deref
.globl _type_ref
.globl _blocks_substitute_reg
.globl _block_substitute_reg
.globl _insn_substitute_reg
.globl _block_switch
.globl _insns_push
.comm _current_block, 8, 8
.globl _current_block
.comm _exit_block, 8, 8
.globl _exit_block
.comm _entry_block, 8, 8
.globl _entry_block
.globl _block_conditional
.globl _last_asm_label
.comm _func_sym, 8, 8
.globl _func_sym
.globl _block_get_predecessor_n
.globl _block_get_successor_n

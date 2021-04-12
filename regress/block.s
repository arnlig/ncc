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
	movl $552,%edi
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
	leaq 168(%rbx),%rdi
	call _kill_init
	leaq 440(%rbx),%rsi
	movq $0,440(%rbx)
	movq %rsi,448(%rbx)
	movl $0,432(%rbx)
	leaq 464(%rbx),%rsi
	movq $0,464(%rbx)
	movq %rsi,472(%rbx)
	movl $0,456(%rbx)
	leaq 488(%rbx),%rsi
	movq $0,488(%rbx)
	movq %rsi,496(%rbx)
	leaq 504(%rbx),%rsi
	movq $0,504(%rbx)
	movq %rsi,512(%rbx)
	leaq 536(%rbx),%rsi
	movq $0,536(%rbx)
	movq _blocks+8(%rip),%rdi
	movq %rdi,544(%rbx)
	movq _blocks+8(%rip),%rdi
	movq %rbx,(%rdi)
	movq %rsi,_blocks+8(%rip)
	movq %rbx,%rax
L30:
	popq %rbx
	popq %rbp
	ret
L62:
_block_free:
L63:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L76:
	movq %rdi,%rbx
	leaq 8(%rbx),%rdi
	call _insns_clear
	leaq 32(%rbx),%rdi
	call _live_clear
	leaq 168(%rbx),%rdi
	call _kill_clear
	leaq 432(%rbx),%rdi
	call _blks_clear
	leaq 456(%rbx),%rdi
	call _blks_clear
	movq 352(%rbx),%rdi
	call _operand_free
L66:
	movq %rbx,%rdi
	xorl %esi,%esi
	call _block_get_successor_n
	cmpq $0,%rax
	jz L69
L67:
	movq %rbx,%rdi
	movq %rax,%rsi
	call _block_remove_successor
	jmp L66
L69:
	movq 536(%rbx),%rsi
	cmpq $0,%rsi
	jz L73
L72:
	movq 544(%rbx),%rdi
	movq %rdi,544(%rsi)
	jmp L74
L73:
	movq 544(%rbx),%rsi
	movq %rsi,_blocks+8(%rip)
L74:
	movq 536(%rbx),%rsi
	movq 544(%rbx),%rdi
	movq %rsi,(%rdi)
	movq %rbx,%rdi
	call _free
L65:
	popq %rbx
	popq %rbp
	ret
L78:
_block_add_successor:
L79:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L84:
	movq %rdi,%r12
	movq %rdx,%rbx
	leaq 488(%r12),%rdi
	movq %rbx,%rdx
	call _cessor_new
	movq %rax,%r13
	leaq 504(%rbx),%rdi
	movl $11,%esi
	movq %r12,%rdx
	call _cessor_new
	movq %r13,%rax
L81:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L86:
_block_find_predecessor:
L88:
	pushq %rbp
	movq %rsp,%rbp
L89:
	movq 504(%rdi),%rax
L91:
	cmpq 8(%rax),%rsi
	jz L90
L93:
	movq 32(%rax),%rax
	jmp L91
L90:
	popq %rbp
	ret
L99:
_block_remove_successor:
L100:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L104:
	movq %rdi,%r12
	movq 8(%rsi),%rbx
	leaq 488(%r12),%rdi
	call _cessor_free
	movq %rbx,%rdi
	movq %r12,%rsi
	call _block_find_predecessor
	leaq 504(%rbx),%rdi
	movq %rax,%rsi
	call _cessor_free
L102:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L106:
_block_remove_successors:
L107:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L114:
	movq %rdi,%rbx
L110:
	movq 488(%rbx),%rsi
	cmpq $0,%rsi
	jz L112
L111:
	movq %rbx,%rdi
	call _block_remove_successor
	jmp L110
L112:
	movq 352(%rbx),%rdi
	call _operand_free
	movq $0,352(%rbx)
L109:
	popq %rbx
	popq %rbp
	ret
L116:
_block_switch_sort:
L118:
	pushq %rbp
	movq %rsp,%rbp
L121:
	movq 488(%rdi),%rsi
L122:
	cmpq $0,%rsi
	jz L120
L123:
	xorl %ecx,%ecx
	movl (%rsi),%eax
	cmpl $12,%eax
	jnz L124
L129:
	movq 32(%rsi),%rax
	cmpq $0,%rax
	jz L131
L136:
	movl (%rax),%edx
	cmpl $12,%edx
	jnz L131
L132:
	movq 16(%rax),%rdx
	cmpq 16(%rsi),%rdx
	jae L131
L140:
	cmpq $0,%rax
	jz L144
L143:
	movq 40(%rsi),%rcx
	movq %rcx,40(%rax)
	jmp L145
L144:
	movq 40(%rsi),%rcx
	movq %rcx,496(%rdi)
L145:
	leaq 32(%rsi),%rcx
	movq 32(%rsi),%rdx
	movq 40(%rsi),%r8
	movq %rdx,(%r8)
	movq 32(%rax),%rdx
	movq %rdx,32(%rsi)
	cmpq $0,%rdx
	jz L150
L149:
	movq %rcx,40(%rdx)
	jmp L151
L150:
	movq %rcx,496(%rdi)
L151:
	leaq 32(%rax),%rcx
	movq %rsi,32(%rax)
	movq %rcx,40(%rsi)
	movl $1,%ecx
	jmp L129
L131:
	cmpl $0,%ecx
	jnz L121
L124:
	movq 32(%rsi),%rsi
	jmp L122
L120:
	popq %rbp
	ret
L159:
_block_switch_coalesce:
L161:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L187:
	movq %rdi,%r12
	call _block_switch_sort
	movq 488(%r12),%rbx
L164:
	cmpq $0,%rbx
	jz L163
L165:
	movl (%rbx),%esi
	cmpl $12,%esi
	jnz L166
L168:
	movq 32(%rbx),%rsi
	cmpq $0,%rsi
	jz L166
L182:
	movl (%rsi),%edi
	cmpl $12,%edi
	jnz L166
L178:
	movq 8(%rbx),%rdi
	cmpq 8(%rsi),%rdi
	jnz L166
L174:
	movq 16(%rsi),%rdi
	movq 24(%rbx),%rax
	addq $1,%rax
	cmpq %rax,%rdi
	jnz L166
L171:
	movq 24(%rsi),%rdi
	movq %rdi,24(%rbx)
	movq %r12,%rdi
	call _block_remove_successor
L166:
	movq 32(%rbx),%rbx
	jmp L164
L163:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L189:
_block_coalesce_successors:
L191:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L213:
	movq %rdi,%rbx
	cmpq $0,352(%rbx)
	jz L196
L194:
	movq %rbx,%rdi
	call _block_switch_coalesce
L196:
	movq 488(%rbx),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jz L193
L200:
	movl (%rdi),%eax
	cmpl $10,%eax
	jz L193
L199:
	movq 8(%rdi),%r12
L205:
	movq 32(%rsi),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jz L207
L206:
	cmpq 8(%rdi),%r12
	jz L205
	jnz L193
L207:
	movq %rbx,%rdi
	call _block_remove_successors
	movq %rbx,%rdi
	movl $10,%esi
	movq %r12,%rdx
	call _block_add_successor
	movq 352(%rbx),%rdi
	call _operand_free
	movq $0,352(%rbx)
L193:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L215:
_block_known_ccs:
L216:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L230:
	movq %rdi,%rbx
	movl %esi,%r13d
	movq %rbx,%rdi
	call _block_conditional
	cmpl $0,%eax
	jz L218
L219:
	movq 488(%rbx),%rsi
L222:
	cmpq $0,%rsi
	jz L218
L223:
	movq 32(%rsi),%r12
	movl (%rsi),%ecx
	movl $1,%edi
	shll %cl,%edi
	testl %edi,%r13d
	jz L227
L226:
	movl $10,(%rsi)
	jmp L224
L227:
	movq %rbx,%rdi
	call _block_remove_successor
L224:
	movq %r12,%rsi
	jmp L222
L218:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L232:
_block_redirect_successors:
L233:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L253:
	movq %rdi,%r14
	movq %rdx,%r13
	movq %rsi,%r12
	movq 488(%r14),%rbx
L236:
	cmpq $0,%rbx
	jz L239
L237:
	cmpq 8(%rbx),%r12
	jnz L238
L240:
	movq %r12,%rdi
	movq %r14,%rsi
	call _block_find_predecessor
	movq 32(%rax),%rsi
	cmpq $0,%rsi
	jz L247
L246:
	movq 40(%rax),%rdi
	movq %rdi,40(%rsi)
	jmp L248
L247:
	movq 40(%rax),%rsi
	movq %rsi,512(%r12)
L248:
	leaq 32(%rax),%rsi
	movq 32(%rax),%rdi
	movq 40(%rax),%rcx
	movq %rdi,(%rcx)
	movq $0,32(%rax)
	movq 512(%r13),%rdi
	movq %rdi,40(%rax)
	movq 512(%r13),%rdi
	movq %rax,(%rdi)
	movq %rsi,512(%r13)
	movq %r13,8(%rbx)
L238:
	movq 32(%rbx),%rbx
	jmp L236
L239:
	movq %r14,%rdi
	call _block_coalesce_successors
L235:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L255:
_block_conditional:
L256:
	pushq %rbp
	movq %rsp,%rbp
L257:
	xorl %esi,%esi
	call _block_get_successor_n
	cmpq $0,%rax
	jz L260
L262:
	movl (%rax),%esi
	cmpl $10,%esi
	jge L260
L259:
	movl $1,%eax
	jmp L258
L260:
	xorl %eax,%eax
L258:
	popq %rbp
	ret
L271:
_block_ccs:
L272:
	pushq %rbp
	movq %rsp,%rbp
L273:
	xorl %eax,%eax
	movq 488(%rdi),%rdi
L275:
	cmpq $0,%rdi
	jz L274
L276:
	movl (%rdi),%ecx
	cmpl $10,%ecx
	jge L277
L279:
	movl $1,%esi
	shll %cl,%esi
	orl %esi,%eax
L277:
	movq 32(%rdi),%rdi
	jmp L275
L274:
	popq %rbp
	ret
L286:
_block_switch:
L287:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L291:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rdi
	movl $13,%esi
	call _block_add_successor
	movq %r12,%rdi
	call _operand_leaf
	movq %rax,352(%rbx)
L289:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L293:
_block_switch_case:
L294:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L305:
	movq %rdi,%r14
	movq %rsi,%r12
	movq %rdx,%r13
	movq 488(%r14),%rbx
L297:
	movq 32(%rbx),%rsi
	movq %rsi,%rbx
	cmpq $0,%rsi
	jz L299
L298:
	cmpq %r12,16(%rsi)
	jnz L297
L300:
	pushq $L303
	pushq $1
	call _error
	addq $16,%rsp
	jmp L297
L299:
	movq %r14,%rdi
	movl $12,%esi
	movq %r13,%rdx
	call _block_add_successor
	movq %r12,24(%rax)
	movq %r12,16(%rax)
L296:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L307:
_block_switch_done:
L308:
	pushq %rbp
	movq %rsp,%rbp
L309:
	call _block_coalesce_successors
L310:
	popq %rbp
	ret
L314:
_block_switch_lookup:
L315:
	pushq %rbp
	movq %rsp,%rbp
L316:
	movq 488(%rdi),%rax
	movq %rax,%rdi
	movq 8(%rax),%rax
L318:
	movq 32(%rdi),%rcx
	movq %rcx,%rdi
	cmpq $0,%rcx
	jz L317
L319:
	cmpq 16(%rcx),%rsi
	jb L318
L324:
	cmpq 24(%rcx),%rsi
	ja L318
L321:
	movq 8(%rcx),%rax
L317:
	popq %rbp
	ret
L333:
_get_cessor_n:
L335:
	pushq %rbp
	movq %rsp,%rbp
L336:
	movq (%rdi),%rax
L338:
	cmpl $0,%esi
	jz L337
L342:
	cmpq $0,%rax
	jz L337
L340:
	addl $-1,%esi
	movq 32(%rax),%rax
	jmp L338
L337:
	popq %rbp
	ret
L350:
_block_get_successor_n:
L351:
	pushq %rbp
	movq %rsp,%rbp
L352:
	addq $488,%rdi
	call _get_cessor_n
L353:
	popq %rbp
	ret
L358:
_block_get_predecessor_n:
L359:
	pushq %rbp
	movq %rsp,%rbp
L360:
	addq $504,%rdi
	call _get_cessor_n
L361:
	popq %rbp
	ret
L366:
_nr_cessors:
L368:
	pushq %rbp
	movq %rsp,%rbp
L369:
	xorl %eax,%eax
	movq (%rdi),%rsi
L371:
	cmpq $0,%rsi
	jz L370
L373:
	addl $1,%eax
	movq 32(%rsi),%rsi
	jmp L371
L370:
	popq %rbp
	ret
L379:
_block_nr_successors:
L380:
	pushq %rbp
	movq %rsp,%rbp
L381:
	addq $488,%rdi
	call _nr_cessors
L382:
	popq %rbp
	ret
L387:
_block_nr_predecessors:
L388:
	pushq %rbp
	movq %rsp,%rbp
L389:
	addq $504,%rdi
	call _nr_cessors
L390:
	popq %rbp
	ret
L395:
_block_cc_successor:
L396:
	pushq %rbp
	movq %rsp,%rbp
L397:
	movq 488(%rdi),%rax
L399:
	cmpq $0,%rax
	jz L402
L400:
	movl (%rax),%edi
	cmpl %esi,%edi
	jz L398
L401:
	movq 32(%rax),%rax
	jmp L399
L402:
	xorl %eax,%eax
L398:
	popq %rbp
	ret
L411:
_block_always_successor:
L412:
	pushq %rbp
	movq %rsp,%rbp
L413:
	movq 488(%rdi),%rax
	cmpq $0,%rax
	jz L416
L418:
	movl (%rax),%esi
	cmpl $10,%esi
	jz L414
L416:
	xorl %eax,%eax
L414:
	popq %rbp
	ret
L427:
_block_sole_predecessor:
L428:
	pushq %rbp
	movq %rsp,%rbp
L429:
	movq 504(%rdi),%rax
	cmpq $0,%rax
	jz L432
L434:
	cmpq $0,32(%rax)
	jz L430
L432:
	xorl %eax,%eax
L430:
	popq %rbp
	ret
L443:
_block_rewrite_zs:
L444:
	pushq %rbp
	movq %rsp,%rbp
L445:
	xorl %eax,%eax
	movq 488(%rdi),%rdi
L447:
	cmpq $0,%rdi
	jz L446
L448:
	movl (%rdi),%ecx
	cmpl $0,%ecx
	jz L455
L464:
	cmpl $1,%ecx
	jnz L446
L457:
	movl %esi,(%rdi)
	jmp L453
L455:
	movl %esi,%eax
	xorl $1,%eax
	movl %eax,(%rdi)
L453:
	movl $1,%eax
	movq 32(%rdi),%rdi
	jmp L447
L446:
	popq %rbp
	ret
L468:
_block_dup_successors:
L469:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L480:
	movq %rsi,%r12
	movq %rdi,%rbx
	call _block_remove_successors
	movq 488(%r12),%r13
L472:
	cmpq $0,%r13
	jz L475
L473:
	movq 8(%r13),%rdx
	movl (%r13),%esi
	movq %rbx,%rdi
	call _block_add_successor
	movq 32(%r13),%r13
	jmp L472
L475:
	movq 352(%r12),%rdi
	cmpq $0,%rdi
	jz L471
L476:
	call _operand_dup
	movq %rax,352(%rbx)
L471:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L482:
_block_substitute_reg:
L483:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L495:
	movl %edx,%r14d
	movl %esi,%r13d
	xorl %ebx,%ebx
	movq 8(%rdi),%r12
L486:
	cmpq $0,%r12
	jz L489
L487:
	movq %r12,%rdi
	movl %r13d,%esi
	movl %r14d,%edx
	movl $3,%ecx
	call _insn_substitute_reg
	cmpl $0,%eax
	jz L488
L490:
	movl $1,%ebx
L488:
	movq 64(%r12),%r12
	jmp L486
L489:
	movl %ebx,%eax
L485:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L497:
_blocks_substitute_reg:
L498:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L510:
	movl %esi,%r14d
	movl %edi,%r13d
	xorl %ebx,%ebx
	movq _blocks(%rip),%r12
L501:
	cmpq $0,%r12
	jz L504
L502:
	movq %r12,%rdi
	movl %r13d,%esi
	movl %r14d,%edx
	call _block_substitute_reg
	cmpl $0,%eax
	jz L503
L505:
	movl $1,%ebx
L503:
	movq 536(%r12),%r12
	jmp L501
L504:
	movl %ebx,%eax
L500:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L512:
_block_split:
L513:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L518:
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
	movl 24(%r12),%edx
	subl %r13d,%edx
	leaq 8(%r12),%rsi
	leaq 8(%rbx),%rdi
	call _insns_push
	movq %rbx,%rax
L515:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L520:
_block_split_edge:
L521:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L526:
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
L523:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L528:
_walk0:
L530:
	pushq %rbp
	movq %rsp,%rbp
L531:
	andl $-2,4(%rdi)
	xorl %eax,%eax
L532:
	popq %rbp
	ret
L537:
_walk1:
L539:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L556:
	movq %rdi,%r14
	movq %rdx,%r12
	movq %rsi,%rbx
	movl 4(%r14),%esi
	testl $1,%esi
	jnz L541
L542:
	orl $1,%esi
	movl %esi,4(%r14)
	cmpq $0,%rbx
	jz L547
L545:
	movq %r14,%rdi
	call *%rbx
L547:
	xorl %r13d,%r13d
L548:
	movq %r14,%rdi
	movl %r13d,%esi
	call _block_get_successor_n
	cmpq $0,%rax
	jz L551
L549:
	movq 8(%rax),%rdi
	movq %rbx,%rsi
	movq %r12,%rdx
	call _walk1
	addl $1,%r13d
	jmp L548
L551:
	cmpq $0,%r12
	jz L541
L552:
	movq %r14,%rdi
	call *%r12
L541:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L558:
_blocks_walk:
L559:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L563:
	movq %rsi,%rbx
	movq %rdi,%r12
	movq $_walk0,%rdi
	call _blocks_iter
	movq _entry_block(%rip),%rdi
	movq %r12,%rsi
	movq %rbx,%rdx
	call _walk1
L561:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L565:
_blocks_iter:
L566:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L588:
	movq %rdi,%r13
L569:
	xorl %ebx,%ebx
	movq _blocks(%rip),%rdi
L572:
	cmpq $0,%rdi
	jz L571
L573:
	movq 536(%rdi),%r12
	call *%r13
	cmpl $1,%eax
	jz L580
L586:
	cmpl $2,%eax
	jnz L574
L582:
	movl $1,%ebx
L574:
	movq %r12,%rdi
	jmp L572
L580:
	movl $1,%eax
	jmp L568
L571:
	cmpl $0,%ebx
	jnz L569
L570:
	xorl %eax,%eax
L568:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L590:
_sequence0:
L592:
	pushq %rbp
	movq %rsp,%rbp
L595:
	movq 536(%rdi),%rsi
	cmpq $0,%rsi
	jz L599
L598:
	movq 544(%rdi),%rax
	movq %rax,544(%rsi)
	jmp L600
L599:
	movq 544(%rdi),%rsi
	movq %rsi,_blocks+8(%rip)
L600:
	leaq 536(%rdi),%rsi
	movq 536(%rdi),%rax
	movq 544(%rdi),%rcx
	movq %rax,(%rcx)
	movq _blocks(%rip),%rax
	movq %rax,536(%rdi)
	cmpq $0,%rax
	jz L605
L604:
	movq _blocks(%rip),%rax
	movq %rsi,544(%rax)
	jmp L606
L605:
	movq %rsi,_blocks+8(%rip)
L606:
	movq %rdi,_blocks(%rip)
	movq $_blocks,544(%rdi)
L594:
	popq %rbp
	ret
L610:
_blocks_sequence:
L611:
	pushq %rbp
	movq %rsp,%rbp
L615:
	xorl %edi,%edi
	movq $_sequence0,%rsi
	call _blocks_walk
L613:
	popq %rbp
	ret
L617:
_func_new:
L618:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L619:
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
	jz L628
L627:
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
	jmp L633
L628:
	movq $0,_func_strun_ret(%rip)
L633:
	movq $0,_func_regs+8(%rip)
	movq $_func_regs+8,_func_regs+16(%rip)
	movl $0,_func_regs(%rip)
L620:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L639:
_func_free:
L640:
	pushq %rbp
	movq %rsp,%rbp
L643:
	movq _blocks(%rip),%rdi
	cmpq $0,%rdi
	jz L645
L644:
	call _block_free
	jmp L643
L645:
	movq $_func_ret_type,%rdi
	call _type_clear
	movq $0,_func_strun_ret(%rip)
	movq $_func_regs,%rdi
	call _regs_clear
L642:
	popq %rbp
	ret
L649:
L303:
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
.globl _kill_clear
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
.globl _kill_init
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

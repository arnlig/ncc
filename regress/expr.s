.text
_promote:
L4:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L32:
	movl %esi,%r12d
	movq %rdi,%rbx
	movq 8(%rbx),%rsi
	movq (%rsi),%r13
	andq $131071,%r13
	testq $16384,%r13
	jz L9
L7:
	movq %rbx,%rdi
	call _tree_addrof
	movq %rax,%rbx
L9:
	testq $62,%r13
	jz L12
L10:
	movq %rbx,%rdi
	movl $64,%esi
	call _tree_cast_bits
	movq %rax,%rbx
L12:
	cmpl $1,%r12d
	jnz L15
L16:
	testq $1024,%r13
	jz L15
L13:
	movq %rbx,%rdi
	movl $2048,%esi
	call _tree_cast_bits
	movq %rax,%rbx
L15:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $393216,%rsi
	jz L22
L23:
	testq $40958,%rsi
	jz L22
L20:
	leaq 8(%rbx),%rsi
	movq %rbx,%rdi
	call _tree_cast
	movq %rax,%rbx
	movq 8(%rax),%rsi
	andq $-393217,(%rsi)
L22:
	testq $8192,%r13
	jz L29
L27:
	movq %rbx,%rdi
	call _tree_addrof
	movq %rax,%rbx
	leaq 8(%rax),%rdi
	call _type_fix_array
L29:
	movq %rbx,%rax
L6:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L34:
_usuals:
L36:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L65:
	movq %rdi,%rbx
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $8190,%rsi
	jz L38
L42:
	movq 32(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $8190,%rsi
	jz L38
L39:
	movl $4096,%r12d
L47:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	testq %r12,%rsi
	jnz L49
L53:
	movq 32(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	testq %r12,%rsi
	jnz L49
L48:
	sarq $1,%r12
	cmpq $64,%r12
	jnz L47
L49:
	movq 24(%rbx),%rdi
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	testq %r12,%rsi
	jnz L60
L58:
	movq 32(%rbx),%rsi
	addq $8,%rsi
	call _tree_cast
	movq %rax,24(%rbx)
L60:
	movq 32(%rbx),%rdi
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	testq %r12,%rsi
	jnz L38
L61:
	movq 24(%rbx),%rsi
	addq $8,%rsi
	call _tree_cast
	movq %rax,32(%rbx)
L38:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L67:
_lvalue:
L69:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L101:
	movl %edx,%r12d
	movl %esi,%ebx
	movq %rdi,%r13
	movl (%r13),%esi
	cmpl $2147483650,%esi
	jz L74
L75:
	movl (%r13),%esi
	cmpl $1073741829,%esi
	jz L74
L72:
	pushq %rbx
	pushq $L79
	pushq $1
	call _error
	addq $24,%rsp
L74:
	cmpl $2,%r12d
	jnz L82
L87:
	movl (%r13),%esi
	cmpl $2147483650,%esi
	jnz L82
L83:
	movq 32(%r13),%rsi
	movl 12(%rsi),%esi
	testl $128,%esi
	jz L82
L80:
	pushq %rbx
	pushq $L91
	pushq $1
	call _error
	addq $24,%rsp
L82:
	cmpl $1,%r12d
	jnz L71
L95:
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	testq $131072,%rsi
	jz L71
L92:
	pushq %rbx
	pushq $L99
	pushq $1
	call _error
	addq $24,%rsp
L71:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L103:
_pointer_left:
L105:
	pushq %rbp
	movq %rsp,%rbp
L106:
	movl (%rdi),%esi
	testl $536870912,%esi
	jz L107
L111:
	movq 32(%rdi),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $32768,%rsi
	jz L107
L108:
	call _tree_commute
L107:
	popq %rbp
	ret
L118:
_null_constant:
L120:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L146:
	movq %rdi,%rbx
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $32768,%rsi
	jz L122
L126:
	movq 32(%rbx),%rdi
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	testq $1022,%rsi
	jz L122
L123:
	call _tree_simplify
	movq %rax,32(%rbx)
	movl (%rax),%esi
	cmpl $2147483649,%esi
	jnz L122
L141:
	movq 8(%rax),%rsi
	movq (%rsi),%rsi
	testq $1022,%rsi
	jz L122
L137:
	movq 24(%rax),%rsi
	cmpq $0,%rsi
	jnz L122
L133:
	cmpq $0,32(%rax)
	jnz L122
L130:
	movq 24(%rbx),%rsi
	addq $8,%rsi
	movq %rax,%rdi
	call _tree_cast
	movq %rax,32(%rbx)
L122:
	popq %rbx
	popq %rbp
	ret
L148:
_permute0:
L150:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L151:
	call _tree_cast
	movq %rax,%rbx
	movq 24(%rbx),%rsi
	addq $8,%rsi
	leaq 8(%rbx),%rdi
	call _type_requalify
	movq %rbx,%rax
L152:
	popq %rbx
	popq %rbp
	ret
L157:
_permute_voids:
L159:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
L189:
	movq %rdi,%rbx
	movq 24(%rbx),%rdi
	movq 32(%rbx),%rcx
	leaq -16(%rbp),%rdx
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rdx,-8(%rbp)
	movq 8(%rdi),%rdx
	movq (%rdx),%r8
	testq $32768,%r8
	jz L161
L169:
	movq 8(%rcx),%r8
	movq (%r8),%r8
	testq $32768,%r8
	jz L161
L165:
	cmpq $0,%rax
	jz L173
L177:
	movq 16(%rdx),%rax
	movq (%rax),%rax
	testq $1,%rax
	jnz L162
L173:
	movq 8(%rcx),%rax
	movq (%rax),%rcx
	testq $32768,%rcx
	jz L161
L181:
	movq 16(%rax),%rax
	movq (%rax),%rax
	testq $1,%rax
	jz L161
L162:
	cmpl $0,%esi
	jnz L186
L185:
	leaq 8(%rdi),%rsi
	movq 32(%rbx),%rdi
	call _permute0
	movq %rax,32(%rbx)
	jmp L161
L186:
	leaq -16(%rbp),%r12
	movq %r12,%rdi
	movl $32768,%esi
	call _type_append_bits
	movq %r12,%rdi
	movl $1,%esi
	call _type_append_bits
	movq 24(%rbx),%rdi
	movq %r12,%rsi
	call _permute0
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	movq %r12,%rsi
	call _permute0
	movq %rax,32(%rbx)
	movq %r12,%rdi
	call _type_clear
L161:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L191:
_scale:
L193:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L208:
	movq %rdi,%r12
	movq 24(%r12),%rbx
	movq 32(%r12),%r14
	movq %r12,%rdi
	call _pointer_left
	movl (%r12),%esi
	testl $268435456,%esi
	jz L197
L199:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $32768,%rsi
	jz L197
L196:
	addq $8,%rbx
	movq %rbx,%rdi
	movl $1,%esi
	call _type_sizeof
	movq _target(%rip),%rsi
	movq 8(%rsi),%rdi
	movq %rax,%rsi
	call _tree_i
	movq %rax,%r13
	movq 8(%r14),%rsi
	movq (%rsi),%rsi
	testq $32768,%rsi
	jnz L204
L203:
	movq _target(%rip),%rsi
	movq 8(%rsi),%rsi
	movq %r14,%rdi
	call _tree_cast_bits
	movl $549454359,%edi
	movq %rax,%rsi
	movq %r13,%rdx
	call _tree_binary
	movq %rax,%r13
	movq _target(%rip),%rsi
	movq 8(%rsi),%rsi
	leaq 8(%r13),%rdi
	call _type_append_bits
	movq %r13,32(%r12)
	leaq 8(%r12),%rdi
	movq %rbx,%rsi
	call _type_copy
	jmp L198
L204:
	movq _target(%rip),%rsi
	movq 8(%rsi),%rsi
	leaq 8(%r12),%rdi
	call _type_append_bits
	movl $278,%edi
	movq %r12,%rsi
	movq %r13,%rdx
	call _tree_binary
	movq %rax,%r12
	movq _target(%rip),%rsi
	movq 8(%rsi),%rsi
	leaq 8(%rax),%rdi
	call _type_append_bits
	jmp L198
L197:
	leaq 8(%rbx),%rsi
	leaq 8(%r12),%rdi
	call _type_copy
L198:
	movq %r12,%rax
L195:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L210:
_fix_struct_assign:
L212:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L220:
	movq %rdi,%rbx
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $65536,%rsi
	jz L217
L215:
	movq 24(%rbx),%rdi
	call _tree_addrof
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	call _tree_addrof
	movq %rax,32(%rbx)
	movl $43,(%rbx)
	leaq 8(%rbx),%r12
	movq %r12,%rdi
	call _type_clear
	movq 24(%rbx),%rsi
	addq $8,%rsi
	movq %r12,%rdi
	call _type_copy
	movq %rbx,%rdi
	xorl %esi,%esi
	call _tree_fetch
	movq %rax,%rdi
	call _tree_rvalue
	movq %rax,%rbx
L217:
	movq %rbx,%rax
L214:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L222:
.data
.align 4
_map:
	.int 201326602
	.int 2
	.int 3
	.int 134218251
	.int 2
	.int 1
	.int 134217996
	.int 2
	.int 1
	.int 134220045
	.int 0
	.int 1
	.int 402653966
	.int 1
	.int 2
	.int 402654223
	.int 1
	.int 2
	.int 134219280
	.int 0
	.int 1
	.int 134219025
	.int 0
	.int 1
	.int 134219538
	.int 0
	.int 1
	.int 134219795
	.int 0
	.int 1
	.int 134217748
	.int 0
	.int 1
	.int 549453845
	.int 0
	.int 1
	.int 278
	.int 2
	.int 1
	.int 549454359
	.int 2
	.int 1
	.int 817890072
	.int 1
	.int 2
	.int 276825113
	.int 1
	.int 3
	.int 33554458
	.int 2
	.int 2
	.int 134219035
	.int 0
	.int 1
	.int 33554460
	.int 2
	.int 2
	.int 33554461
	.int 2
	.int 2
	.int 134219294
	.int 0
	.int 1
	.int 33554463
	.int 2
	.int 2
	.int 549455648
	.int 0
	.int 1
	.int 184549409
	.int 6
	.int 1
	.int 637534242
	.int 2
	.int 2
	.int 637534243
	.int 2
	.int 2
	.int 549455908
	.int 0
	.int 1
	.int 184549413
	.int 6
	.int 1
	.int 2342
	.int 0
	.int 1
	.int 67108904
	.int 2
	.int 4
.align 8
_operands:
	.quad 1022
	.quad 1022
	.quad 32768
	.quad 1022
	.quad 8190
	.quad 8190
	.quad 32768
	.quad 32768
	.quad 65536
	.quad 65536
	.quad 1
	.quad 1
	.quad 40958
	.quad 40958
.text
_check_operands:
L226:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L286:
	movl %edx,%ebx
	movl %ebx,%eax
	andl $520093696,%eax
	sarl $24,%eax
	movslq %eax,%rax
	imulq $12,%rax
	movl _map+4(%rax),%ecx
	movl _map+8(%rax),%r13d
	xorl %eax,%eax
	cmpl $11534393,%ebx
	jz L235
L281:
	cmpl $486539286,%ebx
	jz L233
L230:
	xorl %edx,%edx
	jmp L231
L233:
	movl $8,%edx
	jmp L231
L235:
	movl $20,%edx
L231:
	xorl %r8d,%r8d
L237:
	cmpl %r13d,%r8d
	jge L240
L238:
	movq 8(%rdi),%r9
	movq (%r9),%r9
	andq $131071,%r9
	leal (%rcx,%r8),%r12d
	movslq %r12d,%r12
	shlq $4,%r12
	movq _operands(%r12),%r14
	testq %r14,%r9
	jz L239
L244:
	movq 8(%rsi),%r9
	movq (%r9),%r9
	andq $131071,%r9
	movq _operands+8(%r12),%r12
	testq %r12,%r9
	jnz L240
L239:
	incl %r8d
	jmp L237
L240:
	cmpl %r13d,%r8d
	jnz L250
L249:
	movl $1,%eax
	jmp L283
L250:
	movq 8(%rdi),%rcx
	movq (%rcx),%rcx
	testq $32768,%rcx
	jz L255
L259:
	movq 8(%rsi),%rcx
	movq (%rcx),%rcx
	testq $32768,%rcx
	jnz L252
L255:
	movq 8(%rdi),%rcx
	movq (%rcx),%rcx
	testq $65536,%rcx
	jz L283
L263:
	movq 8(%rsi),%rcx
	movq (%rcx),%rcx
	testq $65536,%rcx
	jz L283
L252:
	addq $8,%rsi
	addq $8,%rdi
	call _type_compat
L283:
	cmpl $1,%eax
	jz L271
L284:
	cmpl $2,%eax
	jz L277
	jnz L228
L271:
	cmpl $11534393,%ebx
	jnz L273
L272:
	pushq $L275
	pushq $1
	call _error
	addq $16,%rsp
	jmp L277
L273:
	pushq %rbx
	pushq $L276
	pushq $1
	call _error
	addq $24,%rsp
L277:
	pushq $L278
	pushq $1
	call _error
	addq $16,%rsp
L228:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L288:
_map_binary:
L290:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L316:
	movl %edx,%r13d
	movq %rdi,%rbx
	movq %rsi,%rdi
	movl %r13d,%esi
	andl $520093696,%esi
	sarl $24,%esi
	movslq %esi,%rsi
	imulq $12,%rsi
	movl _map(%rsi),%r14d
	xorl %esi,%esi
	call _promote
	movl %r14d,%edi
	movq %rbx,%rsi
	movq %rax,%rdx
	call _tree_binary
	movq %rax,%rbx
	movq %rbx,%r12
	movq %rbx,%rdi
	call _pointer_left
	testl $67108864,%r14d
	jz L295
L293:
	movq %rbx,%rdi
	call _null_constant
	cmpl $486539286,%r13d
	jnz L297
L296:
	movl $1,%esi
	jmp L298
L297:
	xorl %esi,%esi
L298:
	movq %rbx,%rdi
	call _permute_voids
L295:
	movq 32(%rbx),%rsi
	movq 24(%rbx),%rdi
	movl %r13d,%edx
	call _check_operands
	testl $16777216,%r14d
	jz L301
L299:
	movq 24(%rbx),%rdi
	movl $424673333,%esi
	call _test_expression
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	movl $424673333,%esi
	call _test_expression
	movq %rax,32(%rbx)
L301:
	andl $15728640,%r13d
	cmpl $11534336,%r13d
	jnz L304
L302:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $8190,%rsi
	jz L304
L305:
	andq $131071,%rsi
	movq 32(%rbx),%rdi
	call _tree_cast_bits
	movq %rax,32(%rbx)
L304:
	testl $134217728,%r14d
	jnz L310
L308:
	movq %rbx,%rdi
	call _usuals
L310:
	testl $33554432,%r14d
	jz L312
L311:
	leaq 8(%rbx),%rdi
	movl $64,%esi
	call _type_append_bits
	jmp L313
L312:
	movq %rbx,%rdi
	call _scale
	movq %rax,%r12
L313:
	movq %r12,%rax
L292:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L318:
_crement:
L320:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L338:
	movl %esi,%r12d
	movl %edx,%r14d
	movq %rdi,%r13
	cmpl $27,%r14d
	jnz L324
L323:
	movl $1,%ebx
	jmp L325
L324:
	movl $-1,%ebx
L325:
	movq %r13,%rdi
	movl %r14d,%esi
	movl $1,%edx
	call _lvalue
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	testq $40958,%rsi
	jnz L328
L326:
	pushq %r14
	pushq $L329
	pushq $1
	call _error
	addq $24,%rsp
L328:
	movq 8(%r13),%rsi
	movq (%rsi),%rdi
	testq $32768,%rdi
	jz L331
L330:
	movslq %ebx,%rsi
	movq _target(%rip),%rdi
	movq 8(%rdi),%rdi
	call _tree_i
	jmp L332
L331:
	testq $1022,%rdi
	jz L334
L333:
	movslq %ebx,%rsi
	andq $131071,%rdi
	call _tree_i
	jmp L332
L334:
	cvtsi2sdl %ebx,%xmm0
	andq $131071,%rdi
	call _tree_f
L332:
	movl %r12d,%edi
	movq %r13,%rsi
	movq %rax,%rdx
	call _tree_binary
	movq %rax,%rdi
	call _scale
L322:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L340:
_primary:
L342:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L343:
	movl _token(%rip),%esi
	cmpl $2,%esi
	jz L363
L402:
	cmpl $3,%esi
	jz L349
L403:
	cmpl $4,%esi
	jz L351
L404:
	cmpl $5,%esi
	jz L353
L405:
	cmpl $6,%esi
	jz L355
L406:
	cmpl $7,%esi
	jz L357
L407:
	cmpl $8,%esi
	jz L359
L408:
	cmpl $9,%esi
	jz L361
L409:
	cmpl $262145,%esi
	jz L381
L410:
	cmpl $262156,%esi
	jz L365
L346:
	pushq %rsi
	pushq $L398
	pushq $1
	call _error
	addq $24,%rsp
	jmp L347
L365:
	call _lex
	movl _token(%rip),%esi
	cmpl $16,%esi
	jnz L367
L366:
	cmpq $0,_func_sym(%rip)
	jz L369
L372:
	cmpq $0,_current_block(%rip)
	jnz L371
L369:
	pushq $L376
	pushq $1
	call _error
	addq $16,%rsp
L371:
	call _scope_enter
	call _compound_statement
	call _scope_exit
	movq _statement_tree(%rip),%rax
	cmpq $0,%rax
	jnz L379
L378:
	call _tree_v
L379:
	movq %rax,%rbx
	movq $0,_statement_tree(%rip)
	jmp L368
L367:
	call _comma
	movq %rax,%rbx
L368:
	movl $13,%edi
	call _lex_match
	jmp L347
L381:
	movq _token+8(%rip),%r12
	call _lex
	movq _token+8(%rip),%rdx
	movl _current_scope(%rip),%edi
	movl $2,%esi
	movl $268436472,%ecx
	call _symbol_lookup
	movq %rax,%rbx
	cmpq $0,%rax
	jz L383
L382:
	movl 12(%rax),%esi
	testl $512,%esi
	jz L384
L385:
	movl 64(%rax),%esi
	movslq %esi,%rsi
	movl $64,%edi
	call _tree_i
	movq %rax,%rbx
	jmp L347
L383:
	movl _token(%rip),%esi
	cmpl $262156,%esi
	jz L391
L389:
	pushq %r12
	pushq $L392
	pushq $1
	call _error
	addq $24,%rsp
L391:
	movq %r12,%rdi
	call _symbol_implicit
	movq %rax,%rbx
L384:
	movl 12(%rbx),%esi
	testl $8,%esi
	jz L395
L393:
	pushq %r12
	pushq $L396
	pushq $1
	call _error
	addq $24,%rsp
L395:
	orl $1073741824,12(%rbx)
	movq %rbx,%rdi
	call _tree_sym
	movq %rax,%rbx
	jmp L347
L361:
	movsd _token+8(%rip),%xmm0
	movl $4096,%edi
	call _tree_f
	movq %rax,%rbx
	call _lex
	jmp L347
L359:
	movsd _token+8(%rip),%xmm0
	movl $2048,%edi
	call _tree_f
	movq %rax,%rbx
	call _lex
	jmp L347
L357:
	movsd _token+8(%rip),%xmm0
	movl $1024,%edi
	call _tree_f
	movq %rax,%rbx
	call _lex
	jmp L347
L355:
	movq _token+8(%rip),%rsi
	movl $512,%edi
	call _tree_i
	movq %rax,%rbx
	call _lex
	jmp L347
L353:
	movq _token+8(%rip),%rsi
	movl $256,%edi
	call _tree_i
	movq %rax,%rbx
	call _lex
	jmp L347
L351:
	movq _token+8(%rip),%rsi
	movl $128,%edi
	call _tree_i
	movq %rax,%rbx
	call _lex
	jmp L347
L349:
	movq _token+8(%rip),%rsi
	movl $64,%edi
	call _tree_i
	movq %rax,%rbx
	call _lex
	jmp L347
L363:
	movq _token+8(%rip),%rdi
	call _string_symbol
	movq %rax,%rdi
	call _tree_sym
	movq %rax,%rbx
	call _lex
L347:
	movq %rbx,%rax
L344:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L414:
_access:
L416:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L417:
	leaq -16(%rbp),%rsi
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rsi,-8(%rbp)
	xorl %esi,%esi
	call _promote
	movq %rax,%r13
	movl _token(%rip),%esi
	cmpl $18,%esi
	jnz L420
L419:
	movl (%rax),%esi
	cmpl $2147483650,%esi
	jz L423
L422:
	movl (%rax),%esi
	cmpl $1073741829,%esi
	jnz L424
L423:
	movl $1,%r14d
	jmp L425
L424:
	xorl %r14d,%r14d
L425:
	movq %rax,%rdi
	call _tree_addrof
	movq %rax,%r13
	jmp L421
L420:
	movl $1,%r14d
L421:
	movq 8(%r13),%rsi
	movq (%rsi),%rdi
	testq $32768,%rdi
	jz L427
L429:
	movq 16(%rsi),%rsi
	movq (%rsi),%rdi
	testq $65536,%rdi
	jz L427
L426:
	movq 8(%rsi),%r12
	jmp L428
L427:
	movl _token(%rip),%esi
	pushq %rsi
	pushq $L433
	pushq $1
	call _error
	addq $24,%rsp
L428:
	movl 12(%r12),%esi
	testl $2147483648,%esi
	jnz L436
L434:
	pushq %r12
	pushq $L437
	pushq $1
	call _error
	addq $24,%rsp
L436:
	call _lex
	movl $262145,%edi
	call _lex_expect
	movq _token+8(%rip),%rsi
	movq %r12,%rdi
	call _member_lookup
	movq %rax,%rbx
	cmpq $0,%rbx
	jnz L440
L438:
	movq _token+8(%rip),%rsi
	pushq %r12
	pushq %rsi
	pushq $L441
	pushq $1
	call _error
	addq $32,%rsp
L440:
	leaq 32(%rbx),%rsi
	leaq -16(%rbp),%r12
	movq %r12,%rdi
	call _type_copy
	movq 8(%r13),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	andq $393216,%rsi
	movq %r12,%rdi
	call _type_qualify
	movl 64(%rbx),%esi
	movslq %esi,%rsi
	movq _target(%rip),%rdi
	movq 8(%rdi),%rdi
	call _tree_i
	movl $817890072,%edi
	movq %r13,%rsi
	movq %rax,%rdx
	call _tree_binary
	movq %rax,%rbx
	leaq 8(%rbx),%rdi
	movq %r12,%rsi
	call _type_ref
	movq %r12,%rdi
	call _type_clear
	call _lex
	movq %rbx,%rdi
	xorl %esi,%esi
	call _tree_fetch
	movq %rax,%rsi
	cmpl $0,%r14d
	jnz L444
L442:
	movq %rax,%rdi
	call _tree_rvalue
	movq %rax,%rsi
L444:
	movq %rsi,%rax
L418:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L449:
_array:
L451:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L452:
	xorl %esi,%esi
	call _promote
	movq %rax,%rbx
	movl $14,%edi
	call _lex_match
	call _comma
	movl $817890072,%edi
	movq %rbx,%rsi
	movq %rax,%rdx
	call _tree_binary
	movq %rax,%rbx
	movl $15,%edi
	call _lex_match
	movq %rbx,%rdi
	call _pointer_left
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $32768,%rsi
	jz L454
L457:
	movq 32(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	testq $1022,%rsi
	jnz L456
L454:
	pushq $L461
	pushq $1
	call _error
	addq $16,%rsp
L456:
	movq %rbx,%rdi
	call _scale
	movq %rax,%rdi
	xorl %esi,%esi
	call _tree_fetch
L453:
	popq %rbx
	popq %rbp
	ret
L466:
_call:
L468:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L469:
	leaq -16(%rbp),%rsi
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rsi,-8(%rbp)
	xorl %esi,%esi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rsi
	movq (%rsi),%rdi
	testq $32768,%rdi
	jz L471
L474:
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	testq $16384,%rsi
	jnz L473
L471:
	pushq $L478
	pushq $1
	call _error
	addq $16,%rsp
L473:
	leaq 8(%rbx),%rsi
	leaq -16(%rbp),%r12
	movq %r12,%rdi
	call _type_deref
	movl $1073741827,%edi
	movq %rbx,%rsi
	call _tree_unary
	movq %rax,%r13
	leaq 8(%rax),%rdi
	movq %r12,%rsi
	call _type_deref
	call _lex
	movq -16(%rbp),%rsi
	movq 8(%rsi),%r12
	movl _token(%rip),%esi
	cmpl $13,%esi
	jz L481
L483:
	call _assignment
	movq %rax,%rbx
	cmpq $0,%r12
	jnz L487
L486:
	movq -16(%rbp),%rsi
	movq (%rsi),%rdi
	movq $4611686018427387904,%rcx
	testq %rcx,%rdi
	jnz L489
L492:
	movq (%rsi),%rsi
	movq $-9223372036854775808,%rdi
	testq %rdi,%rsi
	jz L490
L489:
	movq %rax,%rdi
	movl $1,%esi
	call _promote
	movq %rax,%rbx
	jmp L497
L490:
	pushq $L496
	pushq $1
	call _error
	addq $16,%rsp
	jmp L497
L487:
	leaq 16(%r12),%rdi
	movq %rax,%rsi
	call _fake_assign
	movq %rax,%rbx
	movq 32(%r12),%r12
L497:
	leaq 48(%rbx),%rsi
	movq $0,48(%rbx)
	movq 40(%r13),%rdi
	movq %rdi,56(%rbx)
	movq 40(%r13),%rdi
	movq %rbx,(%rdi)
	movq %rsi,40(%r13)
	movl _token(%rip),%esi
	cmpl $13,%esi
	jz L481
L501:
	movl $524309,%edi
	call _lex_match
	jmp L483
L481:
	movl $13,%edi
	call _lex_match
	cmpq $0,%r12
	jz L506
L504:
	pushq $L507
	pushq $1
	call _error
	addq $16,%rsp
L506:
	leaq -16(%rbp),%rdi
	call _type_clear
	movq %r13,%rax
L470:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L512:
_postfix:
L514:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L515:
	call _primary
	movq %rax,%rbx
L518:
	movl _token(%rip),%edx
	cmpl $14,%edx
	jz L531
L538:
	cmpl $18,%edx
	jz L529
L539:
	cmpl $26,%edx
	jz L529
L540:
	cmpl $27,%edx
	jb L541
L542:
	cmpl $28,%edx
	ja L541
L526:
	movq %rbx,%rdi
	movl $268436265,%esi
	call _crement
	movq %rax,%rbx
	call _lex
	jmp L518
L541:
	cmpl $262156,%edx
	jz L533
L522:
	movq %rbx,%rax
L516:
	popq %rbx
	popq %rbp
	ret
L533:
	movq %rbx,%rdi
	call _call
	movq %rax,%rbx
	jmp L518
L529:
	movq %rbx,%rdi
	call _access
	movq %rax,%rbx
	jmp L518
L531:
	movq %rbx,%rdi
	call _array
	movq %rax,%rbx
	jmp L518
L546:
_unary:
L549:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L550:
	leaq -16(%rbp),%r13
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	leaq -8(%rbp),%rbx
	movq %r13,-8(%rbp)
	movl _token(%rip),%r14d
	cmpl $25,%r14d
	jz L560
L620:
	cmpl $27,%r14d
	jb L621
L622:
	cmpl $28,%r14d
	ja L621
L593:
	call _lex
	call _unary
	movq %rax,%rsi
	movq %rsi,%rdi
	movl $402653966,%esi
	movl %r14d,%edx
	call _crement
	jmp L551
L621:
	cmpl $29,%r14d
	jz L576
L623:
	cmpl $81,%r14d
	jz L595
L624:
	cmpl $219414559,%r14d
	jz L562
L625:
	cmpl $236978208,%r14d
	jz L558
L626:
	cmpl $253755425,%r14d
	jz L556
L627:
	cmpl $375390250,%r14d
	jz L578
L553:
	call _postfix
	jmp L551
L578:
	call _lex
	call _cast
	movq %rax,%rbx
	movq %rbx,%rdi
	movl $375390250,%esi
	movl $2,%edx
	call _lvalue
	movl (%rbx),%esi
	cmpl $1073741829,%esi
	jnz L581
L582:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rdi
	testq $32768,%rdi
	jz L581
L586:
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movl $2147483648,%edi
	testq %rdi,%rsi
	jz L581
L579:
	pushq $L590
	pushq $1
	call _error
	addq $16,%rsp
L581:
	movq %rbx,%rdi
	call _tree_addrof
	jmp L551
L556:
	movl $1082130439,%ebx
	movl $8190,%r13d
	jmp L554
L558:
	movl $1073741832,%ebx
	movl $8190,%r13d
	jmp L554
L562:
	call _lex
	call _cast
	movq %rax,%rsi
	movq %rsi,%rdi
	xorl %esi,%esi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rsi
	movq (%rsi),%rdi
	testq $32768,%rdi
	jz L563
L566:
	cmpq $0,%r12
	jz L565
L570:
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	testq $1,%rsi
	jz L565
L563:
	pushq $L574
	pushq $1
	call _error
	addq $16,%rsp
L565:
	movq %rbx,%rdi
	xorl %esi,%esi
	call _tree_fetch
	jmp L551
L595:
	call _lex
	movl _token(%rip),%esi
	cmpl $262156,%esi
	jnz L598
L596:
	leaq -32(%rbp),%rsi
	movq %rsi,%rdi
	call _lex_peek
	subq $16,%rsp
	movups -32(%rbp),%xmm0
	movups %xmm0,(%rsp)
	call _k_decl
	addq $16,%rsp
	movl %eax,%esi
	cmpl $0,%esi
	jnz L600
L599:
	call _unary
	movq %rax,%rsi
	leaq 8(%rsi),%rdi
	movq 8(%rsi),%rax
	cmpq $0,%rax
	jz L603
L605:
	movq (%rbx),%rcx
	movq %rax,(%rcx)
	movq 16(%rsi),%rax
	movq %rax,(%rbx)
	movq $0,8(%rsi)
	movq %rdi,16(%rsi)
L603:
	movq %rsi,%rdi
	call _tree_free
	jmp L598
L600:
	call _lex
	movq %r13,%rdi
	call _abstract_declarator
	movl $13,%edi
	call _lex_match
L598:
	leaq -16(%rbp),%rbx
	movq %rbx,%rdi
	xorl %esi,%esi
	call _type_sizeof
	movq %rax,%rsi
	movq _target(%rip),%rdi
	movq 16(%rdi),%rdi
	call _tree_i
	movq %rax,%r12
	movq %rbx,%rdi
	call _type_clear
	movq %r12,%rax
	jmp L551
L576:
	call _lex
	call _cast
	movq %rax,%rsi
	movq %rsi,%rdi
	movl $407896116,%esi
	call _test_expression
	jmp L551
L560:
	movl $1082130441,%ebx
	movl $1022,%r13d
L554:
	call _lex
	call _cast
	movq %rax,%rsi
	movq %rsi,%rdi
	xorl %esi,%esi
	call _promote
	movq %rax,%r12
	movq 8(%r12),%rsi
	movq (%rsi),%rsi
	testq %r13,%rsi
	jnz L615
L613:
	pushq %r14
	pushq $L616
	pushq $1
	call _error
	addq $24,%rsp
L615:
	movl %ebx,%edi
	movq %r12,%rsi
	call _tree_unary
	movq %rax,%rbx
	movq 24(%rbx),%rsi
	addq $8,%rsi
	leaq 8(%rbx),%rdi
	call _type_copy
	movq %rbx,%rax
L551:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L631:
_cast:
L632:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L633:
	leaq -16(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rbx,-8(%rbp)
	movl _token(%rip),%esi
	cmpl $262156,%esi
	jnz L636
L638:
	leaq -32(%rbp),%rdi
	call _lex_peek
	subq $16,%rsp
	movups -32(%rbp),%xmm0
	movups %xmm0,(%rsp)
	call _k_decl
	addq $16,%rsp
	cmpl $0,%eax
	jz L636
L635:
	movl $262156,%edi
	call _lex_match
	movq %rbx,%rdi
	call _abstract_declarator
	movl $13,%edi
	call _lex_match
	call _cast
	movq %rax,%rdi
	xorl %esi,%esi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $40958,%rsi
	jz L645
L657:
	movq -16(%rbp),%rdi
	movq (%rdi),%rdi
	testq $40958,%rdi
	jz L645
L653:
	testq $7168,%rsi
	jz L649
L661:
	testq $32768,%rdi
	jnz L645
L649:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $32768,%rsi
	jz L644
L665:
	movq -16(%rbp),%rsi
	movq (%rsi),%rsi
	testq $7168,%rsi
	jz L644
L645:
	movq -16(%rbp),%rsi
	movq (%rsi),%rsi
	testq $1,%rsi
	jnz L644
L642:
	pushq $L669
	pushq $1
	call _error
	addq $16,%rsp
L644:
	leaq -16(%rbp),%r12
	movq %rbx,%rdi
	movq %r12,%rsi
	call _tree_cast
	movq %rax,%rbx
	movq %r12,%rdi
	call _type_clear
	movq %rbx,%rax
	jmp L634
L636:
	call _unary
L634:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L675:
_binary:
L676:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L688:
	movl %edi,%r14d
	cmpl $0,%r14d
	jnz L681
L679:
	call _cast
	jmp L678
L681:
	leal -1048576(%r14),%edi
	call _binary
	movq %rax,%rbx
L683:
	movl _token(%rip),%r12d
	movl %r12d,%esi
	andl $15728640,%esi
	cmpl %r14d,%esi
	jnz L685
L684:
	call _lex
	leal -1048576(%r14),%edi
	call _binary
	movq %rax,%r13
	movq %rbx,%rdi
	xorl %esi,%esi
	call _promote
	movq %rax,%rdi
	movq %r13,%rsi
	movl %r12d,%edx
	call _map_binary
	movq %rax,%rbx
	jmp L683
L685:
	movq %rbx,%rax
L678:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L690:
_ternary:
L692:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L693:
	xorl %r14d,%r14d
	movl $10485760,%edi
	call _binary
	movq %rax,%rbx
	movl _token(%rip),%esi
	cmpl $24,%esi
	jnz L697
L695:
	movq %rax,%rdi
	movl $424673333,%esi
	call _test_expression
	movq %rax,%rbx
	call _lex
	call _comma
	movq %rax,%rdi
	xorl %esi,%esi
	call _promote
	movq %rax,%r12
	movl $486539286,%edi
	call _lex_match
	call _ternary
	movq %r12,%rdi
	movq %rax,%rsi
	movl $486539286,%edx
	call _map_binary
	movq %rax,%r12
	movq 24(%r12),%rdi
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	testq $65536,%rsi
	jz L700
L698:
	call _tree_addrof
	movq %rax,24(%r12)
	movq 32(%r12),%rdi
	call _tree_addrof
	movq %rax,32(%r12)
	leaq 8(%r12),%r13
	movq %r13,%rdi
	call _type_clear
	movq 24(%r12),%rsi
	addq $8,%rsi
	movq %r13,%rdi
	call _type_copy
	movl $1,%r14d
L700:
	movl $39,%edi
	movq %rbx,%rsi
	movq %r12,%rdx
	call _tree_binary
	movq %rax,%r13
	movq %r13,%rbx
	leaq 8(%r12),%rsi
	leaq 8(%r13),%rdi
	call _type_copy
	cmpl $0,%r14d
	jz L697
L701:
	movq %r13,%rdi
	xorl %esi,%esi
	call _tree_fetch
	movq %rax,%rdi
	call _tree_rvalue
	movq %rax,%rbx
L697:
	movq %rbx,%rax
L694:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L708:
_assignment:
L709:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L710:
	call _ternary
	movq %rax,%rbx
	movl _token(%rip),%r12d
	movl %r12d,%esi
	andl $15728640,%esi
	cmpl $11534336,%esi
	jnz L711
L712:
	call _lex
	call _assignment
	movq %rax,%r13
	movq %rbx,%rdi
	movl %r12d,%esi
	movl $1,%edx
	call _lvalue
	movq %rbx,%rdi
	movq %r13,%rsi
	movl %r12d,%edx
	call _map_binary
	movq %rax,%rdi
	call _fix_struct_assign
L711:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L719:
_comma:
L720:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L721:
	call _assignment
	movq %rax,%r13
	movq %r13,%rbx
	movl _token(%rip),%esi
	cmpl $524309,%esi
	jnz L725
L723:
	call _lex
	call _comma
	movq %rax,%r14
	movq 8(%rax),%rsi
	movq (%rsi),%rsi
	testq $65536,%rsi
	jz L727
L726:
	movq %rax,%rdi
	call _tree_addrof
	movq %rax,%r14
	movl $1,%r12d
	jmp L728
L727:
	xorl %r12d,%r12d
L728:
	movl $42,%edi
	movq %r13,%rsi
	movq %r14,%rdx
	call _tree_binary
	movq %rax,%r13
	movq %r13,%rbx
	leaq 8(%r14),%rsi
	leaq 8(%r13),%rdi
	call _type_copy
	cmpl $0,%r12d
	jz L725
L729:
	movq %r13,%rdi
	xorl %esi,%esi
	call _tree_fetch
	movq %rax,%rbx
L725:
	movq %rbx,%rax
L722:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L736:
_expression:
L737:
	pushq %rbp
	movq %rsp,%rbp
L738:
	call _comma
	movq %rax,%rdi
	call _tree_simplify
L739:
	popq %rbp
	ret
L744:
_init_expression:
L745:
	pushq %rbp
	movq %rsp,%rbp
L746:
	call _assignment
L747:
	popq %rbp
	ret
L752:
_static_expression:
L753:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L754:
	call _ternary
	movq %rax,%rdi
	xorl %esi,%esi
	call _promote
	movq %rax,%rdi
	call _tree_simplify
	movq %rax,%rbx
	movl (%rbx),%esi
	cmpl $2147483649,%esi
	jz L758
L756:
	pushq $L759
	pushq $1
	call _error
	addq $16,%rsp
L758:
	movq %rbx,%rax
L755:
	popq %rbx
	popq %rbp
	ret
L764:
_int_expression:
L765:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L815:
	movq %rdi,%r12
	testl $1,%esi
	jz L769
L768:
	xorl %ebx,%ebx
	jmp L770
L769:
	movl $1,%ebx
L770:
	call _static_expression
	movq %rax,%r13
	movl (%r13),%esi
	cmpl $2147483649,%esi
	jnz L771
L778:
	cmpq $0,32(%r13)
	jnz L771
L774:
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	testq $1022,%rsi
	jnz L773
L771:
	pushq $L782
	pushq $1
	call _error
	addq $16,%rsp
L773:
	movq 24(%r13),%r14
	testq $64,%r12
	jz L785
L790:
	cmpq $-2147483648,%r14
	jl L785
L786:
	cmpq $2147483647,%r14
	jle L794
L785:
	testq $192,%r12
	jz L798
L803:
	cmpq $0,%r14
	jl L798
L799:
	movl $4294967295,%esi
	cmpq %rsi,%r14
	jle L794
L798:
	testq $768,%r12
	jnz L794
L810:
	pushq $L812
	pushq %rbx
	call _error
	addq $16,%rsp
L794:
	movq %r13,%rdi
	call _tree_free
	movq %r14,%rax
L767:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L817:
_size_expression:
L818:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L827:
	movl $128,%edi
	xorl %esi,%esi
	call _int_expression
	movq %rax,%rbx
	cmpl $134217728,%ebx
	jle L823
L821:
	pushq $L824
	pushq $1
	call _error
	addq $16,%rsp
L823:
	movl %ebx,%eax
L820:
	popq %rbx
	popq %rbp
	ret
L829:
_test_expression:
L830:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L839:
	movl %esi,%r12d
	xorl %esi,%esi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $40958,%rsi
	jnz L835
L833:
	pushq $L836
	pushq $1
	call _error
	addq $16,%rsp
L835:
	movl $64,%edi
	xorl %esi,%esi
	call _tree_i
	movq %rbx,%rdi
	movq %rax,%rsi
	movl %r12d,%edx
	call _map_binary
L832:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L841:
_assign:
L842:
	pushq %rbp
	movq %rsp,%rbp
L843:
	movl $11534393,%edx
	call _map_binary
	movq %rax,%rdi
	call _fix_struct_assign
L844:
	popq %rbp
	ret
L849:
_fake_assign:
L850:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L855:
	movq %rsi,%r13
	movq %rdi,%r12
	xorl %edi,%edi
	movl $128,%esi
	call _symbol_new
	movq %rax,%rbx
	leaq 32(%rbx),%rdi
	movq %r12,%rsi
	call _type_copy
	movq %rbx,%rdi
	call _tree_sym
	movq %rax,%rdi
	movq %r13,%rsi
	movl $11534393,%edx
	call _map_binary
	movq %rax,%r12
	movq %r12,%rdi
	call _tree_commute
	movq %r12,%rdi
	call _tree_chop_binary
	movq %rax,%r12
	movq %rbx,%rdi
	call _symbol_free
	movq %r12,%rdi
	call _tree_simplify
L852:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L857:
L433:
	.byte 105,108,108,101,103,97,108,32
	.byte 108,101,102,116,32,115,105,100
	.byte 101,32,111,102,32,37,107,32
	.byte 111,112,101,114,97,116,111,114
	.byte 0
L669:
	.byte 105,110,118,97,108,105,100,32
	.byte 99,97,115,116,0
L590:
	.byte 99,97,110,39,116,32,116,97
	.byte 107,101,32,97,100,100,114,101
	.byte 115,115,32,111,102,32,98,105
	.byte 116,32,102,105,101,108,100,0
L574:
	.byte 99,97,110,39,116,32,100,101
	.byte 114,101,102,101,114,101,110,99
	.byte 101,32,116,104,97,116,0
L99:
	.byte 111,112,101,114,97,116,111,114
	.byte 32,37,107,32,114,101,113,117
	.byte 105,114,101,115,32,110,111,110
	.byte 45,99,111,110,115,116,32,111
	.byte 112,101,114,97,110,100,0
L437:
	.byte 37,65,32,105,115,32,97,110
	.byte 32,105,110,99,111,109,112,108
	.byte 101,116,101,32,116,121,112,101
	.byte 0
L376:
	.byte 115,116,97,116,101,109,101,110
	.byte 116,32,101,120,112,114,101,115
	.byte 115,105,111,110,32,110,111,116
	.byte 32,112,101,114,109,105,116,116
	.byte 101,100,32,104,101,114,101,0
L329:
	.byte 111,112,101,114,97,116,111,114
	.byte 32,37,107,32,114,101,113,117
	.byte 105,114,101,115,32,115,99,97
	.byte 108,97,114,32,116,121,112,101
	.byte 0
L275:
	.byte 105,110,99,111,109,112,97,116
	.byte 105,98,108,101,32,116,121,112
	.byte 101,0
L91:
	.byte 99,97,110,39,116,32,97,112
	.byte 112,108,121,32,37,107,32,116
	.byte 111,32,114,101,103,105,115,116
	.byte 101,114,32,118,97,114,105,97
	.byte 98,108,101,0
L461:
	.byte 105,110,118,97,108,105,100,32
	.byte 111,112,101,114,97,110,100,115
	.byte 32,116,111,32,91,93,0
L441:
	.byte 109,101,109,98,101,114,32,39
	.byte 37,83,39,32,110,111,116,32
	.byte 105,110,32,37,65,0
L507:
	.byte 110,111,116,32,101,110,111,117
	.byte 103,104,32,102,117,110,99,116
	.byte 105,111,110,32,97,114,103,117
	.byte 109,101,110,116,115,0
L496:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,102,117,110,99,116,105,111
	.byte 110,32,97,114,103,117,109,101
	.byte 110,116,115,0
L278:
	.byte 100,105,115,99,97,114,100,115
	.byte 32,113,117,97,108,105,102,105
	.byte 101,114,115,0
L836:
	.byte 115,99,97,108,97,114,32,101
	.byte 120,112,114,101,115,115,105,111
	.byte 110,32,114,101,113,117,105,114
	.byte 101,100,0
L782:
	.byte 105,110,116,101,103,101,114,32
	.byte 99,111,110,115,116,97,110,116
	.byte 32,101,120,112,114,101,115,115
	.byte 105,111,110,32,114,101,113,117
	.byte 105,114,101,100,0
L759:
	.byte 99,111,110,115,116,97,110,116
	.byte 32,101,120,112,114,101,115,115
	.byte 105,111,110,32,114,101,113,117
	.byte 105,114,101,100,0
L824:
	.byte 115,105,122,101,32,101,120,112
	.byte 114,101,115,115,105,111,110,32
	.byte 111,117,116,32,111,102,32,114
	.byte 97,110,103,101,0
L812:
	.byte 105,110,116,101,103,101,114,32
	.byte 101,120,112,114,101,115,115,105
	.byte 111,110,32,111,117,116,32,111
	.byte 102,32,114,97,110,103,101,0
L79:
	.byte 111,112,101,114,97,116,111,114
	.byte 32,37,107,32,114,101,113,117
	.byte 105,114,101,115,32,97,110,32
	.byte 108,118,97,108,117,101,0
L396:
	.byte 39,37,83,39,32,105,115,32
	.byte 97,32,116,121,112,101,100,101
	.byte 102,0
L398:
	.byte 101,120,112,114,101,115,115,105
	.byte 111,110,32,109,105,115,115,105
	.byte 110,103,32,40,103,111,116,32
	.byte 37,107,41,0
L616:
	.byte 105,108,108,101,103,97,108,32
	.byte 111,112,101,114,97,110,100,32
	.byte 116,111,32,117,110,97,114,121
	.byte 32,37,107,0
L276:
	.byte 105,110,99,111,109,112,97,116
	.byte 105,98,108,101,32,111,112,101
	.byte 114,97,110,100,115,32,116,111
	.byte 32,98,105,110,97,114,121,32
	.byte 37,107,0
L478:
	.byte 40,41,32,114,101,113,117,105
	.byte 114,101,115,32,102,117,110,99
	.byte 116,105,111,110,32,111,114,32
	.byte 112,111,105,110,116,101,114,45
	.byte 116,111,45,102,117,110,99,116
	.byte 105,111,110,0
L392:
	.byte 39,37,83,39,32,105,115,32
	.byte 117,110,107,110,111,119,110,0
.globl _member_lookup
.globl _symbol_lookup
.globl _scope_enter
.globl _type_clear
.globl _abstract_declarator
.globl _error
.globl _target
.globl _scope_exit
.globl _symbol_implicit
.globl _tree_cast
.globl _type_compat
.globl _lex_expect
.globl _current_scope
.globl _tree_commute
.globl _tree_v
.globl _symbol_new
.globl _lex
.globl _type_fix_array
.globl _tree_cast_bits
.globl _type_append_bits
.globl _compound_statement
.globl _statement_tree
.globl _symbol_free
.globl _tree_free
.globl _tree_rvalue
.globl _tree_addrof
.globl _tree_f
.globl _type_sizeof
.globl _type_deref
.globl _type_ref
.globl _tree_fetch
.globl _lex_match
.globl _binary
.globl _tree_simplify
.globl _tree_chop_binary
.globl _tree_binary
.globl _tree_unary
.globl _tree_i
.globl _type_copy
.globl _type_requalify
.globl _type_qualify
.globl _current_block
.globl _lex_peek
.globl _string_symbol
.globl _k_decl
.globl _func_sym
.globl _tree_sym
.globl _fake_assign
.globl _assign
.globl _test_expression
.globl _size_expression
.globl _int_expression
.globl _static_expression
.globl _init_expression
.globl _expression
.globl _token

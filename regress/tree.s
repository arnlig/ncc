.text
_tree_new:
L2:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L20:
	movl %edi,%ebx
	movl $64,%edi
	call _safe_malloc
	movl %ebx,(%rax)
	leaq 8(%rax),%rsi
	movq $0,8(%rax)
	movq %rsi,16(%rax)
	movl (%rax),%esi
	testl $2147483648,%esi
	jnz L4
L11:
	movl (%rax),%esi
	testl $1073741824,%esi
	jz L4
L15:
	leaq 32(%rax),%rsi
	movq $0,32(%rax)
	movq %rsi,40(%rax)
L4:
	popq %rbx
	popq %rbp
	ret
L22:
_tree_free:
L23:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L48:
	movq %rdi,%rbx
	cmpq $0,%rbx
	jz L25
L26:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L30
L32:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jz L30
L29:
	movq 24(%rbx),%rdi
	call _tree_free
	leaq 32(%rbx),%rdi
	call _forest_clear
	jmp L31
L30:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L31
L43:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jnz L31
L36:
	movq 24(%rbx),%rdi
	call _tree_free
	movq 32(%rbx),%rdi
	call _tree_free
L31:
	leaq 8(%rbx),%rdi
	call _type_clear
	movq %rbx,%rdi
	call _free
L25:
	popq %rbx
	popq %rbp
	ret
L50:
_forest_clear:
L51:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L64:
	movq %rdi,%rbx
L54:
	movq (%rbx),%rdi
	cmpq $0,%rdi
	jz L53
L57:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L61
L60:
	movq 56(%rdi),%rax
	movq %rax,56(%rsi)
	jmp L62
L61:
	movq 56(%rdi),%rsi
	movq %rsi,8(%rbx)
L62:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_free
	jmp L54
L53:
	popq %rbx
	popq %rbp
	ret
L66:
_tree_commute:
L67:
	pushq %rbp
	movq %rsp,%rbp
L68:
	movq 24(%rdi),%rsi
	movq 32(%rdi),%rax
	movq %rax,24(%rdi)
	movq %rsi,32(%rdi)
L69:
	popq %rbp
	ret
L73:
_tree_v:
L74:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L75:
	movl $-2147483648,%edi
	call _tree_new
	movq %rax,%rbx
	leaq 8(%rbx),%rdi
	movl $1,%esi
	call _type_append_bits
	movq %rbx,%rax
L76:
	popq %rbx
	popq %rbp
	ret
L81:
_tree_i:
L82:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L87:
	movq %rsi,%r12
	movq %rdi,%r13
	movl $-2147483647,%edi
	call _tree_new
	movq %rax,%rbx
	movq %r12,24(%rbx)
	leaq 8(%rbx),%rdi
	movq %r13,%rsi
	call _type_append_bits
	movq %rbx,%rax
L84:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L89:
_tree_f:
L90:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	movsd %xmm8,-8(%rbp)
L95:
	movsd %xmm0,%xmm8
	movq %rdi,%r12
	movl $-2147483647,%edi
	call _tree_new
	movq %rax,%rbx
	movsd %xmm8,24(%rbx)
	leaq 8(%rbx),%rdi
	movq %r12,%rsi
	call _type_append_bits
	movq %rbx,%rax
L92:
	movsd -8(%rbp),%xmm8
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L97:
_tree_sym:
L98:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L103:
	movq %rdi,%r12
	movl $-2147483646,%edi
	call _tree_new
	movq %rax,%rbx
	movq %r12,32(%rbx)
	leaq 32(%r12),%rsi
	leaq 8(%rbx),%rdi
	call _type_copy
	movq %rbx,%rax
L100:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L105:
_tree_unary:
L106:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L111:
	movq %rsi,%rbx
	call _tree_new
	movq %rbx,24(%rax)
L108:
	popq %rbx
	popq %rbp
	ret
L113:
_tree_binary:
L114:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L119:
	movq %rsi,%rbx
	movq %rdx,%r12
	call _tree_new
	movq %rbx,24(%rax)
	movq %r12,32(%rax)
L116:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L121:
_tree_rvalue:
L122:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L127:
	movq %rdi,%rsi
	movl $1073741832,%edi
	call _tree_unary
	movq %rax,%rbx
	movq 24(%rbx),%rsi
	addq $8,%rsi
	leaq 8(%rbx),%rdi
	call _type_copy
	movq %rbx,%rax
L124:
	popq %rbx
	popq %rbp
	ret
L129:
_tree_chop_unary:
L130:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L144:
	movq %rdi,%rbx
	movq 24(%rbx),%r12
	movq $0,24(%rbx)
	leaq 8(%r12),%rdi
	call _type_clear
	leaq 8(%rbx),%rsi
	movq 8(%rbx),%rdi
	cmpq $0,%rdi
	jz L134
L136:
	movq 16(%r12),%rax
	movq %rdi,(%rax)
	movq 16(%rbx),%rdi
	movq %rdi,16(%r12)
	movq $0,8(%rbx)
	movq %rsi,16(%rbx)
L134:
	movq %rbx,%rdi
	call _tree_free
	movq %r12,%rax
L132:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L146:
_tree_chop_binary:
L147:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L161:
	movq %rdi,%rbx
	movq 24(%rbx),%r12
	movq $0,24(%rbx)
	leaq 8(%r12),%rdi
	call _type_clear
	leaq 8(%rbx),%rsi
	movq 8(%rbx),%rdi
	cmpq $0,%rdi
	jz L151
L153:
	movq 16(%r12),%rax
	movq %rdi,(%rax)
	movq 16(%rbx),%rdi
	movq %rdi,16(%r12)
	movq $0,8(%rbx)
	movq %rsi,16(%rbx)
L151:
	movq %rbx,%rdi
	call _tree_free
	movq %r12,%rax
L149:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L163:
_tree_fetch:
L164:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L186:
	movl %esi,%r13d
	movq %rdi,%rsi
	movl $1073741829,%edi
	call _tree_unary
	movq %rax,%r12
	movq %r12,%rbx
	movq 24(%r12),%rsi
	addq $8,%rsi
	leaq 8(%r12),%rdi
	call _type_deref
	movq 8(%r12),%rsi
	movq (%rsi),%rdi
	movq $-2147483649,%rax
	andq %rax,%rdi
	movq %rdi,(%rsi)
	testl $1,%r13d
	jnz L169
L167:
	movq 24(%r12),%rsi
	movl (%rsi),%edi
	cmpl $2147483649,%edi
	jnz L171
L177:
	cmpq $0,32(%rsi)
	jz L171
L173:
	movq 24(%rsi),%rsi
	cmpq $0,%rsi
	jnz L171
L170:
	movq %r12,%rdi
	call _tree_chop_unary
	movq %rax,%rbx
	movl $-2147483646,(%rax)
	jmp L169
L171:
	movq 24(%r12),%rsi
	movl (%rsi),%esi
	cmpl $1073741830,%esi
	jnz L169
L181:
	movq %r12,%rdi
	call _tree_chop_unary
	movq %rax,%rdi
	call _tree_chop_unary
	movq %rax,%rbx
L169:
	movq %rbx,%rax
L166:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L188:
_tree_addrof:
L189:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L204:
	movq %rdi,%rsi
	movl $1073741830,%edi
	call _tree_unary
	movq %rax,%r12
	movq %r12,%rbx
	movq 24(%r12),%rsi
	addq $8,%rsi
	leaq 8(%r12),%rdi
	call _type_ref
	movq 24(%r12),%rsi
	movl (%rsi),%edi
	cmpl $2147483650,%edi
	jnz L193
L195:
	movq 32(%rsi),%rsi
	movl 12(%rsi),%esi
	testl $48,%esi
	jz L193
L192:
	movq %r12,%rdi
	call _tree_chop_unary
	movq %rax,%rbx
	movl $-2147483647,(%rax)
	leaq 24(%rax),%rsi
	movq 8(%rax),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	call _con_normalize
	jmp L194
L193:
	movq 24(%r12),%rsi
	movl (%rsi),%esi
	cmpl $1073741829,%esi
	jnz L194
L199:
	movq %r12,%rdi
	call _tree_chop_unary
	movq %rax,%rdi
	call _tree_chop_unary
	movq %rax,%rbx
L194:
	movq %rbx,%rax
L191:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L206:
_tree_cast:
L207:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L212:
	movq %rsi,%r12
	movq %rdi,%rsi
	movl $1073741828,%edi
	call _tree_unary
	movq %rax,%rbx
	leaq 8(%rbx),%rdi
	movq %r12,%rsi
	call _type_copy
	movq %rbx,%rax
L209:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L214:
_tree_cast_bits:
L215:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L220:
	movq %rsi,%r12
	movq %rdi,%rsi
	movl $1073741828,%edi
	call _tree_unary
	movq %rax,%rbx
	leaq 8(%rbx),%rdi
	movq %r12,%rsi
	call _type_append_bits
	movq %rbx,%rax
L217:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L222:
.align 8
L242:
	.quad 0x0
_tree_nonzero:
L223:
	pushq %rbp
	movq %rsp,%rbp
L224:
	movl (%rdi),%esi
	cmpl $2147483649,%esi
	jnz L227
L229:
	cmpq $0,32(%rdi)
	jnz L227
L226:
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	testq $7168,%rsi
	jz L234
L233:
	movsd 24(%rdi),%xmm0
	ucomisd L242(%rip),%xmm0
	setnz %sil
	movzbl %sil,%eax
	jmp L225
L234:
	movq 24(%rdi),%rsi
	cmpq $0,%rsi
	setnz %sil
	movzbl %sil,%eax
	jmp L225
L227:
	xorl %eax,%eax
L225:
	popq %rbp
	ret
L243:
_tree_zero:
L244:
	pushq %rbp
	movq %rsp,%rbp
L245:
	movl (%rdi),%esi
	cmpl $2147483649,%esi
	jnz L248
L250:
	cmpq $0,32(%rdi)
	jnz L248
L247:
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	testq $7168,%rsi
	jz L255
L254:
	movsd 24(%rdi),%xmm0
	ucomisd L242(%rip),%xmm0
	setz %sil
	movzbl %sil,%eax
	jmp L246
L255:
	movq 24(%rdi),%rsi
	cmpq $0,%rsi
	setz %sil
	movzbl %sil,%eax
	jmp L246
L248:
	xorl %eax,%eax
L246:
	popq %rbp
	ret
L264:
.align 8
L640:
	.quad 0xbff0000000000000
_simplify0:
L266:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L638:
	movq %rdi,%rbx
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L270
L272:
	movl (%rbx),%eax
	testl $1073741824,%eax
	jz L270
L592:
	cmpl $1073741832,%eax
	jz L280
L278:
	movq 24(%rbx),%rsi
	movl (%rsi),%edi
	cmpl $2147483649,%edi
	jnz L271
L285:
	cmpq $0,32(%rsi)
	jnz L271
L594:
	cmpl $1073741828,%eax
	jz L312
L595:
	cmpl $1082130439,%eax
	jz L297
L596:
	cmpl $1082130441,%eax
	jnz L271
L308:
	movq 24(%rsi),%rdi
	notq %rdi
	movq %rdi,24(%rsi)
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_unary
	jmp L268
L297:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $7168,%rdi
	jz L301
L300:
	movsd 24(%rsi),%xmm0
	mulsd L640(%rip),%xmm0
	movsd %xmm0,24(%rsi)
	jmp L302
L301:
	movq 24(%rsi),%rdi
	negq %rdi
	movq %rdi,24(%rsi)
L302:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_unary
	jmp L268
L312:
	leaq 24(%rsi),%rcx
	movq 8(%rsi),%rsi
	movq (%rsi),%rdx
	movq 8(%rbx),%rsi
	movq (%rsi),%rdi
	movq %rcx,%rsi
	call _con_cast
	movq %rbx,%rdi
	call _tree_chop_unary
	jmp L268
L280:
	movq %rbx,%rdi
	call _tree_chop_unary
	jmp L268
L270:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L271
L321:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jnz L271
L314:
	movl (%rbx),%esi
	testl $536870912,%esi
	jz L327
L328:
	movq 24(%rbx),%rsi
	movl (%rsi),%edi
	cmpl $2147483649,%edi
	jnz L327
L332:
	cmpq $0,32(%rsi)
	jnz L327
L325:
	movq %rbx,%rdi
	call _tree_commute
L327:
	movq 24(%rbx),%rdi
	call _tree_nonzero
	cmpl $0,%eax
	jz L338
L336:
	movl (%rbx),%esi
	cmpl $39,%esi
	jz L343
L599:
	cmpl $184549409,%esi
	jz L345
L600:
	cmpl $184549413,%esi
	jnz L338
L347:
	movq %rbx,%rdi
	call _tree_free
	movl $64,%edi
	movl $1,%esi
	call _tree_i
	jmp L268
L345:
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L343:
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	movq %rax,%rdi
	call _tree_chop_binary
	jmp L268
L338:
	movq 24(%rbx),%rdi
	call _tree_zero
	cmpl $0,%eax
	jz L351
L349:
	movl (%rbx),%esi
	cmpl $39,%esi
	jz L356
L603:
	cmpl $184549409,%esi
	jz L358
L604:
	cmpl $184549413,%esi
	jnz L351
L360:
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L358:
	movq %rbx,%rdi
	call _tree_free
	movl $64,%edi
	xorl %esi,%esi
	call _tree_i
	jmp L268
L356:
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	movq %rax,%rbx
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L351:
	movl (%rbx),%esi
	cmpl $276825113,%esi
	jnz L364
L373:
	movq 24(%rbx),%rsi
	movl (%rsi),%edi
	cmpl $2147483649,%edi
	jnz L364
L369:
	movq 32(%rbx),%rdi
	movl (%rdi),%eax
	cmpl $2147483649,%eax
	jnz L364
L365:
	movq 32(%rdi),%rax
	cmpq 32(%rsi),%rax
	jnz L364
L362:
	movq $0,32(%rdi)
	movq 24(%rbx),%rsi
	movq $0,32(%rsi)
L364:
	movq 32(%rbx),%rsi
	movl (%rsi),%edi
	cmpl $2147483649,%edi
	jnz L271
L380:
	cmpq $0,32(%rsi)
	jnz L271
L377:
	movq 24(%rbx),%rdi
	movl (%rdi),%eax
	cmpl $2147483649,%eax
	jnz L386
L384:
	movl (%rbx),%eax
	cmpl $276825113,%eax
	jz L409
L607:
	cmpl $813695768,%eax
	jnz L386
L395:
	movq 8(%rbx),%rax
	movq (%rax),%rax
	testq $7168,%rax
	jz L399
L398:
	movsd 24(%rdi),%xmm1
	movsd 24(%rsi),%xmm0
	addsd %xmm0,%xmm1
	movsd %xmm1,24(%rdi)
	jmp L400
L399:
	testq $340,%rax
	jz L402
L401:
	movq 24(%rdi),%rax
	movq 24(%rsi),%rsi
	addq %rax,%rsi
	movq %rsi,24(%rdi)
	jmp L400
L402:
	movq 24(%rdi),%rax
	movq 24(%rsi),%rsi
	addq %rax,%rsi
	movq %rsi,24(%rdi)
L400:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L409:
	movq 8(%rbx),%rax
	movq (%rax),%rax
	testq $7168,%rax
	jz L413
L412:
	movsd 24(%rdi),%xmm1
	movsd 24(%rsi),%xmm0
	subsd %xmm0,%xmm1
	movsd %xmm1,24(%rdi)
	jmp L414
L413:
	testq $340,%rax
	jz L416
L415:
	movq 24(%rdi),%rax
	movq 24(%rsi),%rsi
	subq %rsi,%rax
	movq %rax,24(%rdi)
	jmp L414
L416:
	movq 24(%rdi),%rax
	subq 24(%rsi),%rax
	movq %rax,24(%rdi)
L414:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L386:
	movq 24(%rbx),%rsi
	movl (%rsi),%edi
	cmpl $2147483649,%edi
	jnz L271
L422:
	cmpq $0,32(%rsi)
	jnz L271
L419:
	movl (%rbx),%edi
	cmpl $134219294,%edi
	jz L479
	jb L610
L625:
	cmpl $545261604,%edi
	jz L512
	jb L626
L633:
	cmpl $637534243,%edi
	jz L539
	ja L271
L634:
	cmpl $637534242,%edi
	jnz L271
L531:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	testq $7168,%rdi
	jz L535
L534:
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setz %sil
	movzbl %sil,%r12d
	jmp L536
L535:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setz %sil
	movzbl %sil,%r12d
L536:
	movq %rbx,%rdi
	call _tree_free
	movslq %r12d,%rsi
	movl $64,%edi
	call _tree_i
	jmp L268
L539:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	testq $7168,%rdi
	jz L543
L542:
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setnz %sil
	movzbl %sil,%r12d
	jmp L544
L543:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setnz %sil
	movzbl %sil,%r12d
L544:
	movq %rbx,%rdi
	call _tree_free
	movslq %r12d,%rsi
	movl $64,%edi
	call _tree_i
	jmp L268
L626:
	cmpl $545260055,%edi
	jz L465
	jb L627
L630:
	cmpl $545261344,%edi
	jnz L271
L501:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $340,%rdi
	jz L505
L504:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rax
	andq %rax,%rdi
	movq %rdi,24(%rsi)
	jmp L506
L505:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	andq 24(%rax),%rdi
	movq %rdi,24(%rsi)
L506:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L627:
	cmpl $545259541,%edi
	jnz L271
L523:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $340,%rdi
	jz L527
L526:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rax
	xorq %rax,%rdi
	movq %rdi,24(%rsi)
	jmp L528
L527:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	xorq 24(%rax),%rdi
	movq %rdi,24(%rsi)
L528:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L465:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $7168,%rdi
	jz L469
L468:
	movsd 24(%rsi),%xmm1
	movq 32(%rbx),%rdi
	movsd 24(%rdi),%xmm0
	mulsd %xmm0,%xmm1
	movsd %xmm1,24(%rsi)
	jmp L470
L469:
	testq $340,%rdi
	jz L472
L471:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rax
	imulq %rax,%rdi
	movq %rdi,24(%rsi)
	jmp L470
L472:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rax
	imulq %rax,%rdi
	movq %rdi,24(%rsi)
L470:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L512:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $340,%rdi
	jz L516
L515:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rax
	orq %rax,%rdi
	movq %rdi,24(%rsi)
	jmp L517
L516:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	orq 24(%rax),%rdi
	movq %rdi,24(%rsi)
L517:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L610:
	cmpl $33554460,%edi
	jz L558
	jb L611
L618:
	cmpl $33554463,%edi
	jz L580
	jb L619
L622:
	cmpl $134219035,%edi
	jnz L271
L490:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $340,%rdi
	jz L494
L493:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rcx
	sarq %cl,%rdi
	movq %rdi,24(%rsi)
	jmp L495
L494:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rcx
	shrq %cl,%rdi
	movq %rdi,24(%rsi)
L495:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L619:
	cmpl $33554461,%edi
	jnz L271
L569:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	testq $7168,%rdi
	jz L573
L572:
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setb %sil
	movzbl %sil,%r12d
	jmp L574
L573:
	testq $340,%rdi
	jz L576
L575:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setl %sil
	movzbl %sil,%r12d
	jmp L574
L576:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	cmpq 24(%rdi),%rsi
	setb %sil
	movzbl %sil,%r12d
L574:
	movq %rbx,%rdi
	call _tree_free
	movslq %r12d,%rsi
	movl $64,%edi
	call _tree_i
	jmp L268
L580:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	testq $7168,%rdi
	jz L584
L583:
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setbe %sil
	movzbl %sil,%r12d
	jmp L585
L584:
	testq $340,%rdi
	jz L587
L586:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setle %sil
	movzbl %sil,%r12d
	jmp L585
L587:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	cmpq 24(%rdi),%rsi
	setbe %sil
	movzbl %sil,%r12d
L585:
	movq %rbx,%rdi
	call _tree_free
	movslq %r12d,%rsi
	movl $64,%edi
	call _tree_i
	jmp L268
L611:
	cmpl $2342,%edi
	jz L447
	jb L612
L615:
	cmpl $33554458,%edi
	jnz L271
L547:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	testq $7168,%rdi
	jz L551
L550:
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	seta %sil
	movzbl %sil,%r12d
	jmp L552
L551:
	testq $340,%rdi
	jz L554
L553:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setg %sil
	movzbl %sil,%r12d
	jmp L552
L554:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	cmpq 24(%rdi),%rsi
	seta %sil
	movzbl %sil,%r12d
L552:
	movq %rbx,%rdi
	call _tree_free
	movslq %r12d,%rsi
	movl $64,%edi
	call _tree_i
	jmp L268
L612:
	cmpl $278,%edi
	jnz L271
L430:
	movq 32(%rbx),%rdi
	call _tree_zero
	cmpl $0,%eax
	jnz L433
L437:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $7168,%rsi
	jz L441
L440:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	movq 32(%rbx),%rdi
	movsd 24(%rdi),%xmm0
	divsd %xmm0,%xmm1
	movsd %xmm1,24(%rsi)
	jmp L442
L441:
	testq $340,%rsi
	jz L444
L443:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cqto
	idivq %rdi
	movq %rax,24(%rsi)
	jmp L442
L444:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	xorl %edx,%edx
	divq %rdi
	movq %rax,24(%rsi)
L442:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	movq %rax,%rbx
L433:
	movq %rbx,%rax
	jmp L268
L447:
	movq 32(%rbx),%rdi
	call _tree_zero
	cmpl $0,%eax
	jnz L450
L454:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $340,%rsi
	jz L458
L457:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cqto
	idivq %rdi
	movq %rdx,24(%rsi)
	jmp L459
L458:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	xorl %edx,%edx
	divq %rdi
	movq %rdx,24(%rsi)
L459:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	movq %rax,%rbx
L450:
	movq %rbx,%rax
	jmp L268
L558:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	andq $131071,%rdi
	testq $7168,%rdi
	jz L562
L561:
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setae %sil
	movzbl %sil,%r12d
	jmp L563
L562:
	testq $340,%rdi
	jz L565
L564:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setge %sil
	movzbl %sil,%r12d
	jmp L563
L565:
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	cmpq 24(%rdi),%rsi
	setae %sil
	movzbl %sil,%r12d
L563:
	movq %rbx,%rdi
	call _tree_free
	movslq %r12d,%rsi
	movl $64,%edi
	call _tree_i
	jmp L268
L479:
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	testq $340,%rdi
	jz L483
L482:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rcx
	shlq %cl,%rdi
	movq %rdi,24(%rsi)
	jmp L484
L483:
	movq 24(%rsi),%rdi
	movq 32(%rbx),%rax
	movq 24(%rax),%rcx
	shlq %cl,%rdi
	movq %rdi,24(%rsi)
L484:
	movq 24(%rbx),%rsi
	addq $24,%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L271:
	movq %rbx,%rax
L268:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L641:
_tree_simplify:
L642:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L689:
	movq %rdi,%rbx
	leaq -16(%rbp),%rsi
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rsi,-8(%rbp)
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L649
L651:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jz L649
L648:
	movq 24(%rbx),%rdi
	call _tree_simplify
	movq %rax,24(%rbx)
L655:
	movq 32(%rbx),%rdi
	cmpq $0,%rdi
	jz L667
L658:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L662
L661:
	movq 56(%rdi),%rax
	movq %rax,56(%rsi)
	jmp L663
L662:
	movq 56(%rdi),%rsi
	movq %rsi,40(%rbx)
L663:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_simplify
	leaq 48(%rax),%rsi
	movq $0,48(%rax)
	movq -8(%rbp),%rdi
	movq %rdi,56(%rax)
	movq -8(%rbp),%rdi
	movq %rax,(%rdi)
	movq %rsi,-8(%rbp)
	jmp L655
L667:
	leaq -16(%rbp),%rsi
	movq -16(%rbp),%rdi
	cmpq $0,%rdi
	jz L646
L670:
	movq 40(%rbx),%rax
	movq %rdi,(%rax)
	movq 40(%rbx),%rdi
	movq -16(%rbp),%rax
	movq %rdi,56(%rax)
	movq -8(%rbp),%rdi
	movq %rdi,40(%rbx)
	movq $0,-16(%rbp)
	movq %rsi,-8(%rbp)
	jmp L646
L649:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L646
L683:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jnz L646
L676:
	movq 24(%rbx),%rdi
	call _tree_simplify
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	call _tree_simplify
	movq %rax,32(%rbx)
L646:
	movq %rbx,%rdi
	call _simplify0
L644:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L691:
_tree_rewrite_volatile:
L692:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L751:
	movq %rdi,%rbx
	movl (%rbx),%esi
	cmpl $1073741830,%esi
	jnz L697
L695:
	movq %rbx,%rax
	jmp L694
L697:
	movl (%rbx),%esi
	cmpl $2147483650,%esi
	jnz L707
L702:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	testq $262144,%rsi
	jz L707
L699:
	movq %rbx,%rdi
	call _tree_addrof
	movq %rax,%rdi
	call _tree_simplify
	movq %rax,%rdi
	movl $1,%esi
	call _tree_fetch
	jmp L694
L707:
	leaq -16(%rbp),%rsi
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rsi,-8(%rbp)
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L711
L713:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jz L711
L710:
	movq 24(%rbx),%rdi
	call _tree_rewrite_volatile
	movq %rax,24(%rbx)
L717:
	movq 32(%rbx),%rdi
	cmpq $0,%rdi
	jz L729
L720:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L724
L723:
	movq 56(%rdi),%rax
	movq %rax,56(%rsi)
	jmp L725
L724:
	movq 56(%rdi),%rsi
	movq %rsi,40(%rbx)
L725:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_rewrite_volatile
	leaq 48(%rax),%rsi
	movq $0,48(%rax)
	movq -8(%rbp),%rdi
	movq %rdi,56(%rax)
	movq -8(%rbp),%rdi
	movq %rax,(%rdi)
	movq %rsi,-8(%rbp)
	jmp L717
L729:
	leaq -16(%rbp),%rsi
	movq -16(%rbp),%rdi
	cmpq $0,%rdi
	jz L708
L732:
	movq 40(%rbx),%rax
	movq %rdi,(%rax)
	movq 40(%rbx),%rdi
	movq -16(%rbp),%rax
	movq %rdi,56(%rax)
	movq -8(%rbp),%rdi
	movq %rdi,40(%rbx)
	movq $0,-16(%rbp)
	movq %rsi,-8(%rbp)
	jmp L708
L711:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L708
L745:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jnz L708
L738:
	movq 24(%rbx),%rdi
	call _tree_rewrite_volatile
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	call _tree_rewrite_volatile
	movq %rax,32(%rbx)
L708:
	movq %rbx,%rax
L694:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L753:
_tree_opt:
L754:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L804:
	movq %rdi,%rbx
	leaq -16(%rbp),%rsi
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rsi,-8(%rbp)
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L761
L763:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jz L761
L760:
	movq 24(%rbx),%rdi
	call _tree_opt
	movq %rax,24(%rbx)
L767:
	movq 32(%rbx),%rdi
	cmpq $0,%rdi
	jz L779
L770:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L774
L773:
	movq 56(%rdi),%rax
	movq %rax,56(%rsi)
	jmp L775
L774:
	movq 56(%rdi),%rsi
	movq %rsi,40(%rbx)
L775:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_opt
	leaq 48(%rax),%rsi
	movq $0,48(%rax)
	movq -8(%rbp),%rdi
	movq %rdi,56(%rax)
	movq -8(%rbp),%rdi
	movq %rax,(%rdi)
	movq %rsi,-8(%rbp)
	jmp L767
L779:
	leaq -16(%rbp),%rsi
	movq -16(%rbp),%rdi
	cmpq $0,%rdi
	jz L758
L782:
	movq 40(%rbx),%rax
	movq %rdi,(%rax)
	movq 40(%rbx),%rdi
	movq -16(%rbp),%rax
	movq %rdi,56(%rax)
	movq -8(%rbp),%rdi
	movq %rdi,40(%rbx)
	movq $0,-16(%rbp)
	movq %rsi,-8(%rbp)
	jmp L758
L761:
	movl (%rbx),%esi
	testl $2147483648,%esi
	jnz L758
L795:
	movl (%rbx),%esi
	testl $1073741824,%esi
	jnz L758
L788:
	movq 24(%rbx),%rdi
	call _tree_opt
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	call _tree_opt
	movq %rax,32(%rbx)
L758:
	movl (%rbx),%esi
	cmpl $1073741828,%esi
	jnz L801
L799:
	movq %rbx,%rdi
	call _cast_tree_opt
	movq %rax,%rbx
L801:
	movq %rbx,%rdi
	call _field_tree_opt
	movq %rax,%rdi
	call _sign_tree_opt
L756:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L806:
.data
.align 8
_tree_op_text:
	.quad L808
	.quad L809
	.quad L810
	.quad L811
	.quad L812
	.quad L813
	.quad L814
	.quad L815
	.quad L816
	.quad L817
	.quad L818
	.quad L819
	.quad L820
	.quad L821
	.quad L822
	.quad L823
	.quad L824
	.quad L825
	.quad L826
	.quad L827
	.quad L828
	.quad L829
	.quad L830
	.quad L831
	.quad L832
	.quad L833
	.quad L834
	.quad L835
	.quad L836
	.quad L837
	.quad L838
	.quad L839
	.quad L840
	.quad L841
	.quad L842
	.quad L843
	.quad L844
	.quad L845
	.quad L846
	.quad L847
	.quad L848
	.quad L849
	.quad L850
	.quad L851
.text
_tree_debug:
L852:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L907:
	movl %esi,%ebx
	movq %rdi,%r13
	cmpl $0,%ebx
	jnz L859
L858:
	movq $L856,%rsi
	jmp L860
L859:
	movq $L857,%rsi
L860:
	pushq %rsi
	pushq $L855
	call _output
	addq $16,%rsp
	xorl %r12d,%r12d
L861:
	cmpl %ebx,%r12d
	jge L864
L862:
	pushq $L865
	call _output
	addq $8,%rsp
	addl $1,%r12d
	jmp L861
L864:
	leaq 8(%r13),%rsi
	movl (%r13),%edi
	andl $255,%edi
	movslq %edi,%rdi
	movq _tree_op_text(,%rdi,8),%rdi
	pushq %rsi
	pushq %rdi
	pushq $L866
	call _output
	addq $24,%rsp
	movl (%r13),%esi
	cmpl $-2147483647,%esi
	jz L871
L905:
	cmpl $-2147483646,%esi
	jz L873
L868:
	pushq $L856
	call _output
	addq $8,%rsp
	movl (%r13),%esi
	testl $2147483648,%esi
	jnz L882
L884:
	movl (%r13),%esi
	testl $1073741824,%esi
	jz L882
L881:
	leal 1(%rbx),%esi
	movq 24(%r13),%rdi
	call _tree_debug
	movq 32(%r13),%r12
L888:
	cmpq $0,%r12
	jz L854
L889:
	leal 2(%rbx),%esi
	movq %r12,%rdi
	call _tree_debug
	movq 48(%r12),%r12
	jmp L888
L882:
	movl (%r13),%esi
	testl $2147483648,%esi
	jnz L854
L899:
	movl (%r13),%esi
	testl $1073741824,%esi
	jnz L854
L892:
	addl $1,%ebx
	movq 24(%r13),%rdi
	movl %ebx,%esi
	call _tree_debug
	movq 32(%r13),%rdi
	movl %ebx,%esi
	call _tree_debug
	jmp L854
L871:
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	subq $8,%rsp
	movq 24(%r13),%rdi
	movq %rdi,(%rsp)
	pushq %rsi
	pushq $L872
	call _output
	addq $24,%rsp
L873:
	movq 32(%r13),%rsi
	cmpq $0,%rsi
	jz L876
L874:
	pushq %rsi
	pushq $L877
	call _output
	addq $16,%rsp
L876:
	pushq $L856
	call _output
	addq $8,%rsp
L854:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L909:
L866:
	.byte 37,115,32,60,37,84,62,32
	.byte 0
L865:
	.byte 32,32,32,32,0
L857:
	.byte 0
L843:
	.byte 78,69,81,0
L842:
	.byte 69,81,0
L839:
	.byte 76,84,69,81,0
L836:
	.byte 71,84,69,81,0
L845:
	.byte 76,79,82,0
L844:
	.byte 79,82,0
L829:
	.byte 88,79,82,0
L849:
	.byte 80,79,83,84,0
L847:
	.byte 81,85,69,83,84,0
L841:
	.byte 76,65,78,68,0
L840:
	.byte 65,78,68,0
L834:
	.byte 71,84,0
L832:
	.byte 65,68,68,0
L812:
	.byte 67,65,83,84,0
L808:
	.byte 78,79,78,69,0
L830:
	.byte 68,73,86,0
L856:
	.byte 10,0
L877:
	.byte 37,90,0
L838:
	.byte 83,72,76,0
L811:
	.byte 67,65,76,76,0
L872:
	.byte 37,67,32,0
L855:
	.byte 37,115,35,32,0
L850:
	.byte 67,79,77,77,65,0
L835:
	.byte 83,72,82,0
L833:
	.byte 83,85,66,0
L846:
	.byte 77,79,68,0
L837:
	.byte 76,84,0
L816:
	.byte 82,86,65,76,85,69,0
L814:
	.byte 65,68,68,82,79,70,0
L851:
	.byte 66,76,75,65,83,71,0
L828:
	.byte 88,79,82,65,83,71,0
L827:
	.byte 79,82,65,83,71,0
L826:
	.byte 65,78,68,65,83,71,0
L825:
	.byte 83,72,82,65,83,71,0
L824:
	.byte 83,72,76,65,83,71,0
L823:
	.byte 83,85,66,65,83,71,0
L822:
	.byte 65,68,68,65,83,71,0
L821:
	.byte 77,79,68,65,83,71,0
L820:
	.byte 68,73,86,65,83,71,0
L819:
	.byte 77,85,76,65,83,71,0
L818:
	.byte 65,83,71,0
L815:
	.byte 78,69,71,0
L813:
	.byte 70,69,84,67,72,0
L831:
	.byte 77,85,76,0
L817:
	.byte 67,79,77,0
L810:
	.byte 83,89,77,0
L848:
	.byte 67,79,76,79,78,0
L809:
	.byte 67,79,78,0
.globl _forest_clear
.globl _type_clear
.globl _tree_cast
.globl _output
.globl _con_cast
.globl _tree_rewrite_volatile
.globl _tree_commute
.globl _con_normalize
.globl _tree_v
.globl _tree_nonzero
.globl _tree_zero
.globl _tree_cast_bits
.globl _type_append_bits
.globl _safe_malloc
.globl _tree_opt
.globl _sign_tree_opt
.globl _field_tree_opt
.globl _cast_tree_opt
.globl _tree_free
.globl _tree_rvalue
.globl _free
.globl _tree_addrof
.globl _tree_f
.globl _type_deref
.globl _type_ref
.globl _tree_debug
.globl _tree_fetch
.globl _tree_simplify
.globl _tree_chop_binary
.globl _tree_chop_unary
.globl _tree_binary
.globl _tree_unary
.globl _tree_i
.globl _type_copy
.globl _tree_sym

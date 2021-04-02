.text
_tree_new:
L2:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L20:
	movl %edi,%ebx
L3:
	movl $64,%edi
	call _safe_malloc
	movq %rax,%rsi
	movl %ebx,(%rax)
	movq $0,8(%rsi)
	leaq 8(%rsi),%rdi
	movq %rdi,16(%rsi)
	movl (%rsi),%edi
	andl $2147483648,%edi
	cmpl $0,%edi
	jnz L10
L11:
	movl (%rsi),%edi
	andl $1073741824,%edi
	cmpl $0,%edi
	jz L10
L15:
	movq $0,32(%rsi)
	leaq 32(%rsi),%rdi
	movq %rdi,40(%rsi)
L10:
	movq %rsi,%rax
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
L24:
	cmpq $0,%rbx
	jz L25
L26:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L30
L32:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jz L30
L29:
	movq 24(%rbx),%rdi
	call _tree_free
	leaq 32(%rbx),%rdi
	call _forest_clear
	jmp L31
L30:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L31
L39:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L36
L43:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
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
	movq (%rbx),%rsi
	movq %rsi,%rdi
	cmpq $0,%rsi
	jz L53
L57:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L61
L60:
	movq 56(%rdi),%rsi
	movq 48(%rdi),%rax
	movq %rsi,56(%rax)
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
L83:
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
	movsd %xmm10,-8(%rbp)
L95:
	movsd %xmm0,%xmm10
	movq %rdi,%r12
L91:
	movl $-2147483647,%edi
	call _tree_new
	movq %rax,%rbx
	movsd %xmm10,24(%rbx)
	leaq 8(%rbx),%rdi
	movq %r12,%rsi
	call _type_append_bits
	movq %rbx,%rax
L92:
	movsd -8(%rbp),%xmm10
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
L99:
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
L107:
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
L115:
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
L123:
	movl $1073741832,%edi
	call _tree_unary
	movq %rax,%rbx
	movq 24(%rbx),%rsi
	leaq 8(%rsi),%rsi
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
L131:
	movq 24(%rbx),%rsi
	movq %rsi,%r12
	movq $0,24(%rbx)
	leaq 8(%rsi),%rdi
	call _type_clear
	movq 8(%rbx),%rsi
	cmpq $0,%rsi
	jz L134
L136:
	movq 8(%rbx),%rsi
	movq 16(%r12),%rdi
	movq %rsi,(%rdi)
	movq 16(%rbx),%rsi
	movq %rsi,16(%r12)
	movq $0,8(%rbx)
	leaq 8(%rbx),%rsi
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
L148:
	movq 24(%rbx),%rsi
	movq %rsi,%r12
	movq $0,24(%rbx)
	leaq 8(%rsi),%rdi
	call _type_clear
	movq 8(%rbx),%rsi
	cmpq $0,%rsi
	jz L151
L153:
	movq 8(%rbx),%rsi
	movq 16(%r12),%rdi
	movq %rsi,(%rdi)
	movq 16(%rbx),%rsi
	movq %rsi,16(%r12)
	movq $0,8(%rbx)
	leaq 8(%rbx),%rsi
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
L165:
	movl $1073741829,%edi
	call _tree_unary
	movq %rax,%r12
	movq %r12,%rbx
	movq 24(%r12),%rsi
	leaq 8(%rsi),%rsi
	leaq 8(%r12),%rdi
	call _type_deref
	movq 8(%r12),%rsi
	movq (%rsi),%rdi
	movq $-2147483649,%rax
	andq %rax,%rdi
	movq %rdi,(%rsi)
	andl $1,%r13d
	cmpl $0,%r13d
	jnz L169
L167:
	movq 24(%r12),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L171
L177:
	movq 24(%r12),%rsi
	movq 32(%rsi),%rsi
	cmpq $0,%rsi
	jz L171
L173:
	movq 24(%r12),%rsi
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
L190:
	movl $1073741830,%edi
	call _tree_unary
	movq %rax,%r12
	movq %r12,%rbx
	movq 24(%r12),%rsi
	leaq 8(%rsi),%rsi
	leaq 8(%r12),%rdi
	call _type_ref
	movq 24(%r12),%rsi
	movl (%rsi),%esi
	cmpl $2147483650,%esi
	jnz L193
L195:
	movq 24(%r12),%rsi
	movq 32(%rsi),%rsi
	movl 12(%rsi),%esi
	andl $48,%esi
	cmpl $0,%esi
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
L208:
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
L216:
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
	.quad 0x0 # 0.000000
_tree_nonzero:
L223:
	pushq %rbp
	movq %rsp,%rbp
L224:
	movl (%rdi),%esi
	cmpl $2147483649,%esi
	jnz L227
L229:
	movq 32(%rdi),%rsi
	cmpq $0,%rsi
	jnz L227
L226:
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
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
	movl $0,%eax
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
	movq 32(%rdi),%rsi
	cmpq $0,%rsi
	jnz L248
L247:
	movq 8(%rdi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
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
	movl $0,%eax
L246:
	popq %rbp
	ret
L264:
.align 8
L640:
	.quad 0xbff0000000000000 # -1.000000
_simplify0:
L266:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L638:
	movq %rdi,%rbx
L267:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L270
L272:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jz L270
L269:
	movl (%rbx),%esi
L592:
	cmpl $1073741832,%esi
	jz L280
L278:
	movq 24(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L271
L285:
	movq 24(%rbx),%rsi
	movq 32(%rsi),%rsi
	cmpq $0,%rsi
	jnz L271
L282:
	movl (%rbx),%esi
L594:
	cmpl $1073741828,%esi
	jz L312
L595:
	cmpl $1082130439,%esi
	jz L297
L596:
	cmpl $1082130441,%esi
	jnz L271
L308:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	notq %rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_unary
	jmp L268
L297:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L301
L300:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	mulsd L640(%rip),%xmm0
	movq 24(%rbx),%rsi
	movsd %xmm0,24(%rsi)
	jmp L302
L301:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	negq %rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L302:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_unary
	jmp L268
L312:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rcx
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rdx
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
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
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L271
L317:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L314
L321:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jnz L271
L314:
	movl (%rbx),%esi
	andl $536870912,%esi
	cmpl $0,%esi
	jz L327
L328:
	movq 24(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L327
L332:
	movq 24(%rbx),%rsi
	movq 32(%rsi),%rsi
	cmpq $0,%rsi
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
L598:
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
L602:
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
	movl $0,%esi
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
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L364
L369:
	movq 32(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L364
L365:
	movq 32(%rbx),%rsi
	movq 32(%rsi),%rsi
	movq 24(%rbx),%rdi
	movq 32(%rdi),%rdi
	cmpq %rdi,%rsi
	jnz L364
L362:
	movq 32(%rbx),%rsi
	movq $0,32(%rsi)
	movq 24(%rbx),%rsi
	movq $0,32(%rsi)
L364:
	movq 32(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L271
L380:
	movq 32(%rbx),%rsi
	movq 32(%rsi),%rsi
	cmpq $0,%rsi
	jnz L271
L377:
	movq 24(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L386
L384:
	movl (%rbx),%esi
L606:
	cmpl $276825113,%esi
	jz L409
L607:
	cmpl $813695768,%esi
	jnz L386
L395:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L399
L398:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	addsd %xmm0,%xmm1
	movq 24(%rbx),%rsi
	movsd %xmm1,24(%rsi)
	jmp L400
L399:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L402
L401:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	leaq (%rsi,%rdi),%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L400
L402:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	leaq (%rsi,%rdi),%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L400:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L409:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L413
L412:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	subsd %xmm0,%xmm1
	movq 24(%rbx),%rsi
	movsd %xmm1,24(%rsi)
	jmp L414
L413:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L416
L415:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	subq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L414
L416:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	subq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L414:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L386:
	movq 24(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $2147483649,%esi
	jnz L271
L422:
	movq 24(%rbx),%rsi
	movq 32(%rsi),%rsi
	cmpq $0,%rsi
	jnz L271
L419:
	movl (%rbx),%esi
L609:
	cmpl $134219294,%esi
	jz L479
	jb L610
L625:
	cmpl $545261604,%esi
	jz L512
	jb L626
L633:
	cmpl $637534243,%esi
	jz L539
	ja L271
L634:
	cmpl $637534242,%esi
	jnz L271
L531:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L535
L534:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setz %sil
	movzbl %sil,%r12d
	jmp L536
L535:
	movq 24(%rbx),%rsi
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
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L543
L542:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setnz %sil
	movzbl %sil,%r12d
	jmp L544
L543:
	movq 24(%rbx),%rsi
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
	cmpl $545260055,%esi
	jz L465
	jb L627
L630:
	cmpl $545261344,%esi
	jnz L271
L501:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L505
L504:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	andq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L506
L505:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	andq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L506:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L627:
	cmpl $545259541,%esi
	jnz L271
L523:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L527
L526:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	xorq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L528
L527:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	xorq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L528:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L465:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L469
L468:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	mulsd %xmm0,%xmm1
	movq 24(%rbx),%rsi
	movsd %xmm1,24(%rsi)
	jmp L470
L469:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L472
L471:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	imulq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L470
L472:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	imulq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L470:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L512:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L516
L515:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	orq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L517
L516:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	orq %rdi,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L517:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L610:
	cmpl $33554460,%esi
	jz L558
	jb L611
L618:
	cmpl $33554463,%esi
	jz L580
	jb L619
L622:
	cmpl $134219035,%esi
	jnz L271
L490:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L494
L493:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rcx
	sarq %cl,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L495
L494:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rcx
	shrq %cl,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L495:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
	movq 8(%rbx),%rdi
	movq (%rdi),%rdi
	call _con_normalize
	movq %rbx,%rdi
	call _tree_chop_binary
	jmp L268
L619:
	cmpl $33554461,%esi
	jnz L271
L569:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L573
L572:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setb %sil
	movzbl %sil,%r12d
	jmp L574
L573:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L576
L575:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setl %sil
	movzbl %sil,%r12d
	jmp L574
L576:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
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
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L584
L583:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setbe %sil
	movzbl %sil,%r12d
	jmp L585
L584:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L587
L586:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setle %sil
	movzbl %sil,%r12d
	jmp L585
L587:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
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
	cmpl $2342,%esi
	jz L447
	jb L612
L615:
	cmpl $33554458,%esi
	jnz L271
L547:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L551
L550:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	seta %sil
	movzbl %sil,%r12d
	jmp L552
L551:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L554
L553:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setg %sil
	movzbl %sil,%r12d
	jmp L552
L554:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
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
	cmpl $278,%esi
	jnz L271
L430:
	movq 32(%rbx),%rdi
	call _tree_zero
	cmpl $0,%eax
	jnz L433
L437:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L441
L440:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	divsd %xmm0,%xmm1
	movq 24(%rbx),%rsi
	movsd %xmm1,24(%rsi)
	jmp L442
L441:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L444
L443:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rsi
	movq 24(%rsi),%rsi
	cqto
	idivq %rsi
	movq 24(%rbx),%rsi
	movq %rax,24(%rsi)
	jmp L442
L444:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rsi
	movq 24(%rsi),%rsi
	xorl %edx,%edx
	divq %rsi
	movq 24(%rbx),%rsi
	movq %rax,24(%rsi)
L442:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
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
	andq $340,%rsi
	cmpq $0,%rsi
	jz L458
L457:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rsi
	movq 24(%rsi),%rsi
	cqto
	idivq %rsi
	movq 24(%rbx),%rsi
	movq %rdx,24(%rsi)
	jmp L459
L458:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rax
	movq 32(%rbx),%rsi
	movq 24(%rsi),%rsi
	xorl %edx,%edx
	divq %rsi
	movq 24(%rbx),%rsi
	movq %rdx,24(%rsi)
L459:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
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
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $7168,%rsi
	cmpq $0,%rsi
	jz L562
L561:
	movq 24(%rbx),%rsi
	movsd 24(%rsi),%xmm0
	movq 32(%rbx),%rsi
	movsd 24(%rsi),%xmm1
	ucomisd %xmm1,%xmm0
	setae %sil
	movzbl %sil,%r12d
	jmp L563
L562:
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L565
L564:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
	setge %sil
	movzbl %sil,%r12d
	jmp L563
L565:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rdi
	cmpq %rdi,%rsi
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
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L483
L482:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rcx
	shlq %cl,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
	jmp L484
L483:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 32(%rbx),%rdi
	movq 24(%rdi),%rcx
	shlq %cl,%rsi
	movq 24(%rbx),%rdi
	movq %rsi,24(%rdi)
L484:
	movq 24(%rbx),%rsi
	leaq 24(%rsi),%rsi
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
L645:
	leaq -16(%rbp),%rdi
	movl $16,%ecx
	xorl %eax,%eax
	rep
	stosb
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L649
L651:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jz L649
L648:
	movq 24(%rbx),%rdi
	call _tree_simplify
	movq %rax,24(%rbx)
L655:
	movq 32(%rbx),%rsi
	movq %rsi,%rdi
	cmpq $0,%rsi
	jz L667
L658:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L662
L661:
	movq 56(%rdi),%rsi
	movq 48(%rdi),%rax
	movq %rsi,56(%rax)
	jmp L663
L662:
	movq 56(%rdi),%rsi
	movq %rsi,40(%rbx)
L663:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_simplify
	movq $0,48(%rax)
	movq -8(%rbp),%rsi
	movq %rsi,56(%rax)
	movq -8(%rbp),%rsi
	movq %rax,(%rsi)
	leaq 48(%rax),%rsi
	movq %rsi,-8(%rbp)
	jmp L655
L667:
	movq -16(%rbp),%rsi
	cmpq $0,%rsi
	jz L646
L670:
	movq -16(%rbp),%rsi
	movq 40(%rbx),%rdi
	movq %rsi,(%rdi)
	movq 40(%rbx),%rsi
	movq -16(%rbp),%rdi
	movq %rsi,56(%rdi)
	movq -8(%rbp),%rsi
	movq %rsi,40(%rbx)
	movq $0,-16(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	jmp L646
L649:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L646
L679:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L676
L683:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
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
L693:
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
	andq $262144,%rsi
	cmpq $0,%rsi
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
	leaq -16(%rbp),%rdi
	movl $16,%ecx
	xorl %eax,%eax
	rep
	stosb
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L711
L713:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jz L711
L710:
	movq 24(%rbx),%rdi
	call _tree_rewrite_volatile
	movq %rax,24(%rbx)
L717:
	movq 32(%rbx),%rsi
	movq %rsi,%rdi
	cmpq $0,%rsi
	jz L729
L720:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L724
L723:
	movq 56(%rdi),%rsi
	movq 48(%rdi),%rax
	movq %rsi,56(%rax)
	jmp L725
L724:
	movq 56(%rdi),%rsi
	movq %rsi,40(%rbx)
L725:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_rewrite_volatile
	movq $0,48(%rax)
	movq -8(%rbp),%rsi
	movq %rsi,56(%rax)
	movq -8(%rbp),%rsi
	movq %rax,(%rsi)
	leaq 48(%rax),%rsi
	movq %rsi,-8(%rbp)
	jmp L717
L729:
	movq -16(%rbp),%rsi
	cmpq $0,%rsi
	jz L708
L732:
	movq -16(%rbp),%rsi
	movq 40(%rbx),%rdi
	movq %rsi,(%rdi)
	movq 40(%rbx),%rsi
	movq -16(%rbp),%rdi
	movq %rsi,56(%rdi)
	movq -8(%rbp),%rsi
	movq %rsi,40(%rbx)
	movq $0,-16(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	jmp L708
L711:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L708
L741:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L738
L745:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
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
L757:
	leaq -16(%rbp),%rdi
	movl $16,%ecx
	xorl %eax,%eax
	rep
	stosb
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L761
L763:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jz L761
L760:
	movq 24(%rbx),%rdi
	call _tree_opt
	movq %rax,24(%rbx)
L767:
	movq 32(%rbx),%rsi
	movq %rsi,%rdi
	cmpq $0,%rsi
	jz L779
L770:
	movq 48(%rdi),%rsi
	cmpq $0,%rsi
	jz L774
L773:
	movq 56(%rdi),%rsi
	movq 48(%rdi),%rax
	movq %rsi,56(%rax)
	jmp L775
L774:
	movq 56(%rdi),%rsi
	movq %rsi,40(%rbx)
L775:
	movq 48(%rdi),%rsi
	movq 56(%rdi),%rax
	movq %rsi,(%rax)
	call _tree_opt
	movq $0,48(%rax)
	movq -8(%rbp),%rsi
	movq %rsi,56(%rax)
	movq -8(%rbp),%rsi
	movq %rax,(%rsi)
	leaq 48(%rax),%rsi
	movq %rsi,-8(%rbp)
	jmp L767
L779:
	movq -16(%rbp),%rsi
	cmpq $0,%rsi
	jz L758
L782:
	movq -16(%rbp),%rsi
	movq 40(%rbx),%rdi
	movq %rsi,(%rdi)
	movq 40(%rbx),%rsi
	movq -16(%rbp),%rdi
	movq %rsi,56(%rdi)
	movq -8(%rbp),%rsi
	movq %rsi,40(%rbx)
	movq $0,-16(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	jmp L758
L761:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L758
L791:
	movl (%rbx),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L788
L795:
	movl (%rbx),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
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
	call _cast_opt
	movq %rax,%rbx
L801:
	movq %rbx,%rax
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
L853:
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
	movl $0,%r12d
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
L904:
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
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L882
L884:
	movl (%r13),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
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
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L854
L895:
	movl (%r13),%esi
	andl $2147483648,%esi
	cmpl $0,%esi
	jnz L892
L899:
	movl (%r13),%esi
	andl $1073741824,%esi
	cmpl $0,%esi
	jnz L854
L892:
	leal 1(%rbx),%esi
	movq 24(%r13),%rdi
	call _tree_debug
	leal 1(%rbx),%esi
	movq 32(%r13),%rdi
	call _tree_debug
	jmp L854
L871:
	leaq 24(%r13),%rsi
	movq 8(%r13),%rdi
	movq (%rdi),%rax
	subq $8,%rsp
	movq %rsp,%rdi
	movl $8,%ecx
	rep
	movsb
	pushq %rax
	pushq $L872
	call _output
	addq $24,%rsp
L873:
	movq 32(%r13),%rsi
	cmpq $0,%rsi
	jz L876
L874:
	movq 32(%r13),%rsi
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
.globl _cast_opt
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

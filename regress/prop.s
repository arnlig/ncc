.data
.align 8
_all_defs:
	.int 0
	.space 4, 0
	.quad 0
	.quad _all_defs+8
.text
_map_compar:
L5:
	pushq %rbp
	movq %rsp,%rbp
L6:
	movl (%rdi),%eax
	movl (%rsi),%esi
	subl %esi,%eax
L7:
	popq %rbp
	ret
L12:
_map_index:
L14:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L23:
	movl %edi,-8(%rbp)
	movl _all_defs(%rip),%esi
	movl %esi,%edx
	leaq -8(%rbp),%rdi
	movq _map(%rip),%rsi
	movl $4,%ecx
	movq $_map_compar,%r8
	call _bsearch
	cmpq $0,%rax
	jz L18
L17:
	subq _map(%rip),%rax
	movl $4,%esi
	cqto
	idivq %rsi
	jmp L16
L18:
	movl $-1,%eax
L16:
	movq %rbp,%rsp
	popq %rbp
	ret
L25:
_conps_new:
L27:
	pushq %rbp
	movq %rsp,%rbp
L28:
	movl _all_defs(%rip),%esi
	movl %esi,%edi
	shlq $4,%rdi
	call _safe_malloc
L29:
	popq %rbp
	ret
L34:
_conps_reset:
L36:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L47:
	movq %rdi,%r12
	xorl %ebx,%ebx
L39:
	movl _all_defs(%rip),%esi
	cmpl %esi,%ebx
	jae L38
L40:
	movslq %ebx,%rsi
	shlq $4,%rsi
	movq 8(%r12,%rsi),%rdi
	cmpq $0,%rdi
	jz L45
L43:
	call _operand_free
L45:
	movslq %ebx,%rsi
	shlq $4,%rsi
	movl $0,(%r12,%rsi)
	movq $0,8(%r12,%rsi)
	addl $1,%ebx
	jmp L39
L38:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L49:
_conp_set:
L51:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L58:
	movl %esi,%r12d
	movq %rdi,%rbx
	movq %rdx,%r13
	movq 8(%rbx),%rdi
	cmpq $0,%rdi
	jz L56
L54:
	call _operand_free
	movq $0,8(%rbx)
L56:
	movl %r12d,(%rbx)
	movq %r13,8(%rbx)
L53:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L60:
_conps_set:
L62:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L66:
	movl %edx,%r12d
	movq %rdi,%r13
	movq %rcx,%rbx
	movl %esi,%edi
	call _map_index
	movslq %eax,%rsi
	shlq $4,%rsi
	leaq (%r13,%rsi),%rdi
	movl %r12d,%esi
	movq %rbx,%rdx
	call _conp_set
L64:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L68:
_conps_merge:
L70:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L106:
	movq %rdi,%r12
	movl %edx,%r15d
	movq %rsi,%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movl $1,-16(%rbp)
	movq %rcx,-8(%rbp)
	xorl %r13d,%r13d
L73:
	movl _all_defs(%rip),%esi
	cmpl %esi,%r13d
	jae L72
L74:
	movslq %r13d,%rsi
	movq _map(%rip),%rdi
	movl (%rdi,%rsi,4),%esi
	cmpl %r15d,%esi
	jnz L79
L77:
	movq %rbx,%r14
	leaq -16(%rbp),%rbx
L79:
	movl (%r12),%edi
	cmpl $2,%edi
	jz L82
L80:
	movl (%rbx),%esi
	cmpl $0,%esi
	jz L82
L103:
	cmpl $1,%esi
	jz L91
L104:
	cmpl $2,%esi
	jnz L82
L89:
	movq %r12,%rdi
	movl $2,%esi
	xorl %edx,%edx
	call _conp_set
	jmp L82
L91:
	cmpl $1,%edi
	jnz L93
L92:
	movq 8(%rbx),%rsi
	movq 8(%r12),%rdi
	call _operand_is_same
	cmpl $0,%eax
	jnz L82
L95:
	movq %r12,%rdi
	movl $2,%esi
	xorl %edx,%edx
	call _conp_set
	jmp L82
L93:
	movq 8(%rbx),%rdi
	call _operand_dup
	movq %r12,%rdi
	movl $1,%esi
	movq %rax,%rdx
	call _conp_set
L82:
	movslq %r13d,%rsi
	movq _map(%rip),%rdi
	movl (%rdi,%rsi,4),%esi
	cmpl %r15d,%esi
	jnz L75
L98:
	movq %r14,%rbx
L75:
	addl $1,%r13d
	addq $16,%r12
	addq $16,%rbx
	jmp L73
L72:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L108:
_conps_merge_gen:
L110:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L121:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L113:
	movl _all_defs(%rip),%esi
	cmpl %esi,%ebx
	jae L112
L114:
	movl (%r12),%esi
	cmpl $1,%esi
	jnz L115
L117:
	movq 8(%r12),%rdi
	call _operand_dup
	movq %r13,%rdi
	movl $1,%esi
	movq %rax,%rdx
	call _conp_set
L115:
	addl $1,%ebx
	addq $16,%r12
	addq $16,%r13
	jmp L113
L112:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L123:
_conps_kill:
L125:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L133:
	movq %rdi,%r12
	movq 8(%rsi),%rbx
L128:
	cmpq $0,%rbx
	jz L127
L129:
	movl (%rbx),%esi
	movq %r12,%rdi
	movl $2,%edx
	xorl %ecx,%ecx
	call _conps_set
	movq 8(%rbx),%rbx
	jmp L128
L127:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L135:
_conps_value:
L137:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L150:
	movq %rdi,%rbx
	movl %esi,%edi
	call _map_index
	cmpl $-1,%eax
	jz L140
L143:
	movslq %eax,%rsi
	shlq $4,%rsi
	movl (%rbx,%rsi),%edi
	cmpl $1,%edi
	jz L142
L140:
	xorl %eax,%eax
	jmp L139
L142:
	movq 8(%rbx,%rsi),%rax
L139:
	popq %rbx
	popq %rbp
	ret
L152:
_conps_same:
L154:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L175:
	movq %rdi,%r12
	movq %rsi,%r13
	xorl %ebx,%ebx
L157:
	movl _all_defs(%rip),%esi
	cmpl %esi,%ebx
	jae L160
L158:
	movl (%r12),%esi
	movl (%r13),%edi
	cmpl %edi,%esi
	jz L163
L161:
	xorl %eax,%eax
	jmp L156
L163:
	cmpl $1,%esi
	jnz L159
L168:
	movq 8(%r13),%rsi
	movq 8(%r12),%rdi
	call _operand_is_same
	cmpl $0,%eax
	jnz L159
L165:
	xorl %eax,%eax
	jmp L156
L159:
	addl $1,%ebx
	addq $16,%r12
	addq $16,%r13
	jmp L157
L160:
	movl $1,%eax
L156:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L177:
_conps_dup:
L179:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L190:
	movq %rsi,%r12
	movq %rdi,%r13
	xorl %ebx,%ebx
L182:
	movl _all_defs(%rip),%esi
	cmpl %esi,%ebx
	jae L181
L183:
	movl (%r12),%esi
	cmpl $1,%esi
	jnz L187
L186:
	movq 8(%r12),%rdi
	call _operand_dup
	movq %r13,%rdi
	movl $1,%esi
	movq %rax,%rdx
	call _conp_set
	jmp L184
L187:
	movq %r13,%rdi
	xorl %edx,%edx
	call _conp_set
L184:
	addl $1,%ebx
	addq $16,%r13
	addq $16,%r12
	jmp L182
L181:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L192:
_conps_poison:
L194:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L202:
	movq %rdi,%r12
	xorl %ebx,%ebx
L197:
	movl _all_defs(%rip),%esi
	cmpl %esi,%ebx
	jae L196
L198:
	movq %r12,%rdi
	movl $2,%esi
	xorl %edx,%edx
	call _conp_set
	addl $1,%ebx
	addq $16,%r12
	jmp L197
L196:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L204:
_conps_free:
L206:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L210:
	movq %rdi,%rbx
	movq %rbx,%rdi
	call _conps_reset
	movq %rbx,%rdi
	call _free
L208:
	popq %rbx
	popq %rbp
	ret
L212:
_all0:
L214:
	pushq %rbp
	movq %rsp,%rbp
L215:
	leaq 168(%rdi),%rsi
	movq $_all_defs,%rdi
	call _regs_union
	xorl %eax,%eax
L216:
	popq %rbp
	ret
L221:
_init0:
L223:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L227:
	movq %rdi,%rbx
	call _conps_new
	movq %rax,192(%rbx)
	call _conps_new
	movq %rax,200(%rbx)
	call _conps_new
	movq %rax,208(%rbx)
	call _conps_new
	movq %rax,216(%rbx)
L225:
	popq %rbx
	popq %rbp
	ret
L229:
_init:
L231:
	pushq %rbp
	movq %rsp,%rbp
L232:
	movq $_all0,%rdi
	call _blocks_iter
	movl _all_defs(%rip),%esi
	movl %esi,%esi
	leaq (,%rsi,4),%rdi
	call _safe_malloc
	movq %rax,_map(%rip)
	xorl %esi,%esi
	movq _all_defs+8(%rip),%rdi
L234:
	cmpq $0,%rdi
	jz L237
L235:
	movl (%rdi),%eax
	movl %esi,%ecx
	addl $1,%esi
	movslq %ecx,%rcx
	movq _map(%rip),%rdx
	movl %eax,(%rdx,%rcx,4)
	movq 8(%rdi),%rdi
	jmp L234
L237:
	movq $_init0,%rdi
	call _blocks_iter
	movq _entry_block(%rip),%rsi
	movq 208(%rsi),%rdi
	call _conps_poison
L233:
	popq %rbp
	ret
L241:
_local:
L243:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L270:
	movq %rsi,%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq 8(%rdi),%r13
L246:
	cmpq $0,%r13
	jz L245
L247:
	leaq -32(%rbp),%rsi
	movq %r13,%rdi
	call _insn_con
	cmpq $0,%rax
	jz L252
L250:
	movl -32(%rbp),%esi
	movq %rbx,%rdi
	movl $1,%edx
	movq %rax,%rcx
	call _conps_set
	jmp L248
L252:
	leaq -24(%rbp),%rsi
	movq %r13,%rdi
	call _insn_uses_regs
	movq -16(%rbp),%r12
L254:
	cmpq $0,%r12
	jz L257
L255:
	movl (%r12),%esi
	movq %rbx,%rdi
	call _conps_value
	cmpq $0,%rax
	jz L256
L261:
	movl (%r12),%esi
	movq %r13,%rdi
	movq %rax,%rdx
	call _insn_substitute_con
	cmpl $0,%eax
	jz L256
L258:
	movl $1,_changed(%rip)
L256:
	movq 8(%r12),%r12
	jmp L254
L257:
	leaq -24(%rbp),%r12
	movq %r12,%rdi
	call _regs_clear
	movq %r13,%rdi
	movq %r12,%rsi
	call _insn_defs_regs
	movq -16(%rbp),%r12
L265:
	cmpq $0,%r12
	jz L268
L266:
	movl (%r12),%esi
	movq %rbx,%rdi
	movl $2,%edx
	xorl %ecx,%ecx
	call _conps_set
	movq 8(%r12),%r12
	jmp L265
L268:
	leaq -24(%rbp),%rdi
	call _regs_clear
L248:
	movq 40(%r13),%r13
	jmp L246
L245:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L272:
_gen0:
L274:
	pushq %rbp
	movq %rsp,%rbp
L275:
	movq 200(%rdi),%rsi
	call _local
	xorl %eax,%eax
L276:
	popq %rbp
	ret
L281:
_conditional:
L283:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L330:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	movl $2147483649,(%rbx)
	movq %r12,%rdi
	xorl %esi,%esi
	call _block_cc_successor
	cmpq $0,%rax
	jz L286
L289:
	cmpq 8(%rax),%r13
	jz L288
L286:
	xorl %eax,%eax
	jmp L285
L288:
	movq 16(%r12),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	cmpq $0,%rsi
	jz L294
L297:
	movl (%rsi),%edi
	cmpl $872415247,%edi
	jz L296
L294:
	xorl %eax,%eax
	jmp L285
L296:
	movq 24(%rsi),%rax
	movq 32(%rsi),%rdi
	movq %rdi,%rsi
	cmpq $0,%rdi
	jz L304
L305:
	movl (%rdi),%edi
	cmpl $1,%edi
	jnz L304
L309:
	movq %rax,%rdi
	movq %rsi,%rax
	movq %rdi,%rsi
L304:
	cmpq $0,%rsi
	jz L314
L315:
	movl (%rsi),%edi
	cmpl $1,%edi
	jnz L314
L312:
	xorl %eax,%eax
	jmp L285
L314:
	cmpq $0,%rax
	jz L320
L323:
	movl (%rax),%edi
	cmpl $1,%edi
	jnz L320
L322:
	movl 24(%rsi),%esi
	movl %esi,(%rbx)
	jmp L285
L320:
	xorl %eax,%eax
L285:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L332:
_prop0:
L334:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L351:
	movq %rdi,%rbx
	cmpq %rbx,_entry_block(%rip)
	jnz L339
L337:
	xorl %eax,%eax
	jmp L336
L339:
	movq 192(%rbx),%rdi
	call _conps_reset
	movq 480(%rbx),%r12
L341:
	cmpq $0,%r12
	jz L344
L342:
	leaq -8(%rbp),%rdx
	movq 8(%r12),%rsi
	movq %rbx,%rdi
	call _conditional
	movq 8(%r12),%rsi
	movq 208(%rsi),%rsi
	movq 192(%rbx),%rdi
	movl -8(%rbp),%edx
	movq %rax,%rcx
	call _conps_merge
	movq 32(%r12),%r12
	jmp L341
L344:
	movq 192(%rbx),%rsi
	movq 216(%rbx),%rdi
	call _conps_dup
	leaq 168(%rbx),%rsi
	movq 216(%rbx),%rdi
	call _conps_kill
	movq 200(%rbx),%rsi
	movq 216(%rbx),%rdi
	call _conps_merge_gen
	movq 208(%rbx),%rsi
	movq 216(%rbx),%rdi
	call _conps_same
	cmpl $0,%eax
	jz L346
L345:
	xorl %eax,%eax
	jmp L336
L346:
	movq 216(%rbx),%rsi
	movq 208(%rbx),%rdi
	call _conps_dup
	movl $2,%eax
L336:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L353:
_rewrite0:
L355:
	pushq %rbp
	movq %rsp,%rbp
L356:
	movq 192(%rdi),%rsi
	call _local
	xorl %eax,%eax
L357:
	popq %rbp
	ret
L362:
_clear0:
L364:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L369:
	movq %rdi,%rbx
	movq 192(%rbx),%rdi
	call _conps_free
	movq 200(%rbx),%rdi
	call _conps_free
	movq 208(%rbx),%rdi
	call _conps_free
	movq 216(%rbx),%rdi
	call _conps_free
	xorl %eax,%eax
L366:
	popq %rbx
	popq %rbp
	ret
L371:
_clear:
L373:
	pushq %rbp
	movq %rsp,%rbp
L374:
	movq $_clear0,%rdi
	call _blocks_iter
	movq _map(%rip),%rdi
	call _free
	movq $_all_defs,%rdi
	call _regs_clear
L375:
	popq %rbp
	ret
L379:
_lookahead0:
L381:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L417:
	movq %rdi,%r14
	movq %r14,%rdi
	call _block_always_successor
	movq %rax,%r13
	cmpq $0,%r13
	jz L386
L403:
	movq 8(%r13),%rdi
	cmpq %rdi,%r14
	jz L386
L399:
	movl 24(%rdi),%esi
	addl $-2,%esi
	cmpl $1,%esi
	jnz L386
L395:
	leaq -8(%rbp),%rsi
	movq 8(%rdi),%rdi
	call _insn_test_con
	cmpl $0,%eax
	jz L386
L391:
	movq 208(%r14),%rdi
	movl -8(%rbp),%esi
	call _conps_value
	movq %rax,%rbx
	cmpq $0,%rbx
	jz L386
L387:
	cmpq $0,%rbx
	jz L386
L411:
	movl (%rbx),%esi
	cmpl $1,%esi
	jnz L386
L407:
	cmpq $0,32(%rbx)
	jnz L386
L384:
	movq 8(%r13),%rsi
	movq 8(%rsi),%rdi
	call _insn_dup
	movq %rax,%r12
	movl -8(%rbp),%esi
	movq %r12,%rdi
	movq %rbx,%rdx
	call _insn_substitute_con
	leaq 8(%r14),%rdi
	movq %r12,%rsi
	call _insn_append
	movq 8(%r13),%rsi
	movq %r14,%rdi
	call _block_dup_successors
	movl $1,_changed(%rip)
L386:
	xorl %eax,%eax
L383:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L419:
_switch0:
L421:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L447:
	movq %rdi,%rbx
	movq 328(%rbx),%rsi
	cmpq $0,%rsi
	jz L426
L424:
	movq %rsi,%rax
	cmpq $0,%rsi
	jz L429
L430:
	movl (%rsi),%edi
	cmpl $2,%edi
	jnz L429
L427:
	movl 24(%rsi),%esi
	movq 208(%rbx),%rdi
	call _conps_value
L429:
	cmpq $0,%rax
	jz L426
L441:
	movl (%rax),%esi
	cmpl $1,%esi
	jnz L426
L437:
	cmpq $0,32(%rax)
	jnz L426
L434:
	movq 24(%rax),%rsi
	movq %rbx,%rdi
	call _block_switch_lookup
	movq %rax,%r12
	movq %rbx,%rdi
	call _block_remove_successors
	movq %rbx,%rdi
	movl $10,%esi
	movq %r12,%rdx
	call _block_add_successor
	movl $1,_changed(%rip)
L426:
	xorl %eax,%eax
L423:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L449:
_prop:
L450:
	pushq %rbp
	movq %rsp,%rbp
L453:
	call _kill_analyze
	movl $0,_changed(%rip)
	call _init
	movq $_gen0,%rdi
	call _blocks_iter
	movq $_prop0,%rdi
	call _blocks_iter
	movq $_rewrite0,%rdi
	call _blocks_iter
	movq $_lookahead0,%rdi
	call _blocks_iter
	movq $_switch0,%rdi
	call _blocks_iter
	call _clear
	movl _changed(%rip),%esi
	cmpl $0,%esi
	jz L455
L456:
	call _fold
	call _algebra
	call _dead
	call _unreach
L455:
	movl _changed(%rip),%esi
	cmpl $0,%esi
	jnz L453
L452:
	popq %rbp
	ret
L462:
.local _map
.comm _map, 8, 8
.globl _block_switch_lookup
.globl _prop
.globl _insn_dup
.globl _operand_dup
.globl _algebra
.globl _blocks_iter
.globl _block_always_successor
.globl _block_cc_successor
.globl _block_add_successor
.globl _regs_clear
.globl _insn_uses_regs
.globl _insn_defs_regs
.globl _fold
.globl _insn_append
.globl _kill_analyze
.globl _block_dup_successors
.globl _block_remove_successors
.globl _safe_malloc
.local _changed
.comm _changed, 4, 4
.globl _dead
.globl _operand_free
.globl _operand_is_same
.globl _free
.globl _unreach
.globl _bsearch
.globl _entry_block
.globl _regs_union
.globl _insn_substitute_con
.globl _insn_con
.globl _insn_test_con

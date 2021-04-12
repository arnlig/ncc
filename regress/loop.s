.text
_loop_init:
L1:
	pushq %rbp
	movq %rsp,%rbp
L7:
	leaq 8(%rdi),%rsi
	movq $0,8(%rdi)
	movq %rsi,16(%rdi)
	movl $0,(%rdi)
	leaq 40(%rdi),%rsi
	movq $0,40(%rdi)
	movq %rsi,48(%rdi)
	movl $0,32(%rdi)
	movl $0,24(%rdi)
L3:
	popq %rbp
	ret
L19:
_loop_clear:
L20:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L24:
	movq %rdi,%rbx
	call _blks_clear
	movl $0,24(%rbx)
L22:
	popq %rbx
	popq %rbp
	ret
L26:
_bstack_push:
L28:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L35:
	movq %rsi,%r12
	movq %rdi,%rbx
	movl $16,%edi
	call _safe_malloc
	movq %r12,(%rax)
	movq (%rbx),%rsi
	movq %rsi,8(%rax)
	movq %rax,(%rbx)
L30:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L37:
_bstack_pop:
L39:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L47:
	movq %rdi,%rsi
	movq (%rsi),%rdi
	movq 8(%rdi),%rax
	movq %rax,(%rsi)
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rax
L41:
	popq %rbx
	popq %rbp
	ret
L49:
.data
.align 8
_bstack:
	.quad 0
.text
_loop_blocks:
L52:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L78:
	movq %rsi,%r15
	movq %rdi,%r12
	leaq -24(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq %rbx,%rdi
	movq %r15,%rsi
	movl $1,%edx
	call _blks_lookup
	cmpq %r15,%r12
	jz L57
L58:
	movq %rbx,%rdi
	movq %r12,%rsi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L64
L61:
	movq %rbx,%rdi
	movq %r12,%rsi
	movl $1,%edx
	call _blks_lookup
	movq $_bstack,%rdi
	movq %r12,%rsi
	call _bstack_push
L64:
	cmpq $0,_bstack(%rip)
	jz L57
L65:
	movq $_bstack,%rdi
	call _bstack_pop
	movq %rax,%r14
	xorl %r13d,%r13d
L67:
	movq %r14,%rdi
	movl %r13d,%esi
	call _block_get_predecessor_n
	movq %rax,%rbx
	cmpq $0,%rbx
	jz L64
L71:
	movq 8(%rbx),%rsi
	leaq -24(%rbp),%r12
	movq %r12,%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L69
L74:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	movl $1,%edx
	call _blks_lookup
	movq 8(%rbx),%rsi
	movq $_bstack,%rdi
	call _bstack_push
L69:
	addl $1,%r13d
	jmp L67
L57:
	leaq -24(%rbp),%rbx
	leaq 456(%r15),%rdi
	movq %rbx,%rsi
	call _blks_union
	movq %rbx,%rdi
	call _blks_clear
L54:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L80:
_loop0:
L82:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L87:
	movq %rdi,%rbx
	leaq 456(%rbx),%rdi
	call _blks_clear
	movl $0,480(%rbx)
	xorl %eax,%eax
L84:
	popq %rbx
	popq %rbp
	ret
L89:
_loop1:
L91:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L103:
	movq %rdi,%r12
	xorl %ebx,%ebx
L94:
	movq %r12,%rdi
	movl %ebx,%esi
	call _block_get_successor_n
	movq %rax,%r13
	cmpq $0,%r13
	jz L97
L95:
	movq 8(%r13),%rsi
	leaq 432(%r12),%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jz L96
L98:
	movq 8(%r13),%rsi
	movq %r12,%rdi
	call _loop_blocks
L96:
	addl $1,%ebx
	jmp L94
L97:
	xorl %eax,%eax
L93:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L105:
_loop2:
L107:
	pushq %rbp
	movq %rsp,%rbp
L108:
	movq 464(%rdi),%rsi
L110:
	cmpq $0,%rsi
	jz L113
L111:
	movq (%rsi),%rdi
	addl $1,480(%rdi)
	movq 8(%rsi),%rsi
	jmp L110
L113:
	xorl %eax,%eax
L109:
	popq %rbp
	ret
L118:
_loop_analyze:
L119:
	pushq %rbp
	movq %rsp,%rbp
L120:
	call _dom_analyze
	movq $_loop0,%rdi
	call _blocks_iter
	movq $_loop1,%rdi
	call _blocks_iter
	movq $_loop2,%rdi
	call _blocks_iter
L121:
	popq %rbp
	ret
L125:
_invariants0:
L128:
	pushq %rbp
	movq %rsp,%rbp
L129:
	andl $-3,4(%rdi)
	addq $488,%rdi
	call _regs_clear
	xorl %eax,%eax
L130:
	popq %rbp
	ret
L135:
_invariants1:
L137:
	pushq %rbp
	movq %rsp,%rbp
L138:
	movl 456(%rdi),%esi
	cmpl $0,%esi
	jz L142
L147:
	movq _head_b(%rip),%rax
	cmpq $0,%rax
	jz L143
L151:
	movl 480(%rdi),%esi
	movl 480(%rax),%eax
	cmpl %eax,%esi
	jle L142
L143:
	movl 4(%rdi),%esi
	testl $2,%esi
	jnz L142
L140:
	movq %rdi,_head_b(%rip)
L142:
	xorl %eax,%eax
L139:
	popq %rbp
	ret
L159:
_unique_def:
L161:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L191:
	movl %esi,%r15d
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	xorps %xmm0,%xmm0
	movups %xmm0,-48(%rbp)
	movq $0,-32(%rbp)
	leaq -40(%rbp),%rsi
	movq %rsi,-32(%rbp)
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movq 8(%rdi),%rbx
L164:
	cmpq $0,%rbx
	jz L167
L165:
	leaq -24(%rbp),%rsi
	movq %rbx,%rdi
	xorl %edx,%edx
	call _insn_defs_regs
	leaq -48(%rbp),%r12
	movq %rbx,%rdi
	movq %r12,%rsi
	xorl %edx,%edx
	call _insn_uses_regs
	movq %r12,%rdi
	movl %r15d,%esi
	xorl %edx,%edx
	call _regs_lookup
	cmpq $0,%rax
	jz L170
L171:
	cmpq $0,%r14
	jnz L170
L168:
	movl $1,%r13d
L170:
	leaq -24(%rbp),%rdi
	movl %r15d,%esi
	xorl %edx,%edx
	call _regs_lookup
	cmpq $0,%rax
	jz L177
L175:
	cmpq $0,%r14
	jz L179
L178:
	movl $1,%r13d
	jmp L177
L179:
	movq %rbx,%r14
L177:
	leaq -24(%rbp),%rdi
	call _regs_clear
	leaq -48(%rbp),%rdi
	call _regs_clear
	cmpl $0,%r13d
	jnz L167
L166:
	movq 64(%rbx),%rbx
	jmp L164
L167:
	cmpl $0,%r13d
	jz L186
L185:
	xorl %eax,%eax
	jmp L163
L186:
	movq %r14,%rax
L163:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L193:
_loop_move:
L195:
	pushq %rbp
	movq %rsp,%rbp
	subq $160,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L196:
	leaq -24(%rbp),%r13
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	leaq -48(%rbp),%r12
	xorps %xmm0,%xmm0
	movups %xmm0,-48(%rbp)
	movq $0,-32(%rbp)
	leaq -40(%rbp),%rsi
	movq %rsi,-32(%rbp)
	leaq -72(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-72(%rbp)
	movq $0,-56(%rbp)
	leaq -64(%rbp),%rsi
	movq %rsi,-56(%rbp)
	xorps %xmm0,%xmm0
	movups %xmm0,-96(%rbp)
	movq $0,-80(%rbp)
	leaq -88(%rbp),%rsi
	movq %rsi,-80(%rbp)
	xorps %xmm0,%xmm0
	movups %xmm0,-120(%rbp)
	movq $0,-104(%rbp)
	leaq -112(%rbp),%rsi
	movq %rsi,-104(%rbp)
	xorps %xmm0,%xmm0
	movups %xmm0,-144(%rbp)
	movq $0,-128(%rbp)
	leaq -136(%rbp),%rsi
	movq %rsi,-128(%rbp)
	movl $0,-152(%rbp)	 # spill
	movq _head_b(%rip),%rdi
	call _live_analyze_ccs
	movq %r13,%rdi
	call _blks_all
	movq %r13,%rdi
	xorl %esi,%esi
	movq %rbx,%rdx
	call _kill_gather
	movq %r12,%rdi
	call _blks_all
	movq _head_b(%rip),%rsi
	addq $456,%rsi
	movq %r12,%rdi
	call _blks_diff
	movq -64(%rbp),%rbx
L198:
	cmpq $0,%rbx
	jz L200
L199:
	movq 8(%rbx),%r13
	leaq -144(%rbp),%r12
	leaq -96(%rbp),%rax
	leaq -48(%rbp),%rsi
	movl (%rbx),%edi
	movq %rax,%rdx
	movq %r12,%rcx
	call _kill_gather_blks
	leaq -120(%rbp),%rax
	movq _head_b(%rip),%rsi
	movl (%rbx),%edi
	addq $456,%rsi
	movq %rax,%rdx
	movq %r12,%rcx
	call _kill_gather_blks
	movl -120(%rbp),%esi
	cmpl $0,%esi
	jz L203
L204:
	movl -96(%rbp),%esi
	cmpl $0,%esi
	jnz L208
L203:
	movl -120(%rbp),%esi
	cmpl $0,%esi
	jnz L212
L210:
	movl (%rbx),%esi
	movq _head_b(%rip),%rdi
	addq $488,%rdi
	movl $1,%edx
	call _regs_lookup
	jmp L208
L212:
	cmpl $1,%esi
	ja L208
L216:
	movq -112(%rbp),%r12
	movl (%rbx),%esi
	movq (%r12),%rdi
	call _unique_def
	movq %rax,%rsi
	cmpq $0,%rsi
	jz L208
L221:
	leaq -144(%rbp),%rsi
	movq (%r12),%rdi
	call _dominates_all
	movl %eax,%esi
	cmpl $0,%esi
	jnz L226
L208:
	movl (%rbx),%esi
	leaq -72(%rbp),%rdi
	call _regs_remove
L226:
	leaq -96(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	leaq -120(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	leaq -144(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	movq %r13,%rbx
	jmp L198
L200:
	xorl %r13d,%r13d
L228:
	movl $0,-160(%rbp)	 # spill
	movq -64(%rbp),%rbx
L231:
	cmpq $0,%rbx
	jz L230
L232:
	movq 8(%rbx),%r15
	leaq -120(%rbp),%rax
	movq _head_b(%rip),%rsi
	movl (%rbx),%edi
	addq $456,%rsi
	movq %rax,%rdx
	xorl %ecx,%ecx
	call _kill_gather_blks
	movq -112(%rbp),%r14
	movl (%rbx),%esi
	movq (%r14),%rdi
	call _unique_def
	movq %rax,%r12
	movq _head_b(%rip),%rsi
	addq $488,%rsi
	movq %r12,%rdi
	call _insn_movable
	movl %eax,%esi
	cmpl $0,%esi
	jz L236
L234:
	cmpq $0,%r13
	jnz L239
L237:
	movq _head_b(%rip),%rdi
	leaq 456(%rdi),%rsi
	call _block_preheader
	movq %rax,%rsi
	movq %rsi,%r13
	movl $1,-152(%rbp)	 # spill
L239:
	movq %r12,%rdi
	call _insn_dup
	movq %rax,%rsi
	leaq 8(%r13),%rdi
	call _insn_append
	movq (%r14),%rsi
	addq $8,%rsi
	movq %rsi,%rdi
	movq %r12,%rsi
	call _insns_remove
	movl (%rbx),%esi
	leaq -72(%rbp),%rdi
	call _regs_remove
	movl (%rbx),%esi
	movq _head_b(%rip),%rdi
	addq $488,%rdi
	movl $1,%edx
	call _regs_lookup
	movl $1,-160(%rbp)	 # spill
L236:
	leaq -120(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	movq %r15,%rbx
	jmp L231
L230:
	cmpl $0,-160(%rbp)	 # spill
	jnz L228
L229:
	leaq -72(%rbp),%rsi
	movq %rsi,%rdi
	call _regs_clear
	leaq -24(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	leaq -48(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	movl -152(%rbp),%eax	 # spill
L197:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L244:
_loop_invariants:
L245:
	pushq %rbp
	movq %rsp,%rbp
L246:
	call _webs_analyze
	movq $_invariants0,%rdi
	call _blocks_iter
L252:
	call _kill_analyze
	call _loop_analyze
L254:
	movq $0,_head_b(%rip)
	movq $_invariants1,%rdi
	call _blocks_iter
	movq _head_b(%rip),%rsi
	cmpq $0,%rsi
	jnz L256
L251:
	call _webs_strip
L247:
	popq %rbp
	ret
L256:
	orl $2,4(%rsi)
	call _loop_move
	cmpl $0,%eax
	jz L254
	jnz L252
L262:
.globl _blks_lookup
.globl _webs_strip
.globl _regs_lookup
.globl _insn_dup
.globl _blocks_iter
.globl _block_preheader
.globl _loop_clear
.globl _blks_clear
.globl _kill_gather
.globl _regs_clear
.globl _kill_gather_blks
.globl _live_analyze_ccs
.globl _insn_uses_regs
.globl _insn_defs_regs
.globl _loop_init
.globl _insn_append
.globl _dom_analyze
.globl _loop_analyze
.globl _kill_analyze
.globl _webs_analyze
.globl _regs_remove
.globl _insn_movable
.globl _insns_remove
.globl _blks_diff
.globl _dominates_all
.globl _blks_all
.local _head_b
.comm _head_b, 8, 8
.globl _loop_invariants
.globl _safe_malloc
.globl _free
.globl _block_get_predecessor_n
.globl _block_get_successor_n
.globl _blks_union

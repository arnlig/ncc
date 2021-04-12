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
	movl $0,24(%rdi)
L3:
	popq %rbp
	ret
L13:
_loop_clear:
L14:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L18:
	movq %rdi,%rbx
	call _blks_clear
	movl $0,24(%rbx)
L16:
	popq %rbx
	popq %rbp
	ret
L20:
_bstack_push:
L22:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L29:
	movq %rsi,%r12
	movq %rdi,%rbx
	movl $16,%edi
	call _safe_malloc
	movq %r12,(%rax)
	movq (%rbx),%rsi
	movq %rsi,8(%rax)
	movq %rax,(%rbx)
L24:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L31:
_bstack_pop:
L33:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L41:
	movq %rdi,%rsi
	movq (%rsi),%rdi
	movq 8(%rdi),%rax
	movq %rax,(%rsi)
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rax
L35:
	popq %rbx
	popq %rbp
	ret
L43:
.data
.align 8
_bstack:
	.quad 0
.text
_loop_blocks:
L46:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L72:
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
	jz L51
L52:
	movq %rbx,%rdi
	movq %r12,%rsi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L58
L55:
	movq %rbx,%rdi
	movq %r12,%rsi
	movl $1,%edx
	call _blks_lookup
	movq $_bstack,%rdi
	movq %r12,%rsi
	call _bstack_push
L58:
	cmpq $0,_bstack(%rip)
	jz L51
L59:
	movq $_bstack,%rdi
	call _bstack_pop
	movq %rax,%r14
	xorl %r13d,%r13d
L61:
	movq %r14,%rdi
	movl %r13d,%esi
	call _block_get_predecessor_n
	movq %rax,%rbx
	cmpq $0,%rbx
	jz L58
L65:
	movq 8(%rbx),%rsi
	leaq -24(%rbp),%r12
	movq %r12,%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jnz L63
L68:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	movl $1,%edx
	call _blks_lookup
	movq 8(%rbx),%rsi
	movq $_bstack,%rdi
	call _bstack_push
L63:
	addl $1,%r13d
	jmp L61
L51:
	leaq -24(%rbp),%rbx
	leaq 456(%r15),%rdi
	movq %rbx,%rsi
	call _blks_union
	movq %rbx,%rdi
	call _blks_clear
L48:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L74:
_loop0:
L76:
	pushq %rbp
	movq %rsp,%rbp
L77:
	addq $456,%rdi
	call _loop_clear
	xorl %eax,%eax
L78:
	popq %rbp
	ret
L83:
_loop1:
L85:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L97:
	movq %rdi,%r12
	xorl %ebx,%ebx
L88:
	movq %r12,%rdi
	movl %ebx,%esi
	call _block_get_successor_n
	movq %rax,%r13
	cmpq $0,%r13
	jz L91
L89:
	movq 8(%r13),%rsi
	leaq 432(%r12),%rdi
	xorl %edx,%edx
	call _blks_lookup
	cmpq $0,%rax
	jz L90
L92:
	movq 8(%r13),%rsi
	movq %r12,%rdi
	call _loop_blocks
L90:
	addl $1,%ebx
	jmp L88
L91:
	xorl %eax,%eax
L87:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L99:
_loop2:
L101:
	pushq %rbp
	movq %rsp,%rbp
L102:
	movq 464(%rdi),%rsi
L104:
	cmpq $0,%rsi
	jz L107
L105:
	movq (%rsi),%rdi
	addl $1,480(%rdi)
	movq 8(%rsi),%rsi
	jmp L104
L107:
	xorl %eax,%eax
L103:
	popq %rbp
	ret
L112:
_loop_analyze:
L113:
	pushq %rbp
	movq %rsp,%rbp
L114:
	call _dom_analyze
	movq $_loop0,%rdi
	call _blocks_iter
	movq $_loop1,%rdi
	call _blocks_iter
	movq $_loop2,%rdi
	call _blocks_iter
L115:
	popq %rbp
	ret
L119:
_invariants0:
L122:
	pushq %rbp
	movq %rsp,%rbp
L123:
	andl $-3,4(%rdi)
	xorl %eax,%eax
L124:
	popq %rbp
	ret
L129:
_invariants1:
L131:
	pushq %rbp
	movq %rsp,%rbp
L132:
	movl 456(%rdi),%esi
	cmpl $0,%esi
	jz L136
L141:
	movq _head_b(%rip),%rax
	cmpq $0,%rax
	jz L137
L145:
	movl 480(%rdi),%esi
	movl 480(%rax),%eax
	cmpl %eax,%esi
	jle L136
L137:
	movl 4(%rdi),%esi
	testl $2,%esi
	jnz L136
L134:
	movq %rdi,_head_b(%rip)
L136:
	xorl %eax,%eax
L133:
	popq %rbp
	ret
L153:
_unique_def:
L155:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L185:
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
L158:
	cmpq $0,%rbx
	jz L161
L159:
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
	jz L164
L165:
	cmpq $0,%r14
	jnz L164
L162:
	movl $1,%r13d
L164:
	leaq -24(%rbp),%rdi
	movl %r15d,%esi
	xorl %edx,%edx
	call _regs_lookup
	cmpq $0,%rax
	jz L171
L169:
	cmpq $0,%r14
	jz L173
L172:
	movl $1,%r13d
	jmp L171
L173:
	movq %rbx,%r14
L171:
	leaq -24(%rbp),%rdi
	call _regs_clear
	leaq -48(%rbp),%rdi
	call _regs_clear
	cmpl $0,%r13d
	jnz L161
L160:
	movq 64(%rbx),%rbx
	jmp L158
L161:
	cmpl $0,%r13d
	jz L180
L179:
	xorl %eax,%eax
	jmp L157
L180:
	movq %r14,%rax
L157:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L187:
_loop_move:
L189:
	pushq %rbp
	movq %rsp,%rbp
	subq $184,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L190:
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
	xorps %xmm0,%xmm0
	movups %xmm0,-168(%rbp)
	movq $0,-152(%rbp)
	leaq -160(%rbp),%rsi
	movq %rsi,-152(%rbp)
	movl $0,-176(%rbp)	 # spill
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
L192:
	cmpq $0,%rbx
	jz L194
L193:
	movq 8(%rbx),%r13
	leaq -168(%rbp),%r12
	leaq -120(%rbp),%rax
	leaq -48(%rbp),%rsi
	movl (%rbx),%edi
	movq %rax,%rdx
	movq %r12,%rcx
	call _kill_gather_blks
	leaq -144(%rbp),%rax
	movq _head_b(%rip),%rsi
	movl (%rbx),%edi
	addq $456,%rsi
	movq %rax,%rdx
	movq %r12,%rcx
	call _kill_gather_blks
	movl -144(%rbp),%esi
	cmpl $0,%esi
	jz L197
L198:
	movl -120(%rbp),%esi
	cmpl $0,%esi
	jnz L202
L197:
	movl -144(%rbp),%esi
	cmpl $0,%esi
	jnz L206
L204:
	movl (%rbx),%esi
	leaq -96(%rbp),%rdi
	movl $1,%edx
	call _regs_lookup
	jmp L202
L206:
	cmpl $1,%esi
	ja L202
L210:
	movq -136(%rbp),%r12
	movl (%rbx),%esi
	movq (%r12),%rdi
	call _unique_def
	movq %rax,%rsi
	cmpq $0,%rsi
	jz L202
L215:
	leaq -168(%rbp),%rsi
	movq (%r12),%rdi
	call _dominates_all
	movl %eax,%esi
	cmpl $0,%esi
	jnz L220
L202:
	movl (%rbx),%esi
	leaq -72(%rbp),%rdi
	call _regs_remove
L220:
	leaq -120(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	leaq -144(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	leaq -168(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	movq %r13,%rbx
	jmp L192
L194:
	xorl %r13d,%r13d
L222:
	movl $0,-184(%rbp)	 # spill
	movq -64(%rbp),%rbx
L225:
	cmpq $0,%rbx
	jz L224
L226:
	movq 8(%rbx),%r15
	leaq -144(%rbp),%rax
	movq _head_b(%rip),%rsi
	movl (%rbx),%edi
	addq $456,%rsi
	movq %rax,%rdx
	xorl %ecx,%ecx
	call _kill_gather_blks
	movq -136(%rbp),%r14
	movl (%rbx),%esi
	movq (%r14),%rdi
	call _unique_def
	movq %rax,%r12
	leaq -96(%rbp),%rsi
	movq %r12,%rdi
	call _insn_movable
	movl %eax,%esi
	cmpl $0,%esi
	jz L230
L228:
	cmpq $0,%r13
	jnz L233
L231:
	movq _head_b(%rip),%rdi
	leaq 456(%rdi),%rsi
	call _block_preheader
	movq %rax,%rsi
	movq %rsi,%r13
	movl $1,-176(%rbp)	 # spill
L233:
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
	leaq -96(%rbp),%rdi
	movl $1,%edx
	call _regs_lookup
	movl $1,-184(%rbp)	 # spill
L230:
	leaq -144(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	movq %r15,%rbx
	jmp L225
L224:
	cmpl $0,-184(%rbp)	 # spill
	jnz L222
L223:
	leaq -96(%rbp),%rsi
	movq %rsi,%rdi
	call _regs_clear
	leaq -72(%rbp),%rsi
	movq %rsi,%rdi
	call _regs_clear
	leaq -24(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	leaq -48(%rbp),%rsi
	movq %rsi,%rdi
	call _blks_clear
	movl -176(%rbp),%eax	 # spill
L191:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L238:
_loop_invariants:
L239:
	pushq %rbp
	movq %rsp,%rbp
L240:
	call _webs_analyze
	movq $_invariants0,%rdi
	call _blocks_iter
L246:
	call _kill_analyze
	call _loop_analyze
L248:
	movq $0,_head_b(%rip)
	movq $_invariants1,%rdi
	call _blocks_iter
	movq _head_b(%rip),%rsi
	cmpq $0,%rsi
	jnz L250
L245:
	call _webs_strip
L241:
	popq %rbp
	ret
L250:
	orl $2,4(%rsi)
	call _loop_move
	cmpl $0,%eax
	jz L248
	jnz L246
L256:
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

.text
_regmaps_invalidate:
L3:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L25:
	movq %rdi,%rbx
	movq 8(%rsi),%r12
L6:
	cmpq $0,%r12
	jz L5
L10:
	movq 8(%rbx),%rsi
	movl (%r12),%edi
L11:
	cmpq $0,%rsi
	jz L8
L12:
	movl (%rsi),%eax
	cmpl %edi,%eax
	jz L15
L18:
	movl 4(%rsi),%eax
	cmpl %edi,%eax
	jnz L13
L15:
	movl (%rsi),%esi
	movq %rbx,%rdi
	call _regmaps_unset
	jmp L10
L13:
	movq 8(%rsi),%rsi
	jmp L11
L8:
	movq 8(%r12),%r12
	jmp L6
L5:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L27:
_local:
L29:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L47:
	movq %rsi,%r13
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq 8(%rdi),%rbx
L32:
	cmpq $0,%rbx
	jz L31
L33:
	leaq -32(%rbp),%rdx
	leaq -40(%rbp),%rsi
	movq %rbx,%rdi
	call _insn_copy
	cmpl $0,%eax
	jz L37
L36:
	movl -40(%rbp),%esi
	movl -32(%rbp),%edx
	movq %r13,%rdi
	call _regmaps_update
	jmp L34
L37:
	movq 8(%r13),%r12
L39:
	cmpq $0,%r12
	jz L42
L40:
	movl 4(%r12),%edx
	movl (%r12),%esi
	movq %rbx,%rdi
	movl $1,%ecx
	call _insn_substitute_reg
	cmpl $0,%eax
	jz L41
L43:
	movl $1,_changed(%rip)
L41:
	movq 8(%r12),%r12
	jmp L39
L42:
	leaq -24(%rbp),%r12
	movq %rbx,%rdi
	movq %r12,%rsi
	xorl %edx,%edx
	call _insn_defs_regs
	movq %r13,%rdi
	movq %r12,%rsi
	call _regmaps_invalidate
	movq %r12,%rdi
	call _regs_clear
L34:
	movq 64(%rbx),%rbx
	jmp L32
L31:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L49:
_local0:
L51:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L52:
	leaq -16(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	movq %rbx,%rsi
	call _local
	movq %rbx,%rdi
	call _regmaps_clear
	xorl %eax,%eax
L53:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L58:
.data
.align 8
_copies:
	.quad 0
.align 4
_next_copy_bit:
	.int -1
.text
_copies_new:
L63:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L70:
	movq %rdx,%r12
	movl %esi,%ebx
	movl %edi,%r14d
	movl %ecx,%r13d
	movl $32,%edi
	call _safe_malloc
	movl %r14d,(%rax)
	movl %ebx,4(%rax)
	movq %r12,8(%rax)
	movl %r13d,16(%rax)
	movq _copies(%rip),%rsi
	movq %rsi,24(%rax)
	movq %rax,_copies(%rip)
	addl $1,_nr_copies(%rip)
L65:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L72:
_copies_clear:
L74:
	pushq %rbp
	movq %rsp,%rbp
L77:
	movq _copies(%rip),%rdi
	cmpq $0,%rdi
	jz L79
L80:
	movq 24(%rdi),%rsi
	movq %rsi,_copies(%rip)
	call _free
	jmp L77
L79:
	movl $0,_nr_copies(%rip)
	movl $-1,_next_copy_bit(%rip)
L76:
	popq %rbp
	ret
L86:
_copies_invalidate:
L88:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L103:
	movq %rdi,%r14
	movl %esi,%r13d
	xorl %ebx,%ebx
	movq _copies(%rip),%r12
L91:
	cmpq $0,%r12
	jz L90
L92:
	movl (%r12),%esi
	cmpl %r13d,%esi
	jz L95
L98:
	movl 4(%r12),%esi
	cmpl %r13d,%esi
	jnz L97
L95:
	movq %r14,%rdi
	movl %ebx,%esi
	call _bitset_reset
L97:
	addl $1,%ebx
	movq 24(%r12),%r12
	jmp L91
L90:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L105:
_copies0:
L107:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
L119:
	movq %rdi,%rbx
	movq 8(%rbx),%r12
L110:
	cmpq $0,%r12
	jz L113
L111:
	leaq -8(%rbp),%rdx
	leaq -16(%rbp),%rsi
	movq %r12,%rdi
	call _insn_copy
	cmpl $0,%eax
	jz L112
L114:
	movl 8(%r12),%ecx
	movl -16(%rbp),%edi
	movl -8(%rbp),%esi
	movq %rbx,%rdx
	call _copies_new
L112:
	movq 64(%r12),%r12
	jmp L110
L113:
	xorl %eax,%eax
L109:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L121:
_init0:
L123:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L145:
	movq %rdi,%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movl _nr_copies(%rip),%esi
	leaq 248(%rbx),%rdi
	call _bitset_init
	movl _nr_copies(%rip),%esi
	leaq 280(%rbx),%rdi
	call _bitset_init
	movl _nr_copies(%rip),%esi
	leaq 264(%rbx),%rdi
	call _bitset_init
	movl _nr_copies(%rip),%esi
	leaq 296(%rbx),%r12
	movq %r12,%rdi
	call _bitset_init
	movl _nr_copies(%rip),%esi
	leaq 312(%rbx),%rdi
	call _bitset_init
	movq %r12,%rdi
	call _bitset_one_all
	movl _next_copy_bit(%rip),%esi
	cmpl $-1,%esi
	jnz L128
L126:
	movl _nr_copies(%rip),%esi
	movl %esi,_next_copy_bit(%rip)
L128:
	cmpq %rbx,_entry_block(%rip)
	jz L131
L129:
	leaq 248(%rbx),%rdi
	call _bitset_one_all
L131:
	movq 8(%rbx),%r13
L132:
	cmpq $0,%r13
	jz L135
L133:
	leaq -24(%rbp),%rsi
	movq %r13,%rdi
	xorl %edx,%edx
	call _insn_defs_regs
	movq -16(%rbp),%r12
L136:
	cmpq $0,%r12
	jz L139
L137:
	movl (%r12),%esi
	leaq 264(%rbx),%rdi
	call _copies_invalidate
	movl (%r12),%esi
	leaq 296(%rbx),%rdi
	call _copies_invalidate
	movq 8(%r12),%r12
	jmp L136
L139:
	leaq -24(%rbp),%rdi
	call _regs_clear
	leaq -32(%rbp),%rdx
	leaq -40(%rbp),%rsi
	movq %r13,%rdi
	call _insn_copy
	cmpl $0,%eax
	jz L134
L140:
	movl _next_copy_bit(%rip),%esi
	addl $-1,%esi
	movl %esi,_next_copy_bit(%rip)
	leaq 264(%rbx),%rdi
	call _bitset_set
L134:
	movq 64(%r13),%r13
	jmp L132
L135:
	xorl %eax,%eax
L125:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L147:
_copy0:
L149:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L165:
	movq %rdi,%rbx
	movq 504(%rbx),%r12
L152:
	cmpq $0,%r12
	jz L155
L153:
	cmpq %r12,504(%rbx)
	jnz L157
L156:
	movq 8(%r12),%rsi
	addq $280,%rsi
	leaq 248(%rbx),%rdi
	call _bitset_copy
	jmp L154
L157:
	movq 8(%r12),%rsi
	addq $280,%rsi
	leaq 248(%rbx),%rdi
	call _bitset_and
L154:
	movq 32(%r12),%r12
	jmp L152
L155:
	leaq 248(%rbx),%rsi
	leaq 312(%rbx),%r12
	movq %r12,%rdi
	call _bitset_copy
	leaq 296(%rbx),%rsi
	movq %r12,%rdi
	call _bitset_and
	leaq 264(%rbx),%rsi
	movq %r12,%rdi
	call _bitset_or
	addq $280,%rbx
	movq %r12,%rdi
	movq %rbx,%rsi
	call _bitset_same
	cmpl $0,%eax
	jz L161
L159:
	xorl %eax,%eax
	jmp L151
L161:
	movq %rbx,%rdi
	movq %r12,%rsi
	call _bitset_copy
	movl $2,%eax
L151:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L167:
_rewrite0:
L169:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L184:
	movq %rdi,%r13
	xorps %xmm0,%xmm0
	movups %xmm0,-16(%rbp)
	xorl %ebx,%ebx
	movq _copies(%rip),%r12
L172:
	movl _nr_copies(%rip),%esi
	cmpl %esi,%ebx
	jge L175
L173:
	leaq 248(%r13),%rdi
	movl %ebx,%esi
	call _bitset_get
	cmpl $0,%eax
	jz L174
L176:
	movl 4(%r12),%edx
	movl (%r12),%esi
	leaq -16(%rbp),%rdi
	call _regmaps_update
L174:
	addl $1,%ebx
	movq 24(%r12),%r12
	jmp L172
L175:
	leaq -16(%rbp),%rbx
	movl -16(%rbp),%esi
	cmpl $0,%esi
	jz L181
L179:
	movq %r13,%rdi
	movq %rbx,%rsi
	call _local
	movq %rbx,%rdi
	call _regmaps_clear
L181:
	xorl %eax,%eax
L171:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L186:
_clear0:
L188:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L193:
	movq %rdi,%rbx
	leaq 248(%rbx),%rdi
	call _bitset_clear
	leaq 280(%rbx),%rdi
	call _bitset_clear
	leaq 264(%rbx),%rdi
	call _bitset_clear
	leaq 296(%rbx),%rdi
	call _bitset_clear
	leaq 312(%rbx),%rdi
	call _bitset_clear
	xorl %eax,%eax
L190:
	popq %rbx
	popq %rbp
	ret
L195:
_copy:
L196:
	pushq %rbp
	movq %rsp,%rbp
L197:
	movl $0,_changed(%rip)
	movq $_local0,%rdi
	call _blocks_iter
	movq $_copies0,%rdi
	call _blocks_iter
	movl _nr_copies(%rip),%esi
	cmpl $0,%esi
	jle L201
L199:
	movq $_init0,%rdi
	call _blocks_iter
	movq $_copy0,%rdi
	call _blocks_iter
	movq $_rewrite0,%rdi
	call _blocks_iter
	movq $_clear0,%rdi
	call _blocks_iter
L201:
	call _copies_clear
	movl _changed(%rip),%esi
	cmpl $0,%esi
	jz L198
L202:
	call _dead
L198:
	popq %rbp
	ret
L208:
.globl _blocks_iter
.globl _bitset_clear
.globl _bitset_or
.globl _regs_clear
.globl _regmaps_clear
.local _nr_copies
.comm _nr_copies, 4, 4
.globl _insn_defs_regs
.globl _bitset_get
.globl _bitset_reset
.globl _bitset_set
.globl _bitset_and
.globl _bitset_init
.globl _regmaps_unset
.globl _regmaps_update
.globl _bitset_one_all
.globl _safe_malloc
.local _changed
.comm _changed, 4, 4
.globl _dead
.globl _bitset_same
.globl _free
.globl _insn_substitute_reg
.globl _copy
.globl _bitset_copy
.globl _insn_copy
.globl _entry_block

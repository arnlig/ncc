.text
_copyps_clear:
L3:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L16:
	movq %rdi,%rbx
L6:
	movq 8(%rbx),%rdi
	cmpq $0,%rdi
	jz L5
L7:
	addl $-1,(%rbx)
	movq 8(%rdi),%rsi
	cmpq $0,%rsi
	jz L14
L12:
	movq 16(%rdi),%rax
	movq %rax,16(%rsi)
L14:
	movq 8(%rdi),%rsi
	movq 16(%rdi),%rax
	movq %rsi,(%rax)
	call _free
	jmp L6
L5:
	popq %rbx
	popq %rbp
	ret
L18:
_copyps_lookup:
L20:
	pushq %rbp
	movq %rsp,%rbp
L21:
	movq 8(%rdi),%rax
L23:
	cmpq $0,%rax
	jz L26
L24:
	movl (%rax),%edi
	cmpl %esi,%edi
	jz L22
L25:
	movq 8(%rax),%rax
	jmp L23
L26:
	xorl %eax,%eax
L22:
	popq %rbp
	ret
L35:
_copyps_unset:
L37:
	pushq %rbp
	movq %rsp,%rbp
L55:
	movq %rdi,%rcx
	movq 8(%rcx),%rdi
L40:
	cmpq $0,%rdi
	jz L39
L41:
	movl (%rdi),%eax
	cmpl %esi,%eax
	jnz L42
L44:
	addl $-1,(%rcx)
	movq 8(%rdi),%rsi
	cmpq $0,%rsi
	jz L52
L50:
	movq 16(%rdi),%rax
	movq %rax,16(%rsi)
L52:
	movq 8(%rdi),%rsi
	movq 16(%rdi),%rax
	movq %rsi,(%rax)
	call _free
	jmp L39
L42:
	movq 8(%rdi),%rdi
	jmp L40
L39:
	popq %rbp
	ret
L57:
_copyps_insert:
L59:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L81:
	movl %esi,%r12d
	movq %rdi,%rbx
	movq 8(%rbx),%rsi
L62:
	cmpq $0,%rsi
	jz L65
L63:
	movl (%rsi),%edi
	cmpl %r12d,%edi
	jz L65
L64:
	movq 8(%rsi),%rsi
	jmp L62
L65:
	cmpq $0,%rsi
	jnz L72
L70:
	movl $24,%edi
	call _safe_malloc
	movq %rax,%rsi
	movl %r12d,(%rax)
	movq 8(%rbx),%rcx
	leaq 8(%rax),%rdi
	movq %rcx,8(%rax)
	cmpq $0,%rcx
	jz L78
L76:
	movq 8(%rbx),%rcx
	movq %rdi,16(%rcx)
L78:
	leaq 8(%rbx),%rdi
	movq %rax,8(%rbx)
	movq %rdi,16(%rax)
	addl $1,(%rbx)
L72:
	movq %rsi,%rax
L61:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L83:
_copyps_update:
L85:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L89:
	movl %edx,%ebx
	call _copyps_insert
	movl %ebx,4(%rax)
L87:
	popq %rbx
	popq %rbp
	ret
L91:
_copyps_invalidate:
L93:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L114:
	movq %rdi,%rbx
	movq 8(%rsi),%r12
L96:
	cmpq $0,%r12
	jz L95
L100:
	movq 8(%rbx),%rsi
L101:
	cmpq $0,%rsi
	jz L98
L102:
	movl (%rsi),%eax
	movl (%r12),%edi
	cmpl %edi,%eax
	jz L105
L108:
	movl 4(%rsi),%eax
	cmpl %edi,%eax
	jnz L103
L105:
	movl (%rsi),%esi
	movq %rbx,%rdi
	call _copyps_unset
	jmp L100
L103:
	movq 8(%rsi),%rsi
	jmp L101
L98:
	movq 8(%r12),%r12
	jmp L96
L95:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L116:
_local:
L118:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L136:
	movq %rdi,%rdx
	movq %rsi,%r13
	leaq -24(%rbp),%rdi
	movl $24,%ecx
	xorl %eax,%eax
	rep
	stosb
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq 8(%rdx),%rbx
L121:
	cmpq $0,%rbx
	jz L120
L122:
	leaq -32(%rbp),%rdx
	leaq -40(%rbp),%rsi
	movq %rbx,%rdi
	call _insn_copy
	cmpl $0,%eax
	jz L126
L125:
	movl -40(%rbp),%esi
	movl -32(%rbp),%edx
	movq %r13,%rdi
	call _copyps_update
	jmp L123
L126:
	movq 8(%r13),%r12
L128:
	cmpq $0,%r12
	jz L131
L129:
	movl 4(%r12),%edx
	movl (%r12),%esi
	movq %rbx,%rdi
	movl $1,%ecx
	call _insn_substitute_reg
	cmpl $0,%eax
	jz L130
L132:
	movl $1,_changed(%rip)
L130:
	movq 8(%r12),%r12
	jmp L128
L131:
	leaq -24(%rbp),%r12
	movq %rbx,%rdi
	movq %r12,%rsi
	call _insn_defs_regs
	movq %r13,%rdi
	movq %r12,%rsi
	call _copyps_invalidate
	movq %r12,%rdi
	call _regs_clear
L123:
	movq 40(%rbx),%rbx
	jmp L121
L120:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L138:
_local0:
L140:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L145:
	movq %rdi,%rsi
	leaq -16(%rbp),%rbx
	movq %rbx,%rdi
	movl $16,%ecx
	xorl %eax,%eax
	rep
	stosb
	movq %rsi,%rdi
	movq %rbx,%rsi
	call _local
	movq %rbx,%rdi
	call _copyps_clear
	xorl %eax,%eax
L142:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L147:
.data
.align 8
_copies:
	.quad 0
.align 4
_next_copy_bit:
	.int -1
.text
_copies_new:
L152:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L159:
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
L154:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L161:
_copies_clear:
L163:
	pushq %rbp
	movq %rsp,%rbp
L166:
	movq _copies(%rip),%rdi
	cmpq $0,%rdi
	jz L168
L169:
	movq 24(%rdi),%rsi
	movq %rsi,_copies(%rip)
	call _free
	jmp L166
L168:
	movl $0,_nr_copies(%rip)
	movl $-1,_next_copy_bit(%rip)
L165:
	popq %rbp
	ret
L175:
_copies_invalidate:
L177:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L192:
	movq %rdi,%r14
	movl %esi,%r13d
	xorl %ebx,%ebx
	movq _copies(%rip),%r12
L180:
	cmpq $0,%r12
	jz L179
L181:
	movl (%r12),%esi
	cmpl %r13d,%esi
	jz L184
L187:
	movl 4(%r12),%esi
	cmpl %r13d,%esi
	jnz L186
L184:
	movq %r14,%rdi
	movl %ebx,%esi
	call _bitset_reset
L186:
	addl $1,%ebx
	movq 24(%r12),%r12
	jmp L180
L179:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L194:
_copies0:
L196:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
L208:
	movq %rdi,%rbx
	movq 8(%rbx),%r12
L199:
	cmpq $0,%r12
	jz L202
L200:
	leaq -8(%rbp),%rdx
	leaq -16(%rbp),%rsi
	movq %r12,%rdi
	call _insn_copy
	cmpl $0,%eax
	jz L201
L203:
	movl 8(%r12),%ecx
	movl -16(%rbp),%edi
	movl -8(%rbp),%esi
	movq %rbx,%rdx
	call _copies_new
L201:
	movq 40(%r12),%r12
	jmp L199
L202:
	xorl %eax,%eax
L198:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L210:
_init0:
L212:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L234:
	movq %rdi,%rbx
	leaq -24(%rbp),%rdi
	movl $24,%ecx
	xorl %eax,%eax
	rep
	stosb
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	leaq 224(%rbx),%rdi
	movl _nr_copies(%rip),%esi
	call _bitset_init
	leaq 256(%rbx),%rdi
	movl _nr_copies(%rip),%esi
	call _bitset_init
	leaq 240(%rbx),%rdi
	movl _nr_copies(%rip),%esi
	call _bitset_init
	leaq 272(%rbx),%r12
	movl _nr_copies(%rip),%esi
	movq %r12,%rdi
	call _bitset_init
	leaq 288(%rbx),%rdi
	movl _nr_copies(%rip),%esi
	call _bitset_init
	movq %r12,%rdi
	call _bitset_one_all
	movl _next_copy_bit(%rip),%esi
	cmpl $-1,%esi
	jnz L217
L215:
	movl _nr_copies(%rip),%esi
	movl %esi,_next_copy_bit(%rip)
L217:
	cmpq %rbx,_entry_block(%rip)
	jz L220
L218:
	leaq 224(%rbx),%rdi
	call _bitset_one_all
L220:
	movq 8(%rbx),%r13
L221:
	cmpq $0,%r13
	jz L224
L222:
	leaq -24(%rbp),%rsi
	movq %r13,%rdi
	call _insn_defs_regs
	movq -16(%rbp),%r12
L225:
	cmpq $0,%r12
	jz L228
L226:
	movl (%r12),%esi
	leaq 240(%rbx),%rdi
	call _copies_invalidate
	movl (%r12),%esi
	leaq 272(%rbx),%rdi
	call _copies_invalidate
	movq 8(%r12),%r12
	jmp L225
L228:
	leaq -24(%rbp),%rdi
	call _regs_clear
	leaq -32(%rbp),%rdx
	leaq -40(%rbp),%rsi
	movq %r13,%rdi
	call _insn_copy
	cmpl $0,%eax
	jz L223
L229:
	movl _next_copy_bit(%rip),%esi
	addl $-1,%esi
	movl %esi,_next_copy_bit(%rip)
	leaq 240(%rbx),%rdi
	call _bitset_set
L223:
	movq 40(%r13),%r13
	jmp L221
L224:
	xorl %eax,%eax
L214:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L236:
_copy0:
L238:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L254:
	movq %rdi,%rbx
	movq 480(%rbx),%r12
L241:
	cmpq $0,%r12
	jz L244
L242:
	cmpq %r12,480(%rbx)
	jnz L246
L245:
	movq 8(%r12),%rsi
	addq $256,%rsi
	leaq 224(%rbx),%rdi
	call _bitset_copy
	jmp L243
L246:
	movq 8(%r12),%rsi
	addq $256,%rsi
	leaq 224(%rbx),%rdi
	call _bitset_and
L243:
	movq 32(%r12),%r12
	jmp L241
L244:
	leaq 224(%rbx),%rsi
	leaq 288(%rbx),%r12
	movq %r12,%rdi
	call _bitset_copy
	leaq 272(%rbx),%rsi
	movq %r12,%rdi
	call _bitset_and
	leaq 240(%rbx),%rsi
	movq %r12,%rdi
	call _bitset_or
	addq $256,%rbx
	movq %r12,%rdi
	movq %rbx,%rsi
	call _bitset_same
	cmpl $0,%eax
	jz L250
L248:
	xorl %eax,%eax
	jmp L240
L250:
	movq %rbx,%rdi
	movq %r12,%rsi
	call _bitset_copy
	movl $2,%eax
L240:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L256:
_rewrite0:
L258:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L273:
	movq %rdi,%r13
	leaq -16(%rbp),%rdi
	movl $16,%ecx
	xorl %eax,%eax
	rep
	stosb
	xorl %ebx,%ebx
	movq _copies(%rip),%r12
L261:
	movl _nr_copies(%rip),%esi
	cmpl %esi,%ebx
	jge L264
L262:
	leaq 224(%r13),%rdi
	movl %ebx,%esi
	call _bitset_get
	cmpl $0,%eax
	jz L263
L265:
	movl 4(%r12),%edx
	movl (%r12),%esi
	leaq -16(%rbp),%rdi
	call _copyps_update
L263:
	addl $1,%ebx
	movq 24(%r12),%r12
	jmp L261
L264:
	leaq -16(%rbp),%rbx
	movl -16(%rbp),%esi
	cmpl $0,%esi
	jz L270
L268:
	movq %r13,%rdi
	movq %rbx,%rsi
	call _local
	movq %rbx,%rdi
	call _copyps_clear
L270:
	xorl %eax,%eax
L260:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L275:
_clear0:
L277:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L282:
	movq %rdi,%rbx
	leaq 224(%rbx),%rdi
	call _bitset_clear
	leaq 256(%rbx),%rdi
	call _bitset_clear
	leaq 240(%rbx),%rdi
	call _bitset_clear
	leaq 272(%rbx),%rdi
	call _bitset_clear
	leaq 288(%rbx),%rdi
	call _bitset_clear
	xorl %eax,%eax
L279:
	popq %rbx
	popq %rbp
	ret
L284:
_copy:
L285:
	pushq %rbp
	movq %rsp,%rbp
L286:
	movl $0,_changed(%rip)
	movq $_local0,%rdi
	call _blocks_iter
	movq $_copies0,%rdi
	call _blocks_iter
	movl _nr_copies(%rip),%esi
	cmpl $0,%esi
	jle L290
L288:
	movq $_init0,%rdi
	call _blocks_iter
	movq $_copy0,%rdi
	call _blocks_iter
	movq $_rewrite0,%rdi
	call _blocks_iter
	movq $_clear0,%rdi
	call _blocks_iter
L290:
	call _copies_clear
	movl _changed(%rip),%esi
	cmpl $0,%esi
	jz L287
L291:
	call _dead
L287:
	popq %rbp
	ret
L297:
.globl _blocks_iter
.globl _bitset_clear
.globl _bitset_or
.globl _regs_clear
.local _nr_copies
.comm _nr_copies, 4, 4
.globl _insn_defs_regs
.globl _bitset_get
.globl _bitset_reset
.globl _bitset_set
.globl _bitset_and
.globl _bitset_init
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

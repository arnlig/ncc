.data
.align 8
_regs_free_list:
	.quad 0
.text
_regs_alloc:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movl $24000,%edi
	call _safe_malloc
	movl $1,%esi
L8:
	movq _regs_free_list(%rip),%rdi
	movslq %esi,%rcx
	imulq $24,%rcx
	leaq (%rax,%rcx),%rdx
	movq %rdi,8(%rax,%rcx)
	movq %rdx,_regs_free_list(%rip)
	addl $1,%esi
	cmpl $1000,%esi
	jl L8
L3:
	popq %rbp
	ret
L15:
_regs_lookup:
L16:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L55:
	movq %rdi,%rbx
	movl %esi,%r13d
	movq 8(%rbx),%r12
L19:
	cmpq $0,%r12
	jz L22
L20:
	movl (%r12),%esi
	cmpl %r13d,%esi
	jnz L25
L23:
	movq %r12,%rax
	jmp L18
L25:
	cmpl %r13d,%esi
	ja L22
L21:
	movq 8(%r12),%r12
	jmp L19
L22:
	testl $1,%edx
	jz L32
L34:
	movq _regs_free_list(%rip),%rsi
	movq %rsi,%rax
	cmpq $0,%rsi
	jz L38
L40:
	movq 8(%rsi),%rsi
	movq %rsi,_regs_free_list(%rip)
	jmp L35
L38:
	call _regs_alloc
L35:
	movl %r13d,(%rax)
	cmpq $0,%r12
	jz L49
L46:
	movq 16(%r12),%rsi
	movq %rsi,16(%rax)
	leaq 8(%rax),%rsi
	movq %r12,8(%rax)
	movq 16(%r12),%rdi
	movq %rax,(%rdi)
	movq %rsi,16(%r12)
	jmp L45
L49:
	leaq 8(%rax),%rsi
	movq $0,8(%rax)
	movq 16(%rbx),%rdi
	movq %rdi,16(%rax)
	movq 16(%rbx),%rdi
	movq %rax,(%rdi)
	movq %rsi,16(%rbx)
L45:
	addl $1,(%rbx)
	jmp L18
L32:
	xorl %eax,%eax
L18:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L57:
_regs_remove:
L58:
	pushq %rbp
	movq %rsp,%rbp
L59:
	movq 8(%rdi),%rax
L61:
	cmpq $0,%rax
	jz L60
L62:
	movl (%rax),%ecx
	cmpl %esi,%ecx
	jnz L63
L68:
	addl $-1,(%rdi)
	movq 8(%rax),%rsi
	cmpq $0,%rsi
	jz L75
L74:
	movq 16(%rax),%rdi
	movq %rdi,16(%rsi)
	jmp L76
L75:
	movq 16(%rax),%rsi
	movq %rsi,16(%rdi)
L76:
	movq 8(%rax),%rsi
	movq 16(%rax),%rdi
	movq %rsi,(%rdi)
	movq _regs_free_list(%rip),%rsi
	movq %rsi,8(%rax)
	movq %rax,_regs_free_list(%rip)
	jmp L60
L63:
	movq 8(%rax),%rax
	jmp L61
L60:
	popq %rbp
	ret
L84:
_regs_overlap:
L85:
	pushq %rbp
	movq %rsp,%rbp
L86:
	movq 8(%rdi),%rdi
	movq 8(%rsi),%rsi
L88:
	cmpq $0,%rdi
	jz L90
L91:
	cmpq $0,%rsi
	jz L90
L89:
	movl (%rdi),%eax
	movl (%rsi),%ecx
	cmpl %ecx,%eax
	jnz L97
L95:
	movl $1,%eax
	jmp L87
L97:
	cmpl %ecx,%eax
	jae L100
L99:
	movq 8(%rdi),%rdi
	jmp L88
L100:
	movq 8(%rsi),%rsi
	jmp L88
L90:
	xorl %eax,%eax
L87:
	popq %rbp
	ret
L106:
_regs_diff:
L107:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L115:
	movq %rdi,%r12
	movq 8(%rsi),%rbx
L110:
	cmpq $0,%rbx
	jz L109
L111:
	movl (%rbx),%esi
	movq %r12,%rdi
	call _regs_remove
	movq 8(%rbx),%rbx
	jmp L110
L109:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L117:
_regs_union:
L118:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L159:
	movq %rdi,%rbx
	movq 8(%rbx),%r12
	movq 8(%rsi),%r13
L121:
	cmpq $0,%r13
	jz L120
L125:
	cmpq $0,%r12
	jz L127
L128:
	movl (%r12),%esi
	movl (%r13),%edi
	cmpl %edi,%esi
	jae L127
L126:
	movq 8(%r12),%r12
	jmp L125
L127:
	cmpq $0,%r12
	jz L140
L135:
	movl (%r12),%esi
	movl (%r13),%edi
	cmpl %edi,%esi
	jz L123
L140:
	movq _regs_free_list(%rip),%rsi
	movq %rsi,%rax
	cmpq $0,%rsi
	jz L144
L146:
	movq 8(%rsi),%rsi
	movq %rsi,_regs_free_list(%rip)
	jmp L141
L144:
	call _regs_alloc
L141:
	movl (%r13),%esi
	movl %esi,(%rax)
	cmpq $0,%r12
	jz L155
L152:
	movq 16(%r12),%rsi
	movq %rsi,16(%rax)
	leaq 8(%rax),%rsi
	movq %r12,8(%rax)
	movq 16(%r12),%rdi
	movq %rax,(%rdi)
	movq %rsi,16(%r12)
	jmp L151
L155:
	leaq 8(%rax),%rsi
	movq $0,8(%rax)
	movq 16(%rbx),%rdi
	movq %rdi,16(%rax)
	movq 16(%rbx),%rdi
	movq %rax,(%rdi)
	movq %rsi,16(%rbx)
L151:
	addl $1,(%rbx)
L123:
	movq 8(%r13),%r13
	jmp L121
L120:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L161:
_regs_move:
L162:
	pushq %rbp
	movq %rsp,%rbp
L165:
	leaq 8(%rsi),%rax
	movq 8(%rsi),%rcx
	cmpq $0,%rcx
	jz L166
L168:
	movq 16(%rdi),%rdx
	movq %rcx,(%rdx)
	movq 16(%rdi),%rcx
	movq 8(%rsi),%rdx
	movq %rcx,16(%rdx)
	movq 16(%rsi),%rcx
	movq %rcx,16(%rdi)
	movq $0,8(%rsi)
	movq %rax,16(%rsi)
L166:
	movl (%rsi),%eax
	movl %eax,(%rdi)
	movl $0,(%rsi)
L164:
	popq %rbp
	ret
L177:
_regs_equal:
L178:
	pushq %rbp
	movq %rsp,%rbp
L179:
	movl (%rdi),%eax
	movl (%rsi),%ecx
	cmpl %ecx,%eax
	jz L183
L181:
	xorl %eax,%eax
	jmp L180
L183:
	movq 8(%rdi),%rdi
	movq 8(%rsi),%rsi
L185:
	cmpq $0,%rdi
	jz L187
L186:
	movl (%rdi),%eax
	movl (%rsi),%ecx
	cmpl %ecx,%eax
	jz L190
L188:
	xorl %eax,%eax
	jmp L180
L190:
	movq 8(%rdi),%rdi
	movq 8(%rsi),%rsi
	jmp L185
L187:
	movl $1,%eax
L180:
	popq %rbp
	ret
L196:
_regs_clear:
L197:
	pushq %rbp
	movq %rsp,%rbp
L200:
	movq 8(%rdi),%rsi
	cmpq $0,%rsi
	jz L199
L203:
	addl $-1,(%rdi)
	movq 8(%rsi),%rax
	cmpq $0,%rax
	jz L210
L209:
	movq 16(%rsi),%rcx
	movq %rcx,16(%rax)
	jmp L211
L210:
	movq 16(%rsi),%rax
	movq %rax,16(%rdi)
L211:
	movq 8(%rsi),%rax
	movq 16(%rsi),%rcx
	movq %rax,(%rcx)
	movq _regs_free_list(%rip),%rax
	movq %rax,8(%rsi)
	movq %rsi,_regs_free_list(%rip)
	jmp L200
L199:
	popq %rbp
	ret
L218:
_regs_eliminate_base:
L219:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L230:
	movq %rdi,%rbx
	movl %esi,%r13d
	movq 8(%rbx),%rsi
	andl $2149580799,%r13d
L222:
	cmpq $0,%rsi
	jz L221
L223:
	movq 8(%rsi),%r12
	movl (%rsi),%esi
	movl %esi,%edi
	andl $2149580799,%edi
	cmpl %r13d,%edi
	jnz L227
L225:
	movq %rbx,%rdi
	call _regs_remove
L227:
	movq %r12,%rsi
	jmp L222
L221:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L232:
_regs_eliminate_bases:
L233:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L241:
	movq %rdi,%r12
	movq 8(%rsi),%rbx
L236:
	cmpq $0,%rbx
	jz L235
L237:
	movl (%rbx),%esi
	movq %r12,%rdi
	call _regs_eliminate_base
	movq 8(%rbx),%rbx
	jmp L236
L235:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L243:
_regs_replace_base:
L244:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L248:
	movq %rdi,%r12
	movl %esi,%ebx
	movq %r12,%rdi
	movl %ebx,%esi
	call _regs_eliminate_base
	movq %r12,%rdi
	movl %ebx,%esi
	movl $1,%edx
	call _regs_lookup
L246:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L250:
_regs_select_base:
L251:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L263:
	movq %rdi,%r13
	movl %edx,%r12d
	movq 8(%rsi),%rbx
	andl $2149580799,%r12d
L254:
	cmpq $0,%rbx
	jz L253
L255:
	movl (%rbx),%esi
	movl %esi,%edi
	andl $2149580799,%edi
	cmpl %r12d,%edi
	jnz L256
L258:
	movq %r13,%rdi
	movl $1,%edx
	call _regs_lookup
L256:
	movq 8(%rbx),%rbx
	jmp L254
L253:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L265:
_regs_select_bases:
L266:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L274:
	movq %rsi,%r12
	movq %rdi,%r13
	movq 8(%rdx),%rbx
L269:
	cmpq $0,%rbx
	jz L268
L270:
	movl (%rbx),%edx
	movq %r13,%rdi
	movq %r12,%rsi
	call _regs_select_base
	movq 8(%rbx),%rbx
	jmp L269
L268:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L276:
_regs_intersect_bases:
L277:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
L281:
	movq %rsi,%rdx
	movq %rdi,%r12
	leaq -24(%rbp),%rbx
	xorps %xmm0,%xmm0
	movups %xmm0,-24(%rbp)
	movq $0,-8(%rbp)
	leaq -16(%rbp),%rsi
	movq %rsi,-8(%rbp)
	movq %rbx,%rdi
	movq %r12,%rsi
	call _regs_select_bases
	movq %r12,%rdi
	call _regs_clear
	movq %r12,%rdi
	movq %rbx,%rsi
	call _regs_move
L279:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L283:
_regs_output:
L284:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L295:
	movq %rdi,%rbx
	pushq $L287
	call _output
	addq $8,%rsp
	movq 8(%rbx),%rbx
L288:
	cmpq $0,%rbx
	jz L291
L289:
	movl (%rbx),%esi
	pushq %rsi
	pushq $L292
	call _output
	addq $16,%rsp
	movq 8(%rbx),%rbx
	jmp L288
L291:
	pushq $L293
	call _output
	addq $8,%rsp
L286:
	popq %rbx
	popq %rbp
	ret
L297:
L292:
	.byte 37,114,32,0
L287:
	.byte 123,32,0
L293:
	.byte 125,0
.globl _regs_overlap
.globl _regs_lookup
.globl _regs_clear
.globl _regs_intersect_bases
.globl _regs_select_bases
.globl _regs_eliminate_bases
.globl _regs_output
.globl _regs_free_list
.globl _output
.globl _regs_move
.globl _regs_remove
.globl _regs_diff
.globl _regs_alloc
.globl _safe_malloc
.globl _regs_select_base
.globl _regs_replace_base
.globl _regs_eliminate_base
.globl _regs_equal
.globl _regs_union

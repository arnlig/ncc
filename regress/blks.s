.data
.align 8
_blks_free_list:
	.quad 0
.text
_blks_alloc:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movl $24000,%edi
	call _safe_malloc
	movl $1,%esi
L8:
	movq _blks_free_list(%rip),%rdi
	movslq %esi,%rcx
	imulq $24,%rcx
	leaq (%rax,%rcx),%rdx
	movq %rdi,8(%rax,%rcx)
	movq %rdx,_blks_free_list(%rip)
	addl $1,%esi
	cmpl $1000,%esi
	jl L8
L3:
	popq %rbp
	ret
L15:
_blks_lookup:
L16:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L55:
	movq %rdi,%rbx
	movq %rsi,%r13
	movq 8(%rbx),%r12
L19:
	cmpq $0,%r12
	jz L22
L20:
	movq (%r12),%rsi
	cmpq %rsi,%r13
	jnz L25
L23:
	movq %r12,%rax
	jmp L18
L25:
	cmpq %r13,%rsi
	ja L22
L21:
	movq 8(%r12),%r12
	jmp L19
L22:
	andl $1,%edx
	cmpl $0,%edx
	jz L32
L34:
	movq _blks_free_list(%rip),%rsi
	movq %rsi,%rax
	cmpq $0,%rsi
	jz L38
L40:
	movq 8(%rsi),%rsi
	movq %rsi,_blks_free_list(%rip)
	jmp L35
L38:
	call _blks_alloc
L35:
	movq %r13,(%rax)
	cmpq $0,%r12
	jz L49
L46:
	movq 16(%r12),%rdi
	leaq 8(%rax),%rsi
	movq %rdi,16(%rax)
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
_blks_union:
L58:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L99:
	movq %rdi,%rbx
	movq 8(%rbx),%r12
	movq 8(%rsi),%r13
L61:
	cmpq $0,%r13
	jz L60
L65:
	cmpq $0,%r12
	jz L67
L68:
	movq (%r12),%rsi
	cmpq (%r13),%rsi
	jae L67
L66:
	movq 8(%r12),%r12
	jmp L65
L67:
	cmpq $0,%r12
	jz L80
L75:
	movq (%r13),%rsi
	cmpq (%r12),%rsi
	jz L63
L80:
	movq _blks_free_list(%rip),%rsi
	movq %rsi,%rax
	cmpq $0,%rsi
	jz L84
L86:
	movq 8(%rsi),%rsi
	movq %rsi,_blks_free_list(%rip)
	jmp L81
L84:
	call _blks_alloc
L81:
	movq (%r13),%rsi
	movq %rsi,(%rax)
	cmpq $0,%r12
	jz L95
L92:
	movq 16(%r12),%rdi
	leaq 8(%rax),%rsi
	movq %rdi,16(%rax)
	movq %r12,8(%rax)
	movq 16(%r12),%rdi
	movq %rax,(%rdi)
	movq %rsi,16(%r12)
	jmp L91
L95:
	leaq 8(%rax),%rsi
	movq $0,8(%rax)
	movq 16(%rbx),%rdi
	movq %rdi,16(%rax)
	movq 16(%rbx),%rdi
	movq %rax,(%rdi)
	movq %rsi,16(%rbx)
L91:
	addl $1,(%rbx)
L63:
	movq 8(%r13),%r13
	jmp L61
L60:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L101:
_blks_intersect:
L102:
	pushq %rbp
	movq %rsp,%rbp
L103:
	movq 8(%rdi),%rax
	movq 8(%rsi),%rsi
L105:
	cmpq $0,%rax
	jz L133
L108:
	cmpq $0,%rsi
	jz L133
L106:
	movq (%rsi),%rcx
	movq (%rax),%rdx
	cmpq %rdx,%rcx
	jnz L113
L112:
	movq 8(%rax),%rax
	movq 8(%rsi),%rsi
	jmp L105
L113:
	cmpq %rcx,%rdx
	jae L116
L115:
	movq 8(%rax),%rdx
	addl $-1,(%rdi)
	movq 8(%rax),%rcx
	cmpq $0,%rcx
	jz L125
L124:
	movq 16(%rax),%r8
	movq %r8,16(%rcx)
	jmp L126
L125:
	movq 16(%rax),%rcx
	movq %rcx,16(%rdi)
L126:
	movq 8(%rax),%rcx
	movq 16(%rax),%r8
	movq %rcx,(%r8)
	movq _blks_free_list(%rip),%rcx
	movq %rcx,8(%rax)
	movq %rax,_blks_free_list(%rip)
	movq %rdx,%rax
	jmp L105
L116:
	cmpq %rcx,%rdx
	jbe L105
L130:
	movq 8(%rsi),%rsi
	jmp L105
L133:
	cmpq $0,%rax
	jz L104
L134:
	movq 8(%rax),%rcx
	addl $-1,(%rdi)
	movq 8(%rax),%rsi
	cmpq $0,%rsi
	jz L143
L142:
	movq 16(%rax),%rdx
	movq %rdx,16(%rsi)
	jmp L144
L143:
	movq 16(%rax),%rsi
	movq %rsi,16(%rdi)
L144:
	movq 8(%rax),%rsi
	movq 16(%rax),%rdx
	movq %rsi,(%rdx)
	movq _blks_free_list(%rip),%rsi
	movq %rsi,8(%rax)
	movq %rax,_blks_free_list(%rip)
	movq %rcx,%rax
	jmp L133
L104:
	popq %rbp
	ret
L151:
_blks_move:
L152:
	pushq %rbp
	movq %rsp,%rbp
L155:
	leaq 8(%rsi),%rax
	movq 8(%rsi),%rcx
	cmpq $0,%rcx
	jz L156
L158:
	movq 16(%rdi),%rdx
	movq %rcx,(%rdx)
	movq 16(%rdi),%rcx
	movq 8(%rsi),%rdx
	movq %rcx,16(%rdx)
	movq 16(%rsi),%rcx
	movq %rcx,16(%rdi)
	movq $0,8(%rsi)
	movq %rax,16(%rsi)
L156:
	movl (%rsi),%eax
	movl %eax,(%rdi)
	movl $0,(%rsi)
L154:
	popq %rbp
	ret
L167:
_blks_clear:
L168:
	pushq %rbp
	movq %rsp,%rbp
L171:
	movq 8(%rdi),%rsi
	cmpq $0,%rsi
	jz L170
L174:
	addl $-1,(%rdi)
	movq 8(%rsi),%rax
	cmpq $0,%rax
	jz L181
L180:
	movq 16(%rsi),%rcx
	movq %rcx,16(%rax)
	jmp L182
L181:
	movq 16(%rsi),%rax
	movq %rax,16(%rdi)
L182:
	movq 8(%rsi),%rax
	movq 16(%rsi),%rcx
	movq %rax,(%rcx)
	movq _blks_free_list(%rip),%rax
	movq %rax,8(%rsi)
	movq %rsi,_blks_free_list(%rip)
	jmp L171
L170:
	popq %rbp
	ret
L189:
_blks_output:
L190:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L201:
	movq %rdi,%rbx
	pushq $L193
	call _output
	addq $8,%rsp
	movq 8(%rbx),%rbx
L194:
	cmpq $0,%rbx
	jz L197
L195:
	movq (%rbx),%rsi
	movl (%rsi),%esi
	pushq %rsi
	pushq $L198
	call _output
	addq $16,%rsp
	movq 8(%rbx),%rbx
	jmp L194
L197:
	pushq $L199
	call _output
	addq $8,%rsp
L192:
	popq %rbx
	popq %rbp
	ret
L203:
L193:
	.byte 123,0
L198:
	.byte 32,37,76,0
L199:
	.byte 32,125,0
.globl _blks_lookup
.globl _blks_clear
.globl _blks_output
.globl _blks_intersect
.globl _blks_free_list
.globl _output
.globl _blks_move
.globl _blks_alloc
.globl _safe_malloc
.globl _blks_union

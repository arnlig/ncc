.text
_gen_branch:
L1:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L5:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rdx,%r14
L2:
	movl $64,%edi
	movl $0,%esi
	movl $0,%edx
	call _operand_i
	movq %rax,%r13
	movq %rbx,%rdi
	call _operand_leaf
	pushq %r13
	pushq %rax
	pushq $872415247
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq _current_block(%rip),%rdi
	movl $0,%esi
	movq %r14,%rdx
	call _block_add_successor
	movq _current_block(%rip),%rdi
	movl $1,%esi
	movq %r12,%rdx
	call _block_add_successor
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L7:
_gen_frame:
L9:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L14:
	movq %rdi,%r12
L10:
	movq %r12,%rdi
	call _symbol_storage
	movq _target(%rip),%rsi
	movq 16(%rsi),%rdi
	call _symbol_temp_reg
	movl %eax,%ebx
	movl 64(%r12),%esi
	movslq %esi,%rsi
	movl $64,%edi
	movl $0,%edx
	call _operand_i
	movq %rax,%r12
	movq _target(%rip),%rsi
	movq 16(%rsi),%rdi
	movl %ebx,%esi
	call _operand_reg
	pushq %r12
	pushq %rax
	pushq $1611137025
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movl %ebx,%eax
L11:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L16:
_gen_args0:
L18:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L39:
	movq %rdi,%rbx
L19:
	movq 32(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $65536,%rsi
	cmpq $0,%rsi
	jnz L20
L23:
	movl 12(%rbx),%esi
	andl $128,%esi
	cmpl $0,%esi
	jz L26
L28:
	movq 32(%rbx),%rsi
	movq (%rsi),%rsi
	andq $262144,%rsi
	cmpq $0,%rsi
	jnz L26
L25:
	movl 56(%rbx),%esi
	cmpl $2147483649,%esi
	jz L33
L32:
	movl 56(%rbx),%esi
	movq 32(%rbx),%rdi
	movq (%rdi),%rdi
	call _operand_reg
	movq %rax,%r12
	movq %rbx,%rdi
	call _symbol_reg
	movq 32(%rbx),%rsi
	movq (%rsi),%rdi
	movl %eax,%esi
	call _operand_reg
	pushq %r12
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	jmp L20
L33:
	movq %rbx,%rdi
	call _gen_frame
	movq _target(%rip),%rsi
	movq 16(%rsi),%rdi
	movl %eax,%esi
	call _operand_reg
	movq %rax,%r12
	movq %rbx,%rdi
	call _symbol_reg
	movq 32(%rbx),%rsi
	movq (%rsi),%rdi
	movl %eax,%esi
	call _operand_reg
	pushq %r12
	pushq %rax
	pushq $1644691458
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	jmp L20
L26:
	movl 56(%rbx),%esi
	cmpl $2147483649,%esi
	jz L20
L35:
	movq %rbx,%rdi
	call _gen_frame
	movl %eax,%r12d
	movl 56(%rbx),%esi
	movq 32(%rbx),%rdi
	movq (%rdi),%rdi
	call _operand_reg
	movq %rax,%rbx
	movq _target(%rip),%rsi
	movq 16(%rsi),%rdi
	movl %r12d,%esi
	call _operand_reg
	pushq %rbx
	pushq %rax
	pushq $1632108547
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L20:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L41:
_gen_args:
L42:
	pushq %rbp
	movq %rsp,%rbp
L43:
	movq _entry_block(%rip),%rdi
	call _block_always_successor
	movq _entry_block(%rip),%rdi
	movq %rax,%rsi
	call _block_split_edge
	movq %rax,_current_block(%rip)
	movq $_gen_args0,%rdi
	call _scope_walk_args
L44:
	popq %rbp
	ret
L48:
_gen_load:
L50:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L57:
	movq %rdi,%r12
	movq %rsi,%r13
L51:
	movq %r13,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r12,%rdi
	call _operand_sym
	pushq %rbx
	pushq %rax
	pushq $1644691458
	call _insn_new
	addq $24,%rsp
	movq 8(%r13),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	andq $393216,%rsi
	andq $262144,%rsi
	cmpq $0,%rsi
	jz L55
L53:
	movl 4(%rax),%esi
	orl $1,%esi
	movl %esi,4(%rax)
L55:
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L52:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L59:
_gen_store:
L61:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L68:
	movq %rdi,%r12
L62:
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r12,%rdi
	call _operand_leaf
	pushq %rbx
	pushq %rax
	pushq $1632108547
	call _insn_new
	addq $24,%rsp
	movq 8(%r12),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	andq $393216,%rsi
	andq $262144,%rsi
	cmpq $0,%rsi
	jz L66
L64:
	movl 4(%rax),%esi
	orl $1,%esi
	movl %esi,4(%rax)
L66:
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L63:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L70:
_gen_addrof:
L72:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L80:
	movq %rdi,%r14
L73:
	movq 24(%r14),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%r14)
	leaq 8(%r14),%rdi
	call _symbol_temp
	movq %rax,%r13
	movq 24(%r14),%rsi
	movq 32(%rsi),%rbx
	movq %rbx,%r12
	movq %rbx,%rdi
	call _symbol_storage
	movl 12(%rbx),%esi
	andl $256,%esi
	cmpl $0,%esi
	jz L77
L75:
	movl 12(%r12),%esi
	andl $-257,%esi
	movl %esi,12(%r12)
	movl 12(%r12),%esi
	orl $64,%esi
	movl %esi,12(%r12)
L77:
	movl 64(%r12),%esi
	movslq %esi,%rsi
	movl $64,%edi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq %r13,%rdi
	call _operand_sym
	pushq %rbx
	pushq %rax
	pushq $1611137025
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq %r14,%rdi
	call _tree_free
	movq %r13,%rdi
	call _tree_sym
L74:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L82:
_gen_blkasg:
L84:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L89:
	movq %rdi,%r13
L85:
	movq 24(%r13),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%r13)
	movq 32(%r13),%rdi
	movl $0,%esi
	call _gen
	movq %rax,32(%r13)
	leaq 8(%r13),%rdi
	movl $1,%esi
	call _type_sizeof
	movq _target(%rip),%rsi
	movq 16(%rsi),%rdi
	movq %rax,%rsi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq 32(%r13),%rdi
	call _operand_leaf
	movq %rax,%r12
	movq 24(%r13),%rdi
	call _operand_leaf
	pushq %rbx
	pushq %r12
	pushq %rax
	pushq $1900019716
	call _insn_new
	addq $32,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq %r13,%rdi
	call _tree_chop_binary
L86:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L91:
_extract:
L93:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L97:
	movl %esi,%r12d
	movl %edx,%ebx
	movq %rdi,%r14
L94:
	leaq 32(%r14),%rdi
	movl $0,%esi
	call _type_sizeof
	leal (,%rax,8),%r13d
	leal (%r12,%rbx),%esi
	movl %r13d,%edi
	subl %esi,%edi
	subl %r12d,%r13d
	movslq %edi,%rsi
	movl $64,%edi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq %r14,%rdi
	call _operand_sym
	movq %rax,%r12
	movq %r14,%rdi
	call _operand_sym
	pushq %rbx
	pushq %r12
	pushq %rax
	pushq $1879048214
	call _insn_new
	addq $32,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movslq %r13d,%rsi
	movl $64,%edi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq %r14,%rdi
	call _operand_sym
	movq %rax,%r12
	movq %r14,%rdi
	call _operand_sym
	pushq %rbx
	pushq %r12
	pushq %rax
	pushq $1879048213
	call _insn_new
	addq $32,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L95:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L99:
_gen_fetch:
L101:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L123:
	movl %esi,%r13d
	movq %rdi,%r12
L102:
	movl $0,%ebx
	movq 24(%r12),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%r12)
	movq 8(%r12),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $65536,%rsi
	cmpq $0,%rsi
	jnz L106
L104:
	leaq 8(%r12),%rdi
	call _symbol_temp
	movq %rax,%rbx
	movq 24(%r12),%rsi
	movq %rax,%rdi
	call _gen_load
	movq 24(%r12),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $32768,%rsi
	cmpq $0,%rsi
	jz L106
L110:
	movq 24(%r12),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movl $2147483648,%edi
	andq %rdi,%rsi
	cmpq $0,%rsi
	jz L106
L107:
	movq 24(%r12),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rdx
	movq $270582939648,%rsi
	andq %rsi,%rdx
	sarq $32,%rdx
	movq 24(%r12),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movq $34909494181888,%rdi
	andq %rdi,%rsi
	sarq $38,%rsi
	movq %rbx,%rdi
	call _extract
L106:
	cmpl $1,%r13d
	jz L116
L114:
	movq %r12,%rdi
	call _tree_free
L116:
	cmpq $0,%rbx
	jz L118
L117:
	movq %rbx,%rdi
	call _tree_sym
	jmp L103
L118:
	call _tree_v
L103:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L125:
_insert:
L127:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L132:
	movl %edx,%r12d
	movq %rdi,%r15
	movl %ecx,%ebx
	movq %rsi,%r10
	movq %r10,-8(%rbp)
L128:
	movq -8(%rbp),%r10
	leaq 8(%r10),%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _type_sizeof
	movq %rax,%rsi
	leal (,%rsi,8),%esi
	movslq %esi,%rsi
	movl $64,%edi
	subq %rsi,%rdi
	movq $-1,%rsi
	movq %rdi,%rcx
	shrq %cl,%rsi
	movq %rsi,%r14
	movslq %r12d,%rsi
	movl $64,%edi
	subq %rsi,%rdi
	movq $-1,%rsi
	movq %rdi,%rcx
	shrq %cl,%rsi
	movq %rsi,%r13
	movslq %ebx,%rsi
	movq %rsi,%rcx
	shlq %cl,%r13
	movq -8(%rbp),%r10
	leaq 8(%r10),%rsi
	movq %rsi,%rdi
	call _symbol_temp
	movq %rax,%r10
	movq %r10,-16(%rbp)
	movq -8(%rbp),%r10
	leaq 8(%r10),%rsi
	movq %rsi,%rdi
	call _symbol_temp
	movq %rax,%r10
	movq %r10,-24(%rbp)
	movslq %ebx,%rsi
	movl $64,%edi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq -8(%rbp),%r10
	movq %r10,%rdi
	call _operand_leaf
	movq %rax,%r12
	movq -24(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %rbx
	pushq %r12
	pushq %rsi
	pushq $1879048214
	call _insn_new
	addq $32,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq -8(%rbp),%r10
	movq 8(%r10),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	movq %rsi,%rdi
	movq %r13,%rsi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq -24(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%r12
	movq -24(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %rbx
	pushq %r12
	pushq %rsi
	pushq $1880096793
	call _insn_new
	addq $32,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq %r13,%rsi
	notq %rsi
	andq %r14,%rsi
	movq %rsi,%rbx
	movq -16(%rbp),%r10
	movq %r10,%rdi
	movq %r15,%rsi
	call _gen_load
	movq -8(%rbp),%r10
	movq 8(%r10),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	movq %rsi,%rdi
	movq %rbx,%rsi
	movl $0,%edx
	call _operand_i
	movq %rax,%rbx
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%r12
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %rbx
	pushq %r12
	pushq %rsi
	pushq $1880096793
	call _insn_new
	addq $32,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq -24(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rbx
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%r12
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %rbx
	pushq %r12
	pushq %rsi
	pushq $1880096792
	call _insn_new
	addq $32,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq -8(%rbp),%r10
	movq %r10,%rdi
	call _tree_free
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _tree_sym
	movq %rax,%rsi
	movq %rsi,%rax
L129:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L134:
_gen_asg:
L136:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L158:
	movq %rdi,%rbx
L137:
	movq 32(%rbx),%rdi
	movl $0,%esi
	call _gen
	movq %rax,32(%rbx)
	movq 24(%rbx),%rsi
	movl (%rsi),%esi
	cmpl $1073741829,%esi
	jnz L140
L139:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rdi
	movl $0,%esi
	call _gen
	movq 24(%rbx),%rsi
	movq %rax,24(%rsi)
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $32768,%rsi
	cmpq $0,%rsi
	jz L144
L145:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movl $2147483648,%edi
	andq %rdi,%rsi
	cmpq $0,%rsi
	jz L144
L142:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rcx
	movq $270582939648,%rsi
	andq %rsi,%rcx
	sarq $32,%rcx
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rdx
	movq $34909494181888,%rsi
	andq %rsi,%rdx
	sarq $38,%rdx
	movq 32(%rbx),%rsi
	movq 24(%rbx),%rdi
	movq 24(%rdi),%rdi
	call _insert
	movq %rax,32(%rbx)
L144:
	movq 32(%rbx),%rsi
	movq 24(%rbx),%rdi
	movq 24(%rdi),%rdi
	call _gen_store
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $32768,%rsi
	cmpq $0,%rsi
	jz L141
L152:
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movl $2147483648,%edi
	andq %rdi,%rsi
	cmpq $0,%rsi
	jz L141
L149:
	movq 32(%rbx),%rsi
	leaq 8(%rsi),%rdi
	call _symbol_temp
	movq %rax,%r13
	movq 32(%rbx),%rdi
	call _operand_leaf
	movq %rax,%r12
	movq %r13,%rdi
	call _operand_sym
	pushq %r12
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rdx
	movq $270582939648,%rsi
	andq %rsi,%rdx
	sarq $32,%rdx
	movq 24(%rbx),%rsi
	movq 24(%rsi),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movq $34909494181888,%rdi
	andq %rdi,%rsi
	sarq $38,%rsi
	movq %r13,%rdi
	call _extract
	movq 32(%rbx),%rdi
	call _tree_free
	movq %r13,%rdi
	call _tree_sym
	movq %rax,32(%rbx)
	jmp L141
L140:
	movq 32(%rbx),%rdi
	call _operand_leaf
	movq %rax,%r12
	movq 24(%rbx),%rdi
	call _operand_leaf
	pushq %r12
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L141:
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	movq %rax,%rdi
	movl $0,%esi
	call _gen
L138:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L160:
_gen_cast:
L162:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L171:
	movq %rdi,%r13
L163:
	movq 24(%r13),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%r13)
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $1,%rsi
	cmpq $0,%rsi
	jz L166
L165:
	movq %r13,%rdi
	call _tree_free
	call _tree_v
	jmp L164
L166:
	leaq 8(%r13),%rdi
	call _symbol_temp
	movq %rax,%rbx
	movq 24(%r13),%rdi
	call _operand_leaf
	movq %rax,%r12
	movq %rbx,%rdi
	call _operand_sym
	pushq %r12
	pushq %rax
	pushq $1610612748
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq %r13,%rdi
	call _tree_free
	movq %rbx,%rdi
	call _tree_sym
L164:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L173:
_gen_unary:
L175:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L183:
	movq %rdi,%r14
L176:
	movl (%r14),%esi
	cmpl $1082130439,%esi
	jnz L179
L178:
	movl $1610612749,%r13d
	jmp L180
L179:
	movl $1610612750,%r13d
L180:
	movq 24(%r14),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%r14)
	leaq 8(%r14),%rdi
	call _symbol_temp
	movq %rax,%rbx
	movq 24(%r14),%rdi
	call _operand_leaf
	movq %rax,%r12
	movq %rbx,%rdi
	call _operand_sym
	pushq %r12
	pushq %rax
	pushq %r13
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq %r14,%rdi
	call _tree_free
	movq %rbx,%rdi
	call _tree_sym
L177:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L185:
.data
.align 4
_bin:
	.int 1880096791
	.int 1879048211
	.int 1880096786
	.int 1880096784
	.int 1879048209
	.int 1879048213
	.int 1879048214
	.int 1880096793
	.int 1880096792
	.int 1879048212
.text
_gen_binary:
L188:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L193:
	movq %rdi,%r14
L189:
	movq 24(%r14),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%r14)
	movq 32(%r14),%rdi
	movl $0,%esi
	call _gen
	movq %rax,32(%r14)
	leaq 8(%r14),%rdi
	call _symbol_temp
	movq %rax,%r13
	movq 32(%r14),%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq 24(%r14),%rdi
	call _operand_leaf
	movq %rax,%r12
	movq %r13,%rdi
	call _operand_sym
	movl (%r14),%esi
	andl $3840,%esi
	sarl $8,%esi
	movslq %esi,%rsi
	movl _bin(,%rsi,4),%esi
	pushq %rbx
	pushq %r12
	pushq %rax
	pushq %rsi
	call _insn_new
	addq $32,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq %r14,%rdi
	call _tree_free
	movq %r13,%rdi
	call _tree_sym
L190:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L195:
_gen_compound:
L197:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L209:
	movq %rdi,%r12
L198:
	movl (%r12),%esi
	cmpl $805307177,%esi
	setz %sil
	movzbl %sil,%esi
	movl %esi,%r10d
	movl %r10d,-8(%rbp)
	leaq 8(%r12),%rsi
	movq %rsi,%rdi
	call _symbol_temp
	movq %rax,%rdi
	call _tree_sym
	movq %rax,%r15
	movq 32(%r12),%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _gen
	movq %rax,32(%r12)
	movq 24(%r12),%rsi
	movl (%rsi),%esi
	cmpl $2147483650,%esi
	jnz L201
L200:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r15,%rdi
	call _operand_leaf
	pushq %rbx
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq 32(%r12),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%r13
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movl (%r12),%esi
	andl $3840,%esi
	sarl $8,%esi
	movslq %esi,%rsi
	movl _bin(,%rsi,4),%esi
	pushq %r13
	pushq %rbx
	pushq %rax
	pushq %rsi
	call _insn_new
	addq $32,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq %r12,%rdi
	call _tree_chop_binary
	movq %rax,%rbx
	jmp L202
L201:
	movq 24(%r12),%rsi
	movq %rsi,%rdi
	movl $1,%esi
	call _gen_fetch
	movq %rax,%r14
	movq %r14,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r15,%rdi
	call _operand_leaf
	pushq %rbx
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq 32(%r12),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%r13
	movq %r14,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r14,%rdi
	call _operand_leaf
	movl (%r12),%esi
	andl $3840,%esi
	sarl $8,%esi
	movslq %esi,%rsi
	movl _bin(,%rsi,4),%esi
	pushq %r13
	pushq %rbx
	pushq %rax
	pushq %rsi
	call _insn_new
	addq $32,%rsp
	movq %rax,%rsi
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	movq 32(%r12),%rsi
	movq %rsi,%rdi
	call _tree_free
	movq %r14,32(%r12)
	movq %r12,%rdi
	call _gen_asg
	movq %rax,%rbx
L202:
	movl -8(%rbp),%r10d
	cmpl $0,%r10d
	jz L204
L203:
	movq %rbx,%rdi
	call _tree_free
	movq %r15,%rax
	jmp L199
L204:
	movq %r15,%rdi
	call _tree_free
	movq %rbx,%rax
L199:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L211:
_gen_rel:
L213:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L253:
	movq %rdi,%rbx
L214:
	leaq 8(%rbx),%rdi
	call _symbol_temp
	movq %rax,%r14
	movq 24(%rbx),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%rbx)
	movq 32(%rbx),%rdi
	movl $0,%esi
	call _gen
	movq %rax,32(%rbx)
	movq 32(%rbx),%rdi
	call _operand_leaf
	movq %rax,%r13
	movq 24(%rbx),%rdi
	call _operand_leaf
	pushq %r13
	pushq %rax
	pushq $872415247
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movl (%rbx),%esi
L246:
	cmpl $33554458,%esi
	jz L224
L247:
	cmpl $33554460,%esi
	jz L234
L248:
	cmpl $33554461,%esi
	jz L229
L249:
	cmpl $33554463,%esi
	jz L239
L250:
	cmpl $637534242,%esi
	jz L220
L251:
	cmpl $637534243,%esi
	jnz L218
L222:
	movl $1,%r12d
	jmp L218
L220:
	movl $0,%r12d
	jmp L218
L239:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L241
L240:
	movl $3,%r12d
	jmp L218
L241:
	movl $7,%r12d
	jmp L218
L229:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L231
L230:
	movl $5,%r12d
	jmp L218
L231:
	movl $9,%r12d
	jmp L218
L234:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L236
L235:
	movl $4,%r12d
	jmp L218
L236:
	movl $8,%r12d
	jmp L218
L224:
	movq 24(%rbx),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $340,%rsi
	cmpq $0,%rsi
	jz L226
L225:
	movl $2,%r12d
	jmp L218
L226:
	movl $6,%r12d
L218:
	movq %r14,%rdi
	call _operand_sym
	leal 1216872474(%r12),%esi
	pushq %rax
	pushq %rsi
	call _insn_new
	addq $16,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
	movq %rbx,%rdi
	call _tree_free
	movq %r14,%rdi
	call _tree_sym
L215:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret
L255:
_gen_log:
L257:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L265:
	movq %rdi,%r10
	movq %r10,-8(%rbp)
L258:
	movq -8(%rbp),%r10
	leaq 8(%r10),%rsi
	movq %rsi,%rdi
	call _symbol_temp
	movq %rax,%r10
	movq %r10,-16(%rbp)
	movq -16(%rbp),%r10
	movq %r10,%r11
	movq %r11,-24(%rbp)
	call _block_new
	movq %rax,%rsi
	movq %rsi,%r10
	movq %r10,-32(%rbp)
	call _block_new
	movq %rax,%r10
	movq %r10,-40(%rbp)
	movq -40(%rbp),%r10
	movq %r10,%r11
	movq %r11,-48(%rbp)
	call _block_new
	movq %rax,%r15
	movq %r15,%r14
	call _block_new
	movq %rax,%r13
	movq %r13,%rbx
	movl $64,%edi
	movl $1,%esi
	movl $0,%edx
	call _operand_i
	movq %rax,%r12
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %r12
	pushq %rsi
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	movq -40(%rbp),%r10
	leaq 8(%r10),%rdi
	call _insn_append
	movl $64,%edi
	movl $0,%esi
	movl $0,%edx
	call _operand_i
	movq %rax,%r12
	movq -16(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %r12
	pushq %rsi
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	leaq 8(%r15),%rdi
	call _insn_append
	movq -40(%rbp),%r10
	movq %r10,%rdi
	movl $10,%esi
	movq %r13,%rdx
	call _block_add_successor
	movq %r15,%rdi
	movl $10,%esi
	movq %r13,%rdx
	call _block_add_successor
	movq -8(%rbp),%r10
	movq 24(%r10),%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _gen
	movq %rax,%rsi
	movq -8(%rbp),%r10
	movq %rsi,24(%r10)
	movq -8(%rbp),%r10
	movl (%r10),%esi
	cmpl $184549413,%esi
	jnz L261
L260:
	movq -8(%rbp),%r10
	movq 24(%r10),%rsi
	movq %rsi,%rdi
	movq -48(%rbp),%r10
	movq %r10,%rsi
	movq -32(%rbp),%r10
	movq %r10,%rdx
	call _gen_branch
	jmp L262
L261:
	movq -8(%rbp),%r10
	movq 24(%r10),%rsi
	movq %rsi,%rdi
	movq -32(%rbp),%r10
	movq %r10,%rsi
	movq %r14,%rdx
	call _gen_branch
L262:
	movq -32(%rbp),%r10
	movq %r10,_current_block(%rip)
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _gen
	movq %rax,%rsi
	movq -8(%rbp),%r10
	movq %rsi,32(%r10)
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq %rsi,%rdi
	movq -48(%rbp),%r10
	movq %r10,%rsi
	movq %r14,%rdx
	call _gen_branch
	movq %rbx,_current_block(%rip)
	movq -8(%rbp),%r10
	movq %r10,%rdi
	call _tree_free
	movq -24(%rbp),%r10
	movq %r10,%rdi
	call _tree_sym
	movq %rax,%rsi
	movq %rsi,%rax
L259:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L267:
_gen_quest:
L269:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L286:
	movq %rdi,%r10
	movq %r10,-8(%rbp)
L270:
	movq -8(%rbp),%r10
	movq 8(%r10),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $1,%rsi
	cmpq $0,%rsi
	jz L273
L272:
	movl $0,%r15d
	jmp L274
L273:
	movq -8(%rbp),%r10
	leaq 8(%r10),%rdi
	call _symbol_temp
	movq %rax,%r15
L274:
	call _block_new
	movq %rax,%rbx
	call _block_new
	movq %rax,%r12
	movq %r12,%r13
	call _block_new
	movq %rax,%r14
	movq -8(%rbp),%r10
	movq 24(%r10),%rdi
	movl $0,%esi
	call _gen
	movq -8(%rbp),%r10
	movq %rax,24(%r10)
	movq -8(%rbp),%r10
	movq 24(%r10),%rdi
	movq %rbx,%rsi
	movq %r12,%rdx
	call _gen_branch
	movq %rbx,_current_block(%rip)
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq 24(%rsi),%rdi
	movl $0,%esi
	call _gen
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq %rax,24(%rsi)
	cmpq $0,%r15
	jz L277
L275:
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq 24(%rsi),%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r15,%rdi
	call _operand_sym
	pushq %rbx
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L277:
	movq _current_block(%rip),%rdi
	movl $10,%esi
	movq %r14,%rdx
	call _block_add_successor
	movq %r13,_current_block(%rip)
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq 32(%rsi),%rdi
	movl $0,%esi
	call _gen
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq %rax,32(%rsi)
	cmpq $0,%r15
	jz L280
L278:
	movq -8(%rbp),%r10
	movq 32(%r10),%rsi
	movq 32(%rsi),%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq %r15,%rdi
	call _operand_sym
	pushq %rbx
	pushq %rax
	pushq $1611137035
	call _insn_new
	addq $24,%rsp
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rdi
	movq %rax,%rsi
	call _insn_append
L280:
	movq _current_block(%rip),%rdi
	movl $10,%esi
	movq %r14,%rdx
	call _block_add_successor
	movq %r14,_current_block(%rip)
	movq -8(%rbp),%r10
	movq %r10,%rdi
	call _tree_free
	cmpq $0,%r15
	jz L282
L281:
	movq %r15,%rdi
	call _tree_sym
	jmp L271
L282:
	call _tree_v
L271:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L288:
_gen_comma:
L290:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
L295:
	movq %rdi,%rbx
L291:
	movq 24(%rbx),%rdi
	movl $0,%esi
	call _gen
	movq %rax,24(%rbx)
	movq %rbx,%rdi
	call _tree_commute
	movq %rbx,%rdi
	call _tree_chop_binary
	movq %rax,%rdi
	movl $0,%esi
	call _gen
L292:
	popq %rbx
	popq %rbp
	ret
L297:
_gen_call:
L299:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L352:
	movq %rdi,%r13
L305:
	movq $0,-24(%rbp)
	leaq -24(%rbp),%rsi
	movq %rsi,-16(%rbp)
	movl $2,-8(%rbp)
	movq 24(%r13),%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _gen
	movq %rax,%rsi
	movq %rsi,24(%r13)
	movq 24(%r13),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $32768,%rsi
	cmpq $0,%rsi
	jz L309
L315:
	movq 24(%r13),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	andq $16384,%rsi
	cmpq $0,%rsi
	jz L309
L311:
	movq 24(%r13),%rsi
	movq 8(%rsi),%rsi
	movq 16(%rsi),%rsi
	movq (%rsi),%rsi
	movq $-9223372036854775808,%rdi
	andq %rdi,%rsi
	cmpq $0,%rsi
	jz L309
L308:
	movl $539230216,%esi
	jmp L310
L309:
	movl $539230215,%esi
L310:
	movl %esi,%r15d
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $1,%rsi
	cmpq $0,%rsi
	jz L320
L319:
	call _tree_v
	movq %rax,%rsi
	movq %rsi,%r10
	movq %r10,-32(%rbp)
	jmp L321
L320:
	leaq 8(%r13),%rsi
	movq %rsi,%rdi
	call _symbol_temp
	movq %rax,%rsi
	movq %rsi,%r10
	movq %r10,-40(%rbp)
	movq %rsi,%rdi
	call _tree_sym
	movq %rax,%rsi
	movq %rsi,%r10
	movq %r10,-32(%rbp)
L321:
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $65536,%rsi
	cmpq $0,%rsi
	jz L331
L322:
	movq -40(%rbp),%r10
	movq %r10,%rdi
	call _tree_sym
	movq %rax,%rsi
	movq %rsi,%rdi
	call _tree_addrof
	movq %rax,%rsi
	movq 32(%r13),%rdi
	movq %rdi,48(%rsi)
	cmpq $0,%rdi
	jz L329
L328:
	leaq 48(%rsi),%rdi
	movq 32(%r13),%rax
	movq %rdi,56(%rax)
	jmp L330
L329:
	leaq 48(%rsi),%rdi
	movq %rdi,40(%r13)
L330:
	movq %rsi,32(%r13)
	leaq 32(%r13),%rdi
	movq %rdi,56(%rsi)
L331:
	movq 40(%r13),%rsi
	movq 8(%rsi),%rsi
	movq (%rsi),%rsi
	movq %rsi,%rbx
	cmpq $0,%rsi
	jz L333
L334:
	movq 48(%rbx),%rsi
	cmpq $0,%rsi
	jz L338
L337:
	movq 56(%rbx),%rsi
	movq 48(%rbx),%rdi
	movq %rsi,56(%rdi)
	jmp L339
L338:
	movq 56(%rbx),%rsi
	movq %rsi,40(%r13)
L339:
	movq 48(%rbx),%rsi
	movq 56(%rbx),%rdi
	movq %rsi,(%rdi)
	movq 8(%rbx),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $65536,%rsi
	cmpq $0,%rsi
	jz L341
L340:
	leaq 8(%rbx),%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _type_sizeof
	movq %rax,%r14
	movq %rbx,%rdi
	call _tree_addrof
	movq %rax,%rsi
	movq %rsi,%rdi
	movl $0,%esi
	call _gen
	movq %rax,%r12
	movq %r12,%rbx
	movq _target(%rip),%rsi
	movq 16(%rsi),%rsi
	movq %rsi,%rdi
	movq %r14,%rsi
	movl $0,%edx
	call _operand_i
	movq %rax,%r14
	movq %r12,%rdi
	call _operand_leaf
	movq %rax,%rsi
	pushq %r14
	pushq %rsi
	pushq $807665673
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	leaq -24(%rbp),%rdi
	call _insn_prepend
	jmp L342
L341:
	movq %rbx,%rdi
	movl $0,%esi
	call _gen
	movq %rax,%rsi
	movq %rsi,%rbx
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%rsi
	pushq %rsi
	pushq %r15
	call _insn_new
	addq $16,%rsp
	movq %rax,%rsi
	leaq -24(%rbp),%rdi
	call _insn_prepend
L342:
	movq %rbx,%rdi
	call _tree_free
	jmp L331
L333:
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $1,%rsi
	cmpq $0,%rsi
	jnz L343
L346:
	movq 8(%r13),%rsi
	movq (%rsi),%rsi
	andq $131071,%rsi
	andq $65536,%rsi
	cmpq $0,%rsi
	jz L344
L343:
	movq 24(%r13),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%rsi
	pushq %rsi
	pushq $0
	pushq $1730150406
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	movq %rsi,%rbx
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
	jmp L345
L344:
	movq 24(%r13),%rsi
	movq %rsi,%rdi
	call _operand_leaf
	movq %rax,%rbx
	movq -40(%rbp),%r10
	movq %r10,%rdi
	call _operand_sym
	movq %rax,%rsi
	pushq %rbx
	pushq %rsi
	pushq $1730150406
	call _insn_new
	addq $24,%rsp
	movq %rax,%rsi
	movq %rsi,%rbx
	movq _current_block(%rip),%rdi
	leaq 8(%rdi),%rdi
	call _insn_append
L345:
	leaq -24(%rbp),%rax
	movq _current_block(%rip),%rsi
	leaq 8(%rsi),%rsi
	movq %rsi,%rdi
	movq %rbx,%rsi
	movq %rax,%rdx
	call _insns_insert_before
	movq %r13,%rdi
	call _tree_free
	movq -32(%rbp),%r10
	movq %r10,%rax
L301:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret
L354:
_gen:
L355:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L510:
	movl %esi,%r12d
	movq %rdi,%rbx
L356:
	movl %r12d,%esi
	andl $1,%esi
	cmpl $0,%esi
	jz L360
L358:
	movq %rbx,%rdi
	call _tree_rewrite_volatile
	movq %rax,%rdi
	call _tree_opt
	movq %rax,%rdi
	call _tree_simplify
	movq %rax,%rbx
	movl _debug_flag_e(%rip),%esi
	cmpl $0,%esi
	jz L360
L361:
	movq %rbx,%rdi
	movl $0,%esi
	call _tree_debug
L360:
	movl (%rbx),%esi
L430:
	cmpl $184549413,%esi
	jz L422
	jb L431
L471:
	cmpl $805307177,%esi
	jz L412
	jb L472
L492:
	cmpl $1073741830,%esi
	jz L368
	jb L493
L502:
	cmpl $1082130441,%esi
	jz L387
	jb L503
L506:
	cmpl $-2147483648,%esi
	jmp L366
L503:
	cmpl $1082130439,%esi
	jnz L366
L387:
	movq %rbx,%rdi
	call _gen_unary
	movq %rax,%rbx
	jmp L366
L493:
	cmpl $1073741828,%esi
	jz L372
	jb L494
L499:
	cmpl $1073741829,%esi
	jnz L366
L374:
	movq %rbx,%rdi
	movl $0,%esi
	call _gen_fetch
	movq %rax,%rbx
	jmp L366
L494:
	cmpl $1073741827,%esi
	jz L380
	ja L366
L495:
	cmpl $813695768,%esi
	jz L398
	jnz L366
L380:
	movq %rbx,%rdi
	call _gen_call
	movq %rax,%rbx
	jmp L366
L372:
	movq %rbx,%rdi
	call _gen_cast
	movq %rax,%rbx
	jmp L366
L368:
	movq %rbx,%rdi
	call _gen_addrof
	movq %rax,%rbx
	jmp L366
L472:
	cmpl $545259541,%esi
	jz L398
	jb L473
L482:
	cmpl $545261604,%esi
	jz L398
	jb L483
L488:
	cmpl $637534242,%esi
	jb L366
L491:
	cmpl $637534243,%esi
	jbe L419
	ja L366
L483:
	cmpl $545261344,%esi
	jz L398
	ja L366
L484:
	cmpl $545260055,%esi
	jz L398
	jnz L366
L473:
	cmpl $402653966,%esi
	jz L412
	jb L474
L479:
	cmpl $402654223,%esi
	jz L412
	jnz L366
L474:
	cmpl $276825113,%esi
	jz L398
	ja L366
L475:
	cmpl $201326602,%esi
	jnz L366
L400:
	movq %rbx,%rdi
	call _gen_asg
	movq %rax,%rbx
	jmp L366
L431:
	cmpl $134217996,%esi
	jz L412
	jb L432
L452:
	cmpl $134219294,%esi
	jz L398
	jb L453
L462:
	cmpl $134220045,%esi
	jz L412
	jb L463
L468:
	cmpl $184549409,%esi
	jz L422
	jnz L366
L463:
	cmpl $134219795,%esi
	jz L412
	ja L366
L464:
	cmpl $134219538,%esi
	jz L412
	jnz L366
L453:
	cmpl $134219035,%esi
	jz L398
	jb L454
L459:
	cmpl $134219280,%esi
	jz L412
	jnz L366
L454:
	cmpl $134219025,%esi
	jz L412
	ja L366
L455:
	cmpl $134218251,%esi
	jz L412
	jnz L366
L432:
	cmpl $2342,%esi
	jz L398
	jb L433
L442:
	cmpl $33554463,%esi
	jz L419
	jb L443
L449:
	cmpl $134217748,%esi
	jz L412
	jnz L366
L443:
	cmpl $33554460,%esi
	jae L448
L444:
	cmpl $33554458,%esi
	jz L419
	jnz L366
L448:
	cmpl $33554461,%esi
	ja L366
L419:
	movq %rbx,%rdi
	call _gen_rel
	movq %rax,%rbx
	jmp L366
L433:
	cmpl $43,%esi
	jz L370
	jb L434
L439:
	cmpl $278,%esi
	jz L398
	jnz L366
L434:
	cmpl $42,%esi
	jz L378
	ja L366
L435:
	cmpl $39,%esi
	jnz L366
L376:
	movq %rbx,%rdi
	call _gen_quest
	movq %rax,%rbx
	jmp L366
L378:
	movq %rbx,%rdi
	call _gen_comma
	movq %rax,%rbx
	jmp L366
L370:
	movq %rbx,%rdi
	call _gen_blkasg
	movq %rax,%rbx
	jmp L366
L398:
	movq %rbx,%rdi
	call _gen_binary
	movq %rax,%rbx
	jmp L366
L412:
	movq %rbx,%rdi
	call _gen_compound
	movq %rax,%rbx
	jmp L366
L422:
	movq %rbx,%rdi
	call _gen_log
	movq %rax,%rbx
L366:
	andl $2,%r12d
	cmpl $0,%r12d
	jz L425
L424:
	movq %rbx,%rdi
	call _tree_free
	movl $0,%eax
	jmp L357
L425:
	movq %rbx,%rax
L357:
	popq %r12
	popq %rbx
	popq %rbp
	ret
L512:
.globl _symbol_temp
.globl _block_always_successor
.globl _block_add_successor
.globl _gen_args
.globl _scope_walk_args
.globl _target
.globl _insn_prepend
.globl _insn_append
.globl _tree_rewrite_volatile
.globl _tree_commute
.globl _insns_insert_before
.globl _tree_v
.globl _block_new
.globl _insn_new
.globl _tree_opt
.globl _tree_free
.globl _block_split_edge
.globl _symbol_storage
.globl _debug_flag_e
.globl _tree_addrof
.globl _operand_leaf
.globl _type_sizeof
.globl _tree_debug
.globl _operand_reg
.globl _symbol_reg
.globl _symbol_temp_reg
.globl _gen_branch
.globl _tree_simplify
.globl _tree_chop_binary
.globl _operand_i
.globl _current_block
.globl _entry_block
.globl _tree_sym
.globl _operand_sym
.globl _gen
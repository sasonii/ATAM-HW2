.globl my_ili_handler
.extern what_to_do, old_ili_handler

.text
.align 4, 0x90
my_ili_handler:
	####### Some smart student's code here #######
  
	# backup regs
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx	
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rsi
	pushq %rbp
	pushq %rsp

	xorq %rdi, %rdi
	xorq %rax, %rax
	xorq %rcx, %rcx
	movq 120(%rsp),%rcx # getting rip
	movq (%rcx), %rcx   # getting opcode
	cmpb $0x0f, %cl     # checking first byte.
	jne one_byte_func

	# calling what_to_do with second byte.
	movb %ch, %al
	movq %rax, %rdi
	call what_to_do
	cmpq $0, %rax
	je old_handler
	addq $2, 120(%rsp)
	jmp new_handler

one_byte_func:
	# calling what_to_do with first byte.
	movb %cl, %al
	movq %rax, %rdi
	call what_to_do
	cmpq $0, %rax
	je old_handler
	addq $1, 120(%rsp)
	jmp new_handler

old_handler:
	# restore regs
	popq %rsp
	popq %rbp
	popq %rsi
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax

  jmp * old_ili_handler
  jmp end_func

new_handler:
	movq %rax, %rdi # return value of what_to_do.
  
	# restore regs
	popq %rsp
	popq %rbp
	popq %rsi
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax 
	
end_func:
	iretq

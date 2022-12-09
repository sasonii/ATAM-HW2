.global count_above

.section .text
count_above:
	push %rbp
    movq %rsp,%rbp
	#1 - FILE OPENING 
	pushq %rdi # separator
	pushq %rsi # limit
	
	# getting pointer to path into RAX
	call get_path	
	
	# sys_open
	movq %rax, %rdi # first param - pointer to path
	xor %rsi, %rsi # open for reading only
	mov $2, %rax # sys_open
	syscall  # getting descriptor into RAX
	
	# read file
	popq %rsi # separator
	popq %rdi # limit
	call read_file_func
	
	# rax holds number of words
	leave
	ret
	
read_file_func:
	push %rbp
    movq %rsp,%rbp
	
	# getting params
	mov %rdi, %r12 # separator
	mov %rsi, %r13 # limit
	
	# setting place for chars in the stack
	xor %rbx, %rbx
	
	xor %r8, %r8 #holds number of numbers greater than limit
	movq %rax, %rdi # first param - file descriptor
read_word:
	# setting place for chars in the stack
	mov %rsp, %r15
	sub $25, %rsp	

	# setting vars
	xor %r9, %r9 #holds the number 
	xor %r10, %r10 # holds whether the number is negative
	
read_char:
	# sys_read
	
	movq %rsp, %rsi # second param - pointer to array
	movq $1, %rdx  # third param - number of chars to read
	mov $0, %rax # sys_read
	syscall # ??? save file descriptor restore file descriptor ???
	
	
	cmpb $0x00, (%rsp)
	je end_of_file
	
	cmpb %r12b, (%rsp)	
	je end_of_word

	add $1, %rsp
	jmp read_char
	
end_of_word:
	# insert null terminator
	movb $0x00, (%rsp)
	
	# get number from chars
	
	#restore rsp for next word
	mov %r15, %rsp
	
	# save regs
	pushq %rdi 
	pushq %r8
	pushq %r9
	pushq %r10
	
	# call atam_atol with regs
	movq %rsp, %rdi
	sub $25, %rdi
	call atam_atol
	
	# restore regs
	popq %r10
	popq %r9
	popq %r8
	popq %rdi 
	
	# check number 
	cmpl %eax, %r9d
	jle read_word
	inc %r8
	jmp read_word
	
end_of_file:
	# insert null terminator
	movb $0x00, (%rsp)
	
	# get number from chars
	
	#restore rsp for next word
	mov %rsp, %r15
	
	# save regs
	pushq %rdi 
	pushq %r8
	pushq %r9
	pushq %r10
	
	# call atam_atol with regs
	movq %rsp, %rdi
	sub $25, %rdi
	call atam_atol
	
	# restore regs
	popq %r10
	popq %r9
	popq %r8
	popq %rdi 
	
	# check number
	cmpl %eax, %r9d
	jle end_of_file_continue
	inc %r8	
	
end_of_file_continue:	
		
	#sys_close
	mov $3, %rax # sys_read
	syscall # note that rdi holds file descriptor
	
	movq %r8, %rax  # return number of numbers greater than limit
	leave
	ret



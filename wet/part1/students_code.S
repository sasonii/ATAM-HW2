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

read_word:
	
	
	# setting place for chars in the stack
	pushq %rsp
	sub $20, %rsp	

	# setting vars
	xor %r9, %r9 #holds the number 
	xor %r10, %r10 # holds whether the number is negative
	
read_char:
	# sys_read
	movq %rax, %rdi # first param - file descriptor
	movq %rsp, %rsi # second param - pointer to array
	movq $1, %rdx  # third param - number of chars to read
	mov $0, %rax # sys_read
	syscall # ??? save file descriptor restore file descriptor ???
	
	# SYS_LSEEK - NOTE: rdi holds fd
	mov     $19, %rax # SYS_LSEEK
	mov     $1, %rsi 
	mov     $1, %rdx   # offset should be from the current position
	syscall
	
	add $1, %rsp
	
	cmpb $0x00, %r14b
	je end_of_file
	
	cmpb %r12b, %r14b
	je end_of_word
	
	jmp read_char
	
end_of_word:
	# insert null terminator
	sub $1, %rsp
	movb $0x00, (%rsp)
	
	# get number from chars
	
	#restore rsp for next word
	popq %rsp
	
	# save regs
	pushq %rdi 
	pushq %r8
	pushq %r9
	pushq %r10
	
	# call atam_atol with regs
	movq %rsp, %rdi
	sub $20, %rdi
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
	sub $1, %rspb
	movb $0x00, (%rsp)
	
	# get number from chars
	
	#restore rsp for next word
	popq %rsp
	
	# save regs
	pushq %rdi 
	pushq %r8
	pushq %r9
	pushq %r10
	
	# call atam_atol with regs
	movq %rsp, %rdi
	sub $20, %rdi
	call atam_atol
	
	# restore regs
	pushq %r10
	pushq %r9
	pushq %r8
	popq %rdi 
	
	# check number
	cmpl %eax, %r9d
	jle end_of_file_continue
	inc %r8	
	
end_of_file_continue:	
	# SYS_LSEEK - NOTE: rdi holds fd
	mov     $19, %rax # SYS_LSEEK
	mov     $0, %rsi 
	mov     $0, %rdx   # offset should be from the current position
	syscall	
	
	#sys_close
	mov $3, %rax # sys_read
	syscall # note that rdi holds file descriptor
	
	movq %r8, %rax  # return number of numbers greater than limit
	leave
	ret



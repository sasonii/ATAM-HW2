.global count_above

.section .text
count_above:
	#1 - FILE OPENING 
	
	# getting pointer to path into RAX
	call get_path	
	
	# sys_open
	movq %rax, %rdi # first param - pointer to path
	xor %rsi, %rsi # open for reading only
	mov $2, %rax # sys_open
	syscall  # getting descriptor into RAX
	
	# setting place for chars in the stack
	xor %rbx, %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	pushq %rbx
	
	#sys_read
	movq %rax, %rdi # first param - file descriptor
	movq %esp, %rsi # second param - pointer to array
	movq $19, $rdx  # third param - number of chars to read
	mov $0, %rax # sys_read
	pushq %rdi # save file descriptor
	syscall
	popq %rdi # restore file descriptor
	
	#sys_close
	mov $3, %rax # sys_read
	syscall #note that rdi holds file descriptor
	
	
	ret



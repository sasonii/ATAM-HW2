.global main
.section .data
A:  .long 3
    .quad B
    .quad C
    .quad D
    .quad 0
B:  .long 10
    .quad E
    .quad F
    .quad 0
C:  .long 22
    .quad 0
D:  .long 17
    .quad G
    .quad 0
E:  .long 85
    .quad 0
F:  .long 2
    .quad 0
G:  .long 8
    .quad 0
.section .text
main:
    mov $17, %esi
    mov $A, %rdi
    call func
    movq $1, %rdi
    sub %rax, %rdi
    movq $60, %rax
    syscall
    
func: 
    push %rbp
    movq %rsp, %rbp
    movl (%rdi), %r11d
    cmpl %esi, (%rdi)
    jne next
    mov $1, %rax
    jmp end

next:
    mov $0, %r10
test:
    cmpq $0, 4(%rdi, %r10, 8)
    je fail
    push %rdi
    push %r10
    mov 4(%rdi, %r10, 8), %rdi
    call func
    pop %r10
    pop %rdi
    cmpq $0, %rax
    jne finish
    inc %r10
    jmp test

finish: 
    mov $1, %rax
    jmp end
    
fail: 
    mov $0, %rax
    
end: 
    leave 
    ret


    









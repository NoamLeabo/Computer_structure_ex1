.extern printf
.extern scanf
.extern pstrlen
.extern swapCase
.extern pstrijcpy

.section .rodata
print_invalidation_msg:
    .string "invalid option!\n"

print_invalidInp_msg:
    .string "invalid input!\n"

print_lengthes_31:
    .string "first pstring length: %d, second pstring length: %d\n"

print_lengthANDstring_33_34:
    .string "length: %d, string: %s\n"

scanf_fmt:
    .string "%d %d"
    

.section .text

.globl run_func

.type	run_func, @function 

run_func:
    # Enter
    pushq %rbp
    movq %rsp, %rbp  

    # we check which Func to activate 
    movl %edi, %eax
    # 31 -> Func pstrlen
    cmp $31, %eax
    je .f1
    # 33 -> Func swapCase
    cmp $33, %eax
    je .f2
    # 34 -> Func pstrijcpy
    cmp $34, %eax
    je .f3
    # any other input is a wrong option!
    jmp .error

.f1:
    # we save a pointer to the second struct 
    movq %rdx, %r15
    # we set the args and call the Func
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen
    movzbq %al, %r14

    movq %r15, %rdi
    xorq %rax, %rax
    call pstrlen
    movzbq %al, %r15

    movq $print_lengthes_31, %rdi
    movq %r14, %rsi
    movq %r15, %rdx
    xorq %rax, %rax
    call printf

    # we exit from the Prog
    jmp .exit

.f2:
    # we save a pointer to the second struct 
    movq %rdx, %r15
    # we set the arg and call the Func
    movq %rsi, %rdi
    xorq %rax, %rax
    call swapCase 

    # we print the res of the Func over the first struct
    movq $print_lengthANDstring_33_34, %rdi
    # the length of the string is in the first byte
    movzbq (%rax), %rsi

    # now %rax is pointing on the string
    incq %rax
    # setting the 3rd arg
    movq %rax, %rdx
    xorq %rax, %rax
    # we print the result
    call printf

    # we set the args and call the Func
    movq %r15, %rdi
    xorq %rax, %rax
    call swapCase 

    # we print the res of the Func over the first struct
    movq $print_lengthANDstring_33_34, %rdi
    # the length of the string is in the first byte
    movzbq (%rax), %rsi

    # now %rax is pointing on the string
    incq %rax
    # setting the 3rd arg
    movq %rax, %rdx
    xorq %rax, %rax
    # we print the result
    call printf

    # we exit from the Prog
    jmp .exit

.f3:
    # we save the src and struct so we'll be able to send them to the Func and print them at the end
    movq %rsi, %r14
    movq %rdx, %r15

    # we allocate memory in the stacl
    sub $16, %rsp

    # we get the 'i' (rsp) and 'j' (rsp+8) value
    movq $scanf_fmt, %rdi
    movq %rsp, %rsi
    leaq 8(%rsp), %rdx
    xorq %rax, %rax
    call scanf # scanf("%d %d", rsp, rsp + 8)

    # we send the Func the args - rdi = dst, rsi = src, rdx = i, rcx = j
    movq %r14, %rdi
    movq %r15, %rsi
    movq (%rsp), %rdx
    movq 8(%rsp), %rcx
    xorq %rax, %rax
    # we call the Func
    call pstrijcpy 
    # we check if we've had an error
    cmpb $-1, %al
    # we print so
    je .inavInput

    # we print the res of the Func 
    movq $print_lengthANDstring_33_34, %rdi
    # the length of the string is in the first byte
    movzbq (%rax), %rsi

    # now %rax is pointing on the string
    incq %rax
    # setting the 3rd arg
    movq %rax, %rdx
    xorq %rax, %rax
    # we print the result
    call printf

    # now we now shall print the other string (src)
    movq %r15, %rax

    movq $print_lengthANDstring_33_34, %rdi
    # the length of the string is in the first byte
    movzbq (%rax), %rsi

    # now %rax is pointing on the string
    incq %rax
    # setting the 3rd arg
    movq %rax, %rdx
    xorq %rax, %rax
    # we print the result
    call printf

    # we exit from the Prog
    jmp .exit

.inavInput:
    # we print invalidation input
    movq $print_invalidInp_msg, %rdi
    xorq %rax, %rax
    call printf
    # we exit from the Prog
    jmp .exit


.error:
    # we print invalidation option
    movq $print_invalidation_msg, %rdi
    xorq %rax, %rax
    call printf
    # we exit from the Prog
    jmp .exit

.exit:    
    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

/* 325764215 Noam Leabovich */

.section .rodata
print_first_length_msg:
    .string "first pstring length: %d, "
print_sec_length_msg:
    .string "second pstring length: %d\n"    
print_lengthSolo_msg:
    .string "first pstring length: %d, "
print_stringSolo_msg:
    .string "string: %s\n"
print_invalidation_msg:
    .string "invalid input!\n"
    
.section .text

###################################

.globl pstrlen
.type	pstrlen, @function 

pstrlen:
    # Enter
    pushq %rbp
    movq %rsp, %rbp  

    # we save the first Byte which is the length in a register
    movb (%rdi), %al
   
    # the return routine
    movq %rbp, %rsp
    popq %rbp
    ret

###################################

.globl swapCase
.type	swapCase, @function 

swapCase:
    #enter
    pushq %rbp
    movq %rsp, %rbp  

    # we save a poninter to the start of the struct
    movq %rdi, %r11
    # we take one step foward with %rdi
    incq %rdi


.loop:
    # we save the first char of the string
    movzbq (%rdi), %rax
    # If we're at the end of the string, we move to the return section
    cmpb $0x0, %al
    je .done
    
    # chekck if the char is a CapL
    cmpb $90, %al
    # not a CapL
    ja .caseB
    # capL
    jmp .caseA

# the char is CapL
.caseA:
    # we check if the char is even a letter
    cmp $64, %al
    # we go to the next char if it is not a letter
    jna .next
    # we add 32 to the val so we get the smallL version of the current letter
    leaq 32(%rax), %rbx
    movb %bl ,(%rdi)
    # we move on to the next char
    jmp .next

# the char is not CapL
.caseB: 
    # we check if the char is even a letter
    cmp $96, %al
    # we go to the next char if it is not a letter
    jna .next
    # we check if the char is even a letter
    cmp $122, %al
    # we go to the next char if it is not a letter
    ja .next
    # we subtruct 32 from the val so we get the CapL version of the current letter
    leaq -32(%rax), %rbx
    movb %bl ,(%rdi)
    # we move on to the next char
    jmp .next

.next:
    # we move the pointer one step-F
    incq %rdi
    # we return to the loop
    jmp .loop

.done:
    # we set the return value in %rax
    movq %r11, %rax

    # the return routine
    movq %rbp, %rsp
    popq %rbp
    ret

###################################

.globl pstrijcpy
.type	pstrijcpy, @function 

pstrijcpy:
    #enter
    pushq %rbp
    movq %rsp, %rbp  

    # we save a poninter to the args

    # dst - %rdi
    movq %rdi, %r12
    
    # src - %rsi
    # i - %dl
    # j - %cl
    
    

    # check If j < i
    cmpb %dl, %cl
    jb .error

    # check If str1.len  <= i
    cmpb (%rdi), %dl
    jae .error

    # check If str2.len  <= i
    cmpb (%rsi), %dl
    jae .error

    # check If str1.len  <= j
    cmpb (%rdi), %cl
    jae .error

    # check If str2.len  <= j
    cmpb (%rsi), %cl
    jae .error
    

    # we take one step foward with %rdi and %rsi so they point on the strings
    incq %rdi
    incq %rsi

.floop:
    # we calibrate the index i so it will be 0 when the pointers point on the index OG-i
    cmpb $0, %dl
    ja .nextDec

.sloop:
    # check If j < i because this is whem we stop copying
    cmpb %dl, %cl
    jb .finish
    # we copy the char from one string to another
    movzbq (%rsi), %rax
    movb %al, (%rdi)
    # we continue to the next char
    jmp .nextChar


.nextChar:
    # we increase the value of i
    incb %dl
    # we move the pointer one step-F
    incq %rdi
    incq %rsi
    # we return to the second loop
    jmp .sloop

.nextDec:
    decb %cl
    decb %dl
    # we move the pointer one step-F
    incq %rdi
    incq %rsi
    # we return to the first loop
    jmp .floop

.error:
    # we indicate that there is an error by returning -1
    movq $-1, %rax
    
    # the return routine
    movq %rbp, %rsp
    popq %rbp
    ret

.finish:
    # we set the return value in %rax
    movq %r12, %rax

    # the return routine
    movq %rbp, %rsp
    popq %rbp
    ret

###################################

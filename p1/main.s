/* 325764215 Noam Leabovich */

.extern printf
.extern scanf
.extern rand_num

.section .data
user_seed:
    .space 4, 0x0

user_guess:
    .space 4, 0x0

rand_num: 
    .space 4, 0x0

guesses_left:
    .space 4, 0x0

.section .rodata
user_enter_seed_msg:
    .string "Enter configuration seed: "

user_pls_guess_msg:
    .string "What is your guess? "

user_incorrect_msg:
    .string "Incorrect.\n"

user_loser_msg:
    .string "Game over, you lost :(. The correct answer was %d\n"

user_winner_msg:
    .string "Congratz! You won!\n"

scanf_fmt:
    .string "%255d"

.section .text
.globl main
.type	main, @function 

main:
    # Enter
    pushq %rbp
    movq %rsp, %rbp  

    # Print "enter a seed"
    movq $user_enter_seed_msg, %rdi
    xorq %rax, %rax
    call printf

    # Read the confg seed
    movq $scanf_fmt, %rdi
    movq $user_seed, %rsi
    xorq %rax, %rax
    call scanf

    # re-setting srand
    movq user_seed, %rdi
    xorq %rax, %rax
    call srand

    # getting the rand_num
    xorq %rax, %rax
    call rand

    # saving the rand_num
    movl %eax, rand_num
    
    # setting the rand_val to be lq to 10
    movl $10, %ebx
    divl %ebx
    movl %edx, rand_num

    # setting the num of guesses left
    movl $0x5, guesses_left

# start game-loop
.loop:
    
    
    # checking if the user ran out of guesses, them terminate 
    cmpq $0, guesses_left
    je .lost

    # Print the guess asking
    movq $user_pls_guess_msg, %rdi
    xorq %rax, %rax
    call printf

    # Read the user's guess
    movq $scanf_fmt, %rdi
    movq $user_guess, %rsi
    xorq %rax, %rax
    call scanf

    # saving the guess to a register
    movl user_guess, %edi

    # comparing the guess and the true val
    cmp %edi, rand_num
    je .winner

    # no match was found
    movq $user_incorrect_msg, %rdi
    xorq %rax, %rax
    call printf

    # we decrease the amount of guesses left and restart the loop
    decq guesses_left
    jmp .loop

# in case the user lost
.lost:
    # we print 'you lost' and the rand_num value
    movq $user_loser_msg, %rdi
    movq rand_num, %rsi
    xorq %rax, %rax
    call printf
    jmp .exit

# in case the user won 
.winner:
    # we print 'you won'
    movq $user_winner_msg, %rdi
    xorq %rax, %rax
    call printf

.exit:    
    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

.data
main_menu_text_1: .asciiz "1. x^n\n"
main_menu_text_2: .asciiz "2. x!\n"
yes_option_text: .asciiz "1. Yes\n"
no_option_text: .asciiz "0. No\n"
enter_x_text: .asciiz "x=\n"
enter_n_text: .asciiz "n=\n"
power_text: .asciiz "Power\n"
factorial_text: .asciiz "Factorial\n"

.text

start:

# display main menu
li $v0, 4
la $a0, main_menu_text_1
syscall
la $a0, main_menu_text_2
syscall

# get menu option
li $v0, 5
syscall

# go to selected option
beq $v0, 1, power
beq $v0, 2, factorial
jal start

power:
# get x and store in $t0
li $v0, 4
la $a0, enter_x_text
syscall
li $v0, 5
syscall
move $v0, $t0

# get n and store in $t1
li $v0, 4
la $a0, enter_n_text
syscall
li $v0, 5
syscall
move $v0, $t1

b start

factorial:
li $v0, 4
la $a0, factorial_text
syscall
b start


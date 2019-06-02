.data
main_menu_msg: .asciiz "\nChoose an operation: \n1. +\n2. -\n3. *\n4. /\n"
first_arg_msg: .asciiz "\nFirst argument: " 
second_arg_msg: .asciiz "\Second argument: "
parsing_error_msg: .asciiz "Unable to parse entered value\n"
division_by_zero_msg: .asciiz  "Can't divide by zero\n"
result_msg: .asciiz "Result: "
exit_program_msg: "\nEnter 0 to exit: "
zero_double: .double 0

# handle exceptions
.ktext 0x80000180
move $t0, $a0
la $a0, parsing_error_msg
li $v0, 4
syscall
move $a0, $t0
li $s7, 1
mfc0 $k0, $14 # get return address
addiu $k0, $k0, 4  # jum to next opration (after syscall)
jr $k0


.text
j program_start

# FUNC: reads double with excpetion handling
# args: $a0 - title msg
# return: $f0
read_double:
  li $v0, 4
  syscall
  li $s7, 0  # reset exception indicator 
  li $v0, 7
  syscall
  beq $s7, 1, read_double # exception occured
  jr $ra

program_start:
  la $a0, main_menu_msg
  li $v0, 4
  syscall

  li $s7, 0  # reset exception indicator
  li $v0, 5
  syscall
  beq $s7, 1, program_start  # exception occured
  move $s0, $v0

  blt $s0, 1, program_start
  bgt $s0, 4, program_start

  # read first argument
  la $a0, first_arg_msg
  jal read_double
  mov.d $f2, $f0
  
  # read second argument
  la $a0, second_arg_msg
  jal read_double

  beq $s0, 1, add_op
  beq $s0, 2, subtract_op
  beq $s0, 3, multiply_op
  beq $s0, 4, divide_op

  add_op:
    add.d $f12, $f2, $f0
    j print_results

  subtract_op:
    sub.d $f12, $f2, $f0
    j print_results

  multiply_op:
    mul.d $f12, $f2, $f0
    j print_results
  
  divide_op:
    l.d $f4, zero_double
    c.eq.d $f0, $f4
    bc1f continue_division
    
    la $a0, division_by_zero_msg
    li $v0, 4
    syscall
    j program_start

    continue_division:
      div.d $f12, $f2, $f0,
      j print_results

  print_results:
    la $a0, result_msg
    li $v0, 4
    syscall
    li $v0, 3
    syscall
    
    la $a0, exit_program_msg
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    
    bne $v0, 0, program_start


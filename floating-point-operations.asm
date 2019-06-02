.data
main_menu_msg: .asciiz "\nChoose an operation: \n1. +\n2. -\n3. *\n4. /\n"
first_arg_msg: .asciiz "\nFirst argument: " 
second_arg_msg: .asciiz "\Second argument: "
parsing_error_msg: .asciiz "Unable to parse entered value\n"
division_by_zero_msg: .asciiz  "Can't divide by zero\n"
result_msg: .asciiz "Result: "
zero_double: .double 0

# handle exceptions
.ktext 0x80000180


.text
program_start:
  la $a0, main_menu_msg
  li $v0, 4
  syscall
  
  li $v0, 5
  syscall

  move $s0, $v0

  blt $s0, 1, program_start
  bgt $s0, 4, program_start
  
  enter_first_arg:
    la $a0, first_arg_msg
    li $v0, 4
    syscall
    
    li $v0, 7
    syscall
    mov.d $f2, $f0

  enter_second_arg:
    la $a0, second_arg_msg
    li $v0, 4
    syscall
    li $v0, 7
    syscall
  
  
  exec_operation:
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
    
    j program_start
  
  
  
  

.globl check_for_winner, print_field, reset_field


# FUNC - checks if someone has won the game
# args: $a0 - game field buffer address, $a1 - user sign
# result: $v0 - 0 (computer won) | 1 (user won) | 2 (no winner yet)
check_for_winner:
  move $t4, $ra # store return address

  # check first row
  lb $t0, 0($a0)
  lb $t1, 1($a0)
  lb $t2, 2($a0)
  jal c_f_w_check_if_filled
  
  # check second row
  lb $t0, 3($a0)
  lb $t1, 4($a0)
  lb $t2, 5($a0)
  jal c_f_w_check_if_filled
  
  # check third row
  lb $t0, 6($a0)
  lb $t1, 7($a0)
  lb $t2, 8($a0)
  jal c_f_w_check_if_filled
  
  # check first column
  lb $t0, 0($a0)
  lb $t1, 3($a0)
  lb $t2, 6($a0)
  jal c_f_w_check_if_filled
  
  # check second column
  lb $t0, 0($a0)
  lb $t1, 3($a0)
  lb $t2, 6($a0)
  jal c_f_w_check_if_filled
  
  # check third column
  lb $t0, 0($a0)
  lb $t1, 3($a0)
  lb $t2, 6($a0)
  jal c_f_w_check_if_filled
  
  # check main diagonal
  lb $t0, 0($a0)
  lb $t1, 4($a0)
  lb $t2, 8($a0)
  jal c_f_w_check_if_filled

  # check second diagonal
  lb $t0, 2($a0)
  lb $t1, 4($a0)
  lb $t2, 6($a0)
  jal c_f_w_check_if_filled

  # no winner
  li $v0, 2
  jr $t4

  c_f_w_check_if_filled:
    beq $t0, 0, c_f_w_not_filled
    beq $t1, 0, c_f_w_not_filled
    beq $t2, 0, c_f_w_not_filled
    seq $t0, $t0, $t1
    seq $t1, $t1, $t2
    and $t0, $t0, $t1
    beq $t0, 1, c_f_w_found_winner
    
    c_f_w_not_filled:
      jr $ra

  c_f_w_found_winner:
    seq $v0, $t3, $a1 # if winning charachter is user's
    jr $t4

# FUNC - prints current field state
# args: $a0 - field address
print_field:
  jr $ra
  
# FUNC - sets each element in field to 0
# args: $a0 - field address
reset_field:
  li $t0, 0

  r_f_next_iter:
    beq $t0, 9, r_f_end
    add $t1, $a0, $t0
    li $t2, 0
    sb $t2, ($t1)
    add $t0, $t0, 1
    j r_f_next_iter
    
  r_f_end:
    jr $ra


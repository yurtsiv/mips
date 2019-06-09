.include "macros.asm"

.globl check_for_winner, print_field, reset_field

# FUNC - checks if someone has won the game
# args: $a0 - game field buffer address
# result: $v0 - 0 (computer won) | 1 (user won) | 2 (draw) | 3 (not finished yet)
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
  lb $t0, 1($a0)
  lb $t1, 4($a0)
  lb $t2, 7($a0)
  jal c_f_w_check_if_filled
  
  # check third column
  lb $t0, 2($a0)
  lb $t1, 5($a0)
  lb $t2, 8($a0)
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

  # not finished yet
  li $v0, 3
  jr $t4

  c_f_w_check_if_filled:
    beq $t0, 0, c_f_w_not_filled
    beq $t1, 0, c_f_w_not_filled
    beq $t2, 0, c_f_w_not_filled
    seq $t0, $t0, $t1
    seq $t1, $t1, $t2
    and $t0, $t0, $t1
    beq $t0, 1, c_f_w_found_winner
    c_f_w_not_filled: jr $ra

  c_f_w_found_winner:
    seq $v0, $t3, 1 # if winning charachter is user's
    jr $t4

# FUNC - prints current field state
# args: $a0 - field address, $a1 - users's char, $a2 - computer's char
print_field:
  li $t0, 0     # iterator
  li $t1, 0     # character num in a row
  move $t2, $a0 # field address
  print ("\n")

  p_f_next_iter:
    beq $t0, 9, p_f_end
    add $t3, $t2, $t0
    lb $t3, ($t3)
    beq $t3, 1, p_f_print_user_char
    beq $t3, 2, p_f_print_computer_char
    
    # print empty cell
    print ("*")
    j p_f_iter_end

    p_f_print_computer_char:
      move $a0, $a2
      li $v0, 11
      syscall
      j p_f_iter_end
      
    p_f_print_user_char:
      move $a0, $a1
      li $v0, 11
      syscall
      j p_f_iter_end

    p_f_iter_end:
      bne $t1, 2, p_f_next
      li $t1, -1
      print ("\n")
      p_f_next:
        add $t0, $t0, 1
        add $t1, $t1, 1
        j p_f_next_iter

  p_f_end:
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


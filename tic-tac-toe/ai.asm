.include "macros.asm"
.globl ai_turn

# FUNC - makes automatic turn
# args: $a0 - game field address
ai_turn:
  li $t0, 2 # computer's sign

  # deny first row
  lb $t1, ($a0)
  lb $t2, 1($a0)
  lb $t3, 2($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_1)
  match_three_temp_regs (1, 0, 1, a_t_play_2)
  match_three_temp_regs (1, 1, 0, a_t_play_3)

  # deny second row
  lb $t1, 3($a0)
  lb $t2, 4($a0)
  lb $t3, 5($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_4)
  match_three_temp_regs (1, 0, 1, a_t_play_5)
  match_three_temp_regs (1, 1, 0, a_t_play_6)

  # deny third row
  lb $t1, 6($a0)
  lb $t2, 7($a0)
  lb $t3, 8($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_7)
  match_three_temp_regs (1, 0, 1, a_t_play_8)
  match_three_temp_regs (1, 1, 0, a_t_play_9)

  # deny first column
  lb $t1, 0($a0)
  lb $t2, 3($a0)
  lb $t3, 6($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_1)
  match_three_temp_regs (1, 0, 1, a_t_play_4)
  match_three_temp_regs (1, 1, 0, a_t_play_7)

  # deny second column
  lb $t1, 1($a0)
  lb $t2, 4($a0)
  lb $t3, 7($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_2)
  match_three_temp_regs (1, 0, 1, a_t_play_5)
  match_three_temp_regs (1, 1, 0, a_t_play_8)

  # deny third column
  lb $t1, 2($a0)
  lb $t2, 5($a0)
  lb $t3, 8($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_3)
  match_three_temp_regs (1, 0, 1, a_t_play_6)
  match_three_temp_regs (1, 1, 0, a_t_play_9)

  # deny main diagonal
  lb $t1, 0($a0)
  lb $t2, 4($a0)
  lb $t3, 8($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_1)
  match_three_temp_regs (1, 0, 1, a_t_play_5)
  match_three_temp_regs (1, 1, 0, a_t_play_9)

  # deny second diagonal
  lb $t1, 2($a0)
  lb $t2, 4($a0)
  lb $t3, 6($a0)
  match_three_temp_regs (0, 1, 1, a_t_play_3)
  match_three_temp_regs (1, 0, 1, a_t_play_5)
  match_three_temp_regs (1, 1, 0, a_t_play_7)
  
  # win first row
  lb $t1, ($a0)
  lb $t2, 1($a0)
  lb $t3, 2($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_1)
  match_three_temp_regs (2, 0, 2, a_t_play_2)
  match_three_temp_regs (2, 2, 0, a_t_play_3)

  # win second row
  lb $t1, 3($a0)
  lb $t2, 4($a0)
  lb $t3, 5($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_4)
  match_three_temp_regs (2, 0, 2, a_t_play_5)
  match_three_temp_regs (2, 2, 0, a_t_play_6)

  # win third row
  lb $t1, 6($a0)
  lb $t2, 7($a0)
  lb $t3, 8($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_7)
  match_three_temp_regs (2, 0, 2, a_t_play_8)
  match_three_temp_regs (2, 2, 0, a_t_play_9)

  # win first column
  lb $t1, 0($a0)
  lb $t2, 3($a0)
  lb $t3, 6($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_1)
  match_three_temp_regs (2, 0, 2, a_t_play_4)
  match_three_temp_regs (2, 2, 0, a_t_play_7)

  # win second column
  lb $t1, 1($a0)
  lb $t2, 4($a0)
  lb $t3, 7($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_2)
  match_three_temp_regs (2, 0, 2, a_t_play_5)
  match_three_temp_regs (2, 2, 0, a_t_play_8)

  # win third column
  lb $t1, 2($a0)
  lb $t2, 5($a0)
  lb $t3, 8($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_3)
  match_three_temp_regs (2, 0, 2, a_t_play_6)
  match_three_temp_regs (2, 2, 0, a_t_play_9)

  # win main diagonal
  lb $t1, 0($a0)
  lb $t2, 4($a0)
  lb $t3, 8($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_1)
  match_three_temp_regs (2, 0, 2, a_t_play_5)
  match_three_temp_regs (2, 2, 0, a_t_play_9)

  # win second diagonal
  lb $t1, 2($a0)
  lb $t2, 4($a0)
  lb $t3, 6($a0)
  match_three_temp_regs (0, 2, 2, a_t_play_3)
  match_three_temp_regs (2, 0, 2, a_t_play_5)
  match_three_temp_regs (2, 2, 0, a_t_play_7)

  j a_t_play_first_free

  a_t_play_1:
    sb $t0, ($a0)
    j a_t_end

  a_t_play_2:
    sb $t0, 1($a0)
    j a_t_end

  a_t_play_3:
    sb $t0, 2($a0)
    j a_t_end

  a_t_play_4:
    sb $t0, 3($a0)
    j a_t_end

  a_t_play_5:
    sb $t0, 4($a0)
    j a_t_end

  a_t_play_6:
    sb $t0, 5($a0)
    j a_t_end

  a_t_play_7:
    sb $t0, 6($a0)
    j a_t_end

  a_t_play_8:
    sb $t0, 7($a0)
    j a_t_end

  a_t_play_9:
    sb $t0, 8($a0)
    j a_t_end

  a_t_play_first_free:
    li $t5, 0 # iterator
    a_t_next_iter:
      add $t1, $a0, $t5
      lb $t2, ($t1)
      beq $t2, 0, a_t_play_free
      add $t5, $t5, 1
      j a_t_next_iter
      
      a_t_play_free:
        sb $t0, ($t1)
        j a_t_end

  a_t_end:
    jr $ra

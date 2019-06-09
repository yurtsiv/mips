.include "macros.asm"

.data
game_board_buffer: .space 9

# Game state
# $s0 - current round (1-5)
# $s1 - player sign (0 or x)



.text
game_start:
  print ("Tic Tac Toe")

choose_rounds:
  print ("\nNumber of rounds (1-5): ")
  li $v0, 5
  syscall
  validate_num (1, 5, $v0, choose_rounds)
  move $s0, $v0

choose_sign:
  print ("\nChoose your sign (o or x): ")
  li $v0, 12
  syscall
  seq $t0, $v0, 0x6f
  seq $t1, $v0, 0x78
  or $t0, $t0, $t1
  bne $t0, 1, choose_sign


next_round:
  beq $s0, 0, game_over
  
  
  
  
  
game_over:
  
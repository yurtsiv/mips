.include "macros.asm"
.data

welcome_msg: .asciiz "Tic Tac Toe\n"
choose_rounds_msg: .asciiz "\nNumber of rounds (1-5): "
choose_sign_msg: .asciiz "Choose your sign (o or x): "

.text
program_start:
  la $a0, welcome_msg
  li $v0, 4
  syscall

choose_rounds:
  la $a0, choose_rounds_msg
  li $v0, 4
  syscall
  
  li $v0, 5
  syscall
  
  validate_num (1, 5, $v0, choose_rounds)

next_round:
    
  
  
  
  
program_end:
  
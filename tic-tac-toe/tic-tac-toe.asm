.include "macros.asm"

.data
# 0 - empty, 1 - user, 2 - computer
game_field_buffer: .space 9

# Chars
# x - 0x78
# o - 0x6f

# Game state
# $s0 - current round (1-5)
# $s1 - user's char (o or x)
# $s2 - computer's char (o or x)
# $s3 - game field buffer address

.text
la $s3, game_field_buffer

game_start:
  print ("Tic Tac Toe")

  choose_rounds:
    print ("\nNumber of rounds (1-5): ")
    li $v0, 5
    syscall
    validate_num (1, 5, $v0, choose_rounds)
    move $s0, $v0

  choose_char:
    print ("\nChoose your char (o or x): ")
    li $v0, 12
    syscall
    seq $t0, $v0, 0x6f
    seq $t1, $v0, 0x78
    or $t0, $t0, $t1
    bne $t0, 1, choose_char
    move $s1, $v0
    beq $s1, 0x6f, set_comp_char_x
    li $s2, 0x6f
    j next_round
    set_comp_char_x:
      li $s2, 0x78

  next_round:
    beq $s0, 0, game_over
    move $a0, $s3
    jal reset_field

    next_turn:
      move $a0, $s3
      move $a1, $s1
      move $a2, $s2
      jal print_field
      move $a0, $s3
      jal check_for_winner
      beq $v0, 3, user_turn  # not finsihed yet
      j round_end

      user_turn:
        print("\nYour turn (1-9): ")
        li $v0, 5
        syscall
        validate_turn ($v0, $s3, user_turn)
        li $t1, 1
        sb $t1, -1($t0)  # $t0 is calculated in the macros above
        move $a0, $s3
        jal ai_turn
        j next_turn

    round_end:
      print ("Round finished")
      add $s0, $s0, -1
      j next_round

game_over:
  print ("\nGame over")
  li $v0, 10
  syscall

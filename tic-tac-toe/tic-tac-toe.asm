.include "macros.asm"

.data
game_field_buffer: .space 9

# Chars
# x - 0x78
# o - 0x6f

# Game state
# $s0 - current round (1-5)
# $s1 - user's sign (o or x)
# $s2 - computer's sign (o or x)
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
    move $a0, $s3
    jal reset_field

    next_turn:
      move $a0, $s3
      jal print_field
      jal check_for_winner
      beq $v0, 2, user_move
      j round_end

      user_move:
        print("\nYour turn (1-9): ")
        li $v0, 5
        syscall
        validate_turn ($v0, $s3, user_move)
        li $t1, 1
        sb $t1, -1($t0) # $t0 is calculated in the macros above
        move $a0, $s3
        move $a1, $s2
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

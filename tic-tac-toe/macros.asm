.macro print(%msg)
  .data
    msg: .asciiz %msg

  .text
    la $a0, msg
    li $v0, 4
    syscall
.end_macro

.macro validate_num(%min, %max, %register, %return_label)
  blt %register, %min, validation_error
  bgt %register, %max, validation_error
  j continue

  validation_error:
    print ("Incorrect number entered")
    j %return_label
 
  continue:
.end_macro

.macro validate_turn(%reg, %game_field_addr_reg, %return_label)
  validate_num(1, 9, %reg, %return_label)
  
  add $t0, %game_field_addr_reg, %reg
  lb $t1, -1($t0)
  beq $t1, 0, continue

  print ("Selected cell is already filled")
  j %return_label

  continue:
.end_macro

# if $t1, $t2, $t3 are equal to %val1, $val2, $val3 go to %label
.macro match_three_temp_regs(%val1, %val2, %val3, %label)
  seq $t4, $t1, %val1
  seq $t5, $t2, %val2
  seq $t6, $t3, %val3
  and $t4, $t4, $t5
  and $t4, $t4, $t6
  beq $t4, 1, %label
.end_macro
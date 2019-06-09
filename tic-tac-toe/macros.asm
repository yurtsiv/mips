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
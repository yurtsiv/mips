.macro validate_num(%min, %max, %register, %return_addr)
  .data
  error_msg: .asciiz "Incorrect number entered"

  .text
  blt %register, %min, validation_error
  bgt %register, %max, validation_error
  j continue

  validation_error:
    la $a0, error_msg
    li $v0, 4
    syscall
    j %return_addr
  
  continue:
.end_macro

.macro print(%msg)
  .data
  msg: .asciiz %msg
  
  .text
  la $a0, msg
  li $v0, 4
  syscall
.end_macro
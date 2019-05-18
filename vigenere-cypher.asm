.include "macros.asm"

.data
welcome_msg: .asciiz "\nE - encrypt, D - decrypt: "
key_msg: .asciiz "\nEncryption key: "
enter_msg: .asciiz "\nMessage: "
result_msg: .asciiz "\nResult: "
key_buffer: .space 8
msg_buffer: .space 50
result_buffer: .space 50

.text
start:
  # print welcome msg
  la $a0, welcome_msg
  li $v0, 4
  syscall
  
  # read char (E, D)
  li $v0, 12
  syscall
  beq $v0, 0x45, read_key
  beq $v0, 0x44, read_key
  b start
 
  read_key:
    #la $a0, key_msg
    #li $v0, 4
    #syscall
    
    #la $a0, key_buffer
    #li $a1, 8
    #li $v0, 8
    #syscall
  
  # read message
  la $a0, enter_msg
  li $v0, 4
  syscall
  
  la $a0, msg_buffer
  li $a1, 50
  li $v0, 8
  syscall

  beq $v0, 0x45, encrypt
  beq $v0, 0x44, decrypt

  

  encrypt:
    la $v0, msg_buffer # message start address
    uppercase_eng_str($v0)
    remove_char($v0, ",")
    remove_char($v0, " ")
    j exit    

    # do_encrypt:
    #   add $t4, $t0, $t1 # next message char address
    #   lb $s0, 0($t4)
    #   beq $s0, $zero, exit # end of string

    #   add $t5, $t2, $t3 # next key char address
    #   lb $s1, 0($t5)
      
    #   add $s0, $s0, $s1 # encrypt one char
    #   sb $s0, 0($t4)    # store encrypted char
    #   add $t1, $t1, 1
    #   add $t3, $t3, 1

    #   b do_encrypt
      
  decrypt:

  exit:
    la $a0, result_msg
    li $v0, 4
    syscall
    la $a0, msg_buffer
    li $v0, 4
    syscall
   

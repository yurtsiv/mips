.data
welcome_msg: .asciiz "\nE - encrypt, D - decrypt: "
key_msg: .asciiz "\nEncryption key: "
enter_msg: .asciiz "\nMessage: "
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
    la $a0, key_msg
    li $v0, 4
    syscall
    
    la $a0, key_buffer
    li $a1, 8
    li $v0, 8
    syscall
  
  # read msg
  la $a0, enter_msg
  li $v0, 4
  syscall
  
  la $a0, msg_buffer
  li $a1, 50
  li $v0, 8
  syscall

  beq $v0, 0x45, encrypt
  beq $v0, 0x44, decrypt

  la $t0, msg_buffer # msg start
  li $t1, 0 # iterator
 
  encrypt:
    add $t2, $t0, $t1
    lb $a0, 0($t2)
    beq $a0, $zero, exit
    
    li $v0, 11
    syscall
    
    add $t1, $t1, 1
    b encrypt
  
  decrypt:
  

  
  exit:
  

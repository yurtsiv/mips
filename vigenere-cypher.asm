.include "macros.asm"

.data
  welcome_msg: .asciiz "\nE - encrypt, D - decrypt: "
  key_msg: .asciiz "\nEncryption key: "
  enter_msg: .asciiz "\nMessage: "
  result_msg: .asciiz "\nResult: "
  key_buffer: .space 8
  msg_buffer: .space 50

.text

j program_start

# FUNC: return statement
func_end: jr $ra

# FUNC: uppercases all lower-case english letters
uppercase_eng_str:
  li $t0, 0                       # iterator
  u_e_s_iter:
    add $t1, $a0, $t0             # calc current char address
    lb $t2, 0($t1)                # load current char
    beq $t2, $zero, func_end      # reached the end of the string
    # if current char is not a-z
    blt $t2, 0x61, u_e_s_iter_end
    bgt $t2, 0x7a, u_e_s_iter_end
    add $t2, $t2, -0x20           # uppercase current char
    sb $t2, 0($t1)                # store uppercased char
    # iterate once more
    u_e_s_iter_end:
      add $t0, $t0, 1
      j u_e_s_iter


# FUNC: removes char from specified position
remove_char_at:
  move $t0, $a1                 # iterator
  r_c_a_iter:
    add $t1, $a0, $t0           # calc current char address
    lb $t2, 1($t1)              # load next char
    sb $t2, 0($t1)              # override current char with next
    beq $t2, $zero, func_end    # reached the end of the string
    add $t0, $t0, 1
    j r_c_a_iter

# FUNC: removes everything except a-z, A-Z, 1-9
remove_redundant_chars:
  li $t3, 0                     # iterator
  move $t4, $a0                 # copy string address to $t4
  move $t7, $ra                 # copy return address because of nested function call

  r_r_c_iter:
    add $t5, $t4, $t3           # current char address  
    lb $t6, 0($t5)              # load current char
    move $ra, $t7               # make sure return address is correct
    beq $t6, $zero, func_end    # reached the end of the string

    # validate current char
    blt $t6, 0x30, r_r_c_remove_char
    bgt $t6, 0x7a, r_r_c_remove_char
    slti $s1, $t6, 0x61
    sgt $s2, $t6, 0x5a
    and $s1, $s1, $s2
    beq $s1, 1, r_r_c_remove_char
    slti $s1, $t6, 0x40
    sgt $s2, $t6, 0x3a
    and $s1, $s1, $s2
    beq $s1, 1, r_r_c_remove_char
    
    j r_r_c_iter_end

    r_r_c_remove_char:
      move $a0, $t4             # string address
      move $a1, $t3             # char index
      jal remove_char_at
      j r_r_c_iter                # jump to the next iteration without incrementing counter

    r_r_c_iter_end:
     add $t3, $t3, 1
     j r_r_c_iter

# START OF THE PROGRAM
program_start:
  # print welcome msg
  la $a0, welcome_msg
  li $v0, 4
  syscall

  # read char (E, D)
  li $v0, 12
  syscall

  move $s7, $v0              # store selected option in $s7
  beq $v0, 0x45, read_key    # E char
  beq $v0, 0x44, read_key    # D char
  j program_start

  # read an encryption key
  read_key:
  la $a0, key_msg
  li $v0, 4
  syscall
  la $a0, key_buffer
  li $a1, 8
  li $v0, 8
  syscall

  # read message to encryp
  la $a0, enter_msg
  li $v0, 4
  syscall
  la $a0, msg_buffer
  li $a1, 50
  li $v0, 8
  syscall

  la $a0, msg_buffer
  jal uppercase_eng_str
  jal remove_redundant_chars

  la $a0, key_buffer
  jal uppercase_eng_str
  jal remove_redundant_chars


  la $a0, msg_buffer      # message start address
  la $a1, key_buffer      # key start address
  li $t0, 0               # message iterator
  li $t1, 0               # key iterator
  beq $s7, 0x45, encrypt  # E - option
  beq $s7, 0x44, decrypt  # D - option
  
  # FUNC: calculate the offeset of specific key char stored in $s1
  calc_key_char_offset:
    blt $s1, 0x40, handle_number_key_char   # handle number key char differently
    add $s2, $s1, -0x41                     # key char offset
    jr $ra
    handle_number_key_char:
    add $s2, $s1, -0x31
    jr $ra
  
  # ENCRYPTION
  encrypt:
    add $t2, $a0, $t0             # calc current message char address
    add $t3, $a1, $t1             # calc current key char address
    lb $s0, 0($t2)                # load current message char
    beq $s0, $zero, program_exit  # end of string
    lb $s1, 0($t3)                # load current key char
    
    jal calc_key_char_offset
    blt $s0, 0x40, encrypt_number # if message char is a number handle it differently
    
    # encrypt A-Z char
    add $s0, $s0, $s2
    bgt $s0, 0x5a, e_handle_overflow
    j e_no_overflow
    e_handle_overflow: add $s0, $s0, -26
    e_no_overflow:
    sb $s0, 0($t2)
    j next_encrypt_iter

    # encrypt number
    encrypt_number:
      
    next_encrypt_iter:
      add $t0, $t0, 1
      add $t1, $t1, 1
      lb $t4, 1($t3)
      beq $t4, $zero, e_key_end    # reached the end of key
      j encrypt
      # reset key iterator
      e_key_end:
        li $t1, 0
        j encrypt

  # DECRYPTION
  decrypt:
      add $t2, $a0, $t0             # calc current message char address
      add $t3, $a1, $t1             # calc current key char address
      lb $s0, 0($t2)                # load current message char
      beq $s0, $zero, program_exit  # end of string
      lb $s1, 0($t3)                # load current key char
      
      jal calc_key_char_offset
      blt $s0, 0x40, decrypt_number # if message char is number
      
      # decrypt A-Z char
      sub $s0, $s0, $s2
      blt $s0, 0x41, d_handle_overflow
      j d_no_overflow
      d_handle_overflow: add $s0, $s0, 26
      d_no_overflow:
      sb $s0, 0($t2)
      j next_decrypt_iter

      decrypt_number:

      next_decrypt_iter:
	add $t0, $t0, 1
	add $t1, $t1, 1
 	lb $t4, 1($t3)
 	beq $t4, $zero, d_key_end
 	j decrypt

        d_key_end:
          li $t1, 0 # reset key iterator
          j decrypt

  program_exit:
    la $a0, result_msg
    li $v0, 4
    syscall
    la $a0, msg_buffer
    li $v0, 4
    syscall
    j program_start

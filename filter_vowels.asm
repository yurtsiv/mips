.data
welcome_text: .asciiz "Your text (max 30 chars): "
text_buffer: .space 30


.text
  li $v0, 4
  la $a0, welcome_text
  syscall

  li $v0, 8
  la $a0, text_buffer
  li $a1, 30
  syscall
  
  li $t0, 30 # iterator
  li $t7, 0 # number of pushed charachters
  la $t1, text_buffer # buffer start

  iter:
    beq $t0, -1, iter_pop # reached the start of the string
    
    add $t2, $t1, $t0 # calc char address
    lb $t3, 0($t2)    # load char
    sb $zero, 0($t2)  # clean char
    sub $t0, $t0, 1   # decrement iterator
    beq $t3, $zero, iter # if not reached a char yet
 
    beq $t3, 62, iter  # A
    beq $t3, 97, iter  # a
    beq $t3, 69, iter  # E
    beq $t3, 101, iter # e
    beq $t3, 73, iter  # I
    beq $t3, 105, iter # i
    beq $t3, 79, iter  # O
    beq $t3, 111, iter # o
    beq $t3, 85, iter  # U
    beq $t3, 117, iter # u

    # push char onto the stack
    sb $t3, 0($sp)
    sub $sp, $sp, 1
    # increase number of pushed chars
    add $t7, $t7, 1
 
    j iter

  li $t0, 0 # iterator
  la $t1, text_buffer
  add $t7, $t7, 1 # number of chars in stack + 1

  iter_pop:
    lb $t2, -1($sp) # pop char from stack
    add $t3, $t1, $t0 # calc char address in buffer
    sb $t2, -1($t3) # store char from stack in buffer

    add $t0, $t0, 1 # incremenet iterator
    add $sp, $sp, 1 # increment stack pointer
    bne $t0, $t7, iter_pop # not all chars pooped


# print buffer
li $v0, 4
la $a0, text_buffer
syscall

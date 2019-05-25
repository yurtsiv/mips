.text

.globl push_instruction_to_stack

# FUNC - pushes insturion arguments and instruction itself to the stack
# args: $a0 - instruction address
push_instruction_to_stack:
  li $t0, 0      # string iterator / string length
  li $t2, 0      # byte in current stack word  
  
  count_inst_len:
    add $t3, $a0, $t0  # current char address
    lb $t4, 0($t3)     # current char
    
    # reached the end of string
    beq $t4, $zero, push_inst_char
    beq $t4, 0xa, push_inst_char

    add $t0, $t0, 1
    j count_inst_len

  push_inst_char:
    add $t0, $t0, -1
    blt $t0, 0, func_end
    add $t3, $a0, $t0     # current char address
    lb $t4, 0($t3)        # current char

    beq $t4, 0x20, push_next_inst_part # if space is encountered

    add $t6, $sp, $t2  # byte address
    sb $t4, 0($t6)     # store current char    
 
    add $t2, $t2, 1    # increment byte in current word
    j push_inst_char

    push_next_inst_part:
      li $t2, 0           # reset byte in current word
      add $sp, $sp, 4     # increment stack pointer by one word
      j push_inst_char

  func_end:
    add $sp, $sp, 4
    jr $ra

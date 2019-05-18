.macro done
  li $v0, 10
  syscall
.end_macro

.macro uppercase_eng_char(%char_register)
  blt %char_register, 0x61,end
  bgt %char_register, 0x7a, end
  add %char_register, %char_register, -0x20
  end:
.end_macro

.macro uppercase_eng_str(%str_base_reg)
  li $t0, 0                     # iterator 

  do_uppercase:
    add $t1, %str_base_reg, $t0 # current char address  
    lb $t2, 0($t1)              # load current char
    beq $t2, $zero, end         # end of the string
    uppercase_eng_char($t2)
    sb $t2, 0($t1)              # store uppercased char
    add $t0, $t0, 1
    j do_uppercase
  end:
.end_macro


.macro remove_char_at(%str_base_reg, %char_index_reg)
  move $t0, %char_index_reg     # iterator

  shift:
    add $t1, %str_base_reg, $t0 # current char address
    lb $t2, 1($t1)              # load next char
    sb $t2, 0($t1)              # override current char with next
    beq $t2, $zero, end         # end of the string
    add $t0, $t0, 1
    j shift

  end: 
.end_macro

.macro remove_char(%str_base_reg, %char)
  .data
    char_to_remove: .asciiz %char
  .text
    li $t0, 0                     # iterator
    lb $t1, char_to_remove        # load char to remove

    do_remove:
      add $t2, %str_base_reg, $t0 # current char address  
      lb $t3, 0($t2)              # load current char
      beq $t3, $zero, end         # end of the string
      bne $t3, $t1, next
      remove_char_at(%str_base_reg, $t0)
      next:
       add $t0, $t0, 1
       j do_remove
 
    end:
.end_macro

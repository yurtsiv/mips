.data
  main_menu_text_1: .asciiz "\n1. x^n\n"
  main_menu_text_2: .asciiz "2. x!\n"
  choose_option_text: .asciiz "Choose an option: "
  yes_option_text: .asciiz "1. Yes\n"
  no_option_text: .asciiz "0. No\n"
  enter_x_text: .asciiz "\nx="
  enter_n_text: .asciiz "\nn="
  result_text: .asciiz "\nResult: "

.text
  start:
    # display main menu
    li $v0, 4
    la $a0, main_menu_text_1
    syscall
    la $a0, main_menu_text_2
    syscall
    la $a0, choose_option_text
    syscall

    # get menu option
    li $v0, 5
    syscall

    # go to selected option
    beq $v0, 1, power
    beq $v0, 2, factorial
    b start


    power:
      # get x and store in $t0
      li $v0, 4
      la $a0, enter_x_text
      syscall
      li $v0, 5
      syscall
      move $t0, $v0
      move $v1, $t0

      # get n and store in $t1
      li $v0, 4
      la $a0, enter_n_text
      syscall
      li $v0, 5
      syscall
      move $t1, $v0

      # calculate power
      power_calc:
        beq $t1, 1, power_end
        mul $v1, $v1, $t0
        add $t1, $t1, -1
        b power_calc

      power_end:
        # print results
        la $a0, result_text
        li $v0, 4
        syscall
        move $a0, $v1
        li $v0, 1
        syscall
        b start


    factorial:
      # get x and store in $t0
      li $v0, 4
      la $a0, enter_x_text
      syscall
      li $v0, 5
      syscall
      move $t0, $v0
      move $v1, $t0
      
      factorial_calc:
      	beq $t0, 1, factorial_end
      	add $t0, $t0, -1
      	mul $v1, $v1, $t0
      	b factorial_calc
  	
      factorial_end:
      	# print results
        la $a0, result_text
        li $v0, 4
        syscall
        move $a0, $v1
        li $v0, 1
        syscall
      	b start

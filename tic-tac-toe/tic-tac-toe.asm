.data

welcome_msg: .ascii "Tic Tac Toe\n"
choose_rounds_msg: .ascii "Number of rounds (1-5): "
choose_sign_msg: .ascii "Choose your sign (o or x): "

.text
program_start:
la $a0, welcome_msg
li $v0, 4
syscall


la $a0, choose_rounds_msg
li $v0, 4
syscall

li $v0, 5
syscall


  
  next_round:
    
  
  
  
  
program_end:
  
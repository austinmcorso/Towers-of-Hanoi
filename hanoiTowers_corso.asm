    .data
Author:
    .ascii      "Towers of Hanoi\n"
    .asciiz     "Author: Austin Corso\n"
Prompt:  
    .asciiz     "\nEnter the number of disks: "
Move:
    .asciiz      "\nMove disk from "
To:
    .ascii      " to "
    .globl main
    .text  
        
main:
    li $v0, 4 			#Print author and program info
    la $a0, Author
    syscall

    li  $v0, 4 			#Print prompt
    la  $a0, Prompt
    syscall

    li $v0, 5
    syscall
    add $a0, $v0, $zero 	#$a0 = num of disks
    
    addi $a1, $zero, 1		#$a1 = start peg
    addi $a2, $zero, 3		#$a2 = end peg
    addi $a3, $zero, 2		#$a3 = extra peg
    jal hanoi_towers
    
    li $v0, 10 			# Return control to OS
    syscall
    
hanoi_towers:        
    # if (num_of_disks == 1)
    # 	move disk to end_peg
    # else
    #   hanoi_towers(num_of_disks-1, start_peg, extra_peg, end_peg)
    #	move disk from start_peg to end_peg
    # 	hanoi_towers(num_of_disks-1, extra_peg, end_peg, start_peg)
    
    
    # if (num_of_disks == 1)
    addi $t0, $a0, 0		# temp save $a0
    addi $t1, $zero, 1
    bne $a0, $t1, else
    li $v0, 4			# print move
    la $a0, Move
    syscall
    li $v0, 1 			# print start_peg
    move $a0, $a1
    syscall
    li $v0, 4			# print to
    la $a0, To
    syscall
    li $v0, 1 			# print end_peg
    move $a0, $a2
    syscall
    addi $a0, $t0, 0		# restore $a0
    jr $ra
    
else:
    #expand stack
    	addi $sp, $sp, -20
    
    #save to stack
    	sw $ra, 16($sp)
    	sw $a3, 12($sp)		#store a3(extra_peg)
    	sw $a2, 8($sp)		#store a2(end_peg)
    	sw $a1, 4($sp)		#store a1(start_peg)
	sw $a0, 0($sp)		#store a0(num_of_disks)
	    
    #hanoi_towers(num_of_disks-1, start_peg, extra_peg, end_peg)    
    	#set args for subsequent recursive call
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a2, 0		#extra_peg = end_peg
    		addi $a2, $t3, 0		#end_peg = extra_peg
    		addi $a0, $a0, -1		#num of disk--   		
    	#recursive call
    		jal hanoi_towers   
    	
    #load off stack
    	lw $ra, 16($sp)
    	lw $a3, 12($sp)		#load a3(extra_peg)
    	lw $a2, 8($sp)		#load a2(end_peg)
    	lw $a1, 4($sp)		#load a1(start_peg)
    	lw $a0, 0($sp)		#load a0(num_of_disks)
   
    #move a disk from start_peg to end_peg
    	addi $t0, $a0, 0		# temp save $a0
    	addi $t1, $zero, 1
    	li $v0, 4			# print move
    	la $a0, Move
    	syscall
    	li $v0, 1 			# print start_peg
    	move $a0, $a1
    	syscall
    	li $v0, 4			# print to
    	la $a0, To
    	syscall
    	li $v0, 1 			# print end_peg
    	move $a0, $a2
    	syscall
    	addi $a0, $t0, 0		# restore $a0
    
    #hanoi_towers(num_of_disks-1, extra_peg, end_peg, start_peg)  
    	#set args for subsequent recursive call
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a1, 0		#extra_peg = start_peg
    		addi $a1, $t3, 0		#start_peg = extra_peg
    		addi $a0, $a0, -1		#num of disk--  		
    	#recursive call
    		jal hanoi_towers  
    	#load params off stack
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 20

    #return
    	add $v0, $zero, $t5
    	jr $ra    

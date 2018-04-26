# Lab 2
# Part 2 Branches

	.data	# Data declaration section

A:	.word	10
B:	.word	15
C:	.word	6
Z:	.word	0


	.text

main:	

	la	x1, A	#address of A
	la 	x2, B   #address of B
	la	x3, C	#address of C
	la 	x4, Z   #address of Z
	
	lw	x5, 0(x1) # A
	lw	x6, 0(x2) # B
	lw	x7, 0(x3) # C
	lw	x8, 0(x4) # Z
	
	li	x9, 5 #constant 5
	li	x10, 7 #constant 7
	li	x20, 1 #constant 1
	li	x21, 2 #constant 2
	li	x22, 3 #constant 3
	
	#if
	slt 	x11, x5, x6 #A is less than B so x1 = 1 else x1 =0
	slt 	x12, x9, x7 #5 is less than C so x2 = 1 else x1 =0
	mul 	x11, x11, x12 # x1*x2 = x1
	beq 	x11, x0, Elseif
	li  	x8, 1
	j Switch
	
	# else if 
	Elseif: 
	slt 	x11, x6, x5 # if B is less than A then x11 = 1
	beq 	x11, x20, True 
	add 	x13, x7, x20
	beq 	x13, x10, True
	j Else
	
	True:
	li	x8, 2
	j Switch
	
	Else:  
	li 	x8, 3
	j Switch
	
	Switch:
	beq 	x8, x20, Case1
	beq 	x8, x21, Case2
	beq 	x8, x22, Case3
	li	x8, 0
	j Exit
	
	Case1:
	li	x8, -1
	j Exit
	
	Case2:
	li	x8, -2
	j Exit
	
	Case3:
	li	x8, -3
	j Exit
		
	Exit:
	sw	x8, 0(x4) # store value back to memory address of Z
# END OF PROGRAM
	 
	
	
	
	

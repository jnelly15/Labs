.data	# Data declaration section

A:	.word	0, 0, 0, 0, 0
B:	.word	1, 2, 4, 8, 16



	.text

main:

	la 	x1, A # load address of A array into x1
	la 	x2, B # load address of B array into x2
	
	li 	x3, 0 # set x3 to 0, or i
	li 	x4, 5 # constant 5
	li 	x9, -1 # constant -1
	li 	x12, 2 # constant 2
	
	For: beq x3, x4 Next
	slli 	x5, x3, 2 # holds array offset
	add 	x7, x2, x5 # x7 is the address of i element of array B
	lw 	x8, 0(x7) # load element i of array B into x8
	addi 	x8, x8, -1 # B[i] - 1
	add 	x7, x1, x5 # x7 is the address of i element of array A
	sw 	x8, 0(x7) # store word to element i of array A from B
	addi 	x3, x3, 1
	j For
	
	
	Next: addi x3, x3, -1
	j While
	
	While: beq x3, x9, Exit
	slli 	x5, x3, 2 # holds array offset
	add 	x7, x2, x5 # x7 is the address of i element of array B
	add 	x11, x1, x5 # x11 is the address of i element of array A
	lw 	x8, 0(x7) # load element i of array B into x8
	lw 	x10, 0(x11) # load element i of array A into x10
	add 	x8, x8, x10 # A[x] + B[i]
	mul	x8, x8, x12
	sw 	x8, 0(x11) # store word to element i of array A x8
	addi 	x3, x3, -1
	j While
	
	Exit:
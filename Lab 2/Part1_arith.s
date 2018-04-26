# Lab 2
#Part 1 arithmetic



	.data		# Data declaration section
Z: 	.word
	.text

main:			# Start of code section

#declaring register values

	la a0, Z
	sw a1, 0(a0)
	li t0, 15	
	li t1, 10
	li t2, 5
	li t3, 2
	li t4, 18
	li t5, -3
	#first operation (A-B), (C*D), (E-F), (A/C)
	sub a2, t0, t1
	mul a3, t2, t3
	sub a4, t4, t5
	div a5, t0, t2
	#second operation (adding and subtracting the values to s0
	add a1, a2, a3
	add a1, a1, a4
	sub a1, a1, a5
	
	 
	
	
	
	

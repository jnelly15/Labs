.data	# Data declaration section

Z:	.word	2
i:	.word	



	.text

main:	

	la	x1, Z	#address of Z
	la 	x2, i   #address of i
	li 	x10, 21   #address of A
	li	x11, 1 #constant 1
	li	x12, 2 #constant 2
	li	x13, 100 #constant 3

	
	lw	x3, 0(x1) # Z
	lw	x4, 0(x2) # i
	
	
	li	x4, 0
	While: slt x5, x4, x10
	beq x5, x0 Dowhile
	add x3, x3, x11
	add x4, x4, x12
	j While
	Dowhile: slt x6, x3, x13
	beq x6, x0 While1
	add x3, x3, x11
	j Dowhile
	While1: slt x7, x0, x4
	beq x7, x0, Exit
	sub x4, x4, x11
	sub x3, x3, x11
	j While1
	Exit:
	sw	x3, 0(x1)
	sw	x4, 0(x2) 
	
# Part 5 - Function Call

	.data # data declaration section
	
a:	.word	0
b:	.word	0
c:	.word	0

	.text
	
main:
	li	t0, 5		# i = 5
	li	t1, 10		# j = 10
	
	jal	AddItUp
	la	t4, a		# load address of a
	sw	a0, (t4)	# write AddItUp(i) to a
	add	t5, zero, a0	# return value is stored in t5
	
	li	t0, 10		# j = 10
	li	t1, 5		# i = 5
	
	jal	AddItUp
	la	t4, b		# load address of b
	sw	a0, (t4)	# write AddItUp(j) to b
	add	t6, zero, a0	# return value is stored in t6
	
	add 	t5, t5, t6	# c = a + b
	la	t6, c		# load address of c
	sw	t5, (t6)	# write c to memory
	
	j Exit
	
AddItUp:
	addi	sp, sp, -8	# grow stack down by 8 bytes
	sw	t1, 0(sp)	# value of t1 saved at offset 0 from sp
	sw	t0, 4(sp)	# value of t0 saved at offset 4 from sp
	
	li	t0, 0		# i = 0
	li	t1, 0		# x = 0
	
	For:
	lw	t3, 4(sp)
	beq	t0, t3, EndFor
	add	t1, t1, t0	# x = x + i
	addi	t1, t1, 1	# x = x + 1
	addi	t0, t0, 1	# i = i + 1
	j 	For
	
	EndFor:
	add	a0, t1, zero	# return x
	
	lw	t0, 4(sp)	# value of t0 restored from offset 4 of sp
	lw	t1, 0(sp)	# value of t1 restored from offset 0 of sp
	addi	sp, sp, 8	# shrink stack up by 8 bytes
	ret
		
Exit:
	
	
	
	
	
	
	
	

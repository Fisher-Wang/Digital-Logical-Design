.text
main:   addi x2, x0, 5
	addi x3, x0, 12
	addi x7, x3, -9
	or x4, x7, x2
	and x5, x3, x4
	add x5, x5, x4
	beq x5, x7, end
	slt x4, x3, x4
	beq x4, x0, around
	addi x5, x0, 0
around: slt x4, x7, x2
	add x7, x4, x5
	sub x7, x7, x2
	lui x3, 1
	sw x7, 12(x3)
	addi x3, x3, 8
	lw x2, 4(x3)
	j end
	addi x2, x0, 1
end:	lui x9, 8
	addi x9, x9, -4
	addi x2, x2, -6
loop:	sw x2, 0(x9)
	or x2, x2, x2
	and x2, x2, x2
	j loop

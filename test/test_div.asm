.text

li x5, 17
li x7, 5
j DIV

BEGIN:
addi x15, x0, 0x7f
slli x15, x15, 8
addi x15, x15, 0x20
addi x16, x0, 0 # inputed

addi x5, x0, 0 # acc
addi x6, x0, 0 # operator 
sw x7, (x15)


## first num and op
L1:
lw x8, 0x7f00
lw x7, 0x7f10
sw x7, (x15)
beq x8, x0, L1
L2:
lw x11, 0x7f00
beq x11, x8, L2

addi x5, x7, 0
addi x6, x8, 0
addi x14, x7, 0

## LOOP
LOOP:

# another num and op
L11:
lw x8, 0x7f00
lw x7, 0x7f10

beq x7, x14, IF1_END
addi x16, x0, 1
IF1_END:

beq x16, x0, IF2_END
sw x7, (x15)
IF2_END:
beq x8, x0, L11

L22:
lw x11, 0x7f00
beq x11, x8, L22

# calculate
addi x13, x0, 16  # ADD
bne x6, x13, ADD_END
add x5, x5, x7
j CAL_END
ADD_END:
addi x13, x0, 8  # SUB
bne x6, x13, SUB_END
sub x5, x5, x7
j CAL_END
SUB_END:
# addi x13, x0, 4  # SLT
# bne x6, x13, SLT_END
# slt x5, x5, x7
# j CAL_END
# SLT_END:
addi x13, x0, 4  # DIV
bne x6, x13, DIV_END
j DIV
RETURN:
j CAL_END
DIV_END:
addi x13, x0, 1  # RESET
beq x6, x13, BEGIN
CAL_END:

# display result
sw x5, (x15)

# ready for next loop
addi x16, x0, 0
lw x14, 0x7f10
addi x6, x8, 0

j LOOP


## DIV ##

DIV:
addi x20, x0, 0
addi x22, x0, 0
addi x23, x0, 16
slli x7,x7,15

BEGIN_DIV:
beq x22,x23,END_DIV

# sub x5,x5,x7
# bltz x5,L2b 	# branch less than zero
slt x21, x5, x7
bne x21, x0, L2b
L2a:
slli x20,x20,1	# shift left logical immediate
ori x20,x20,1	# or immediate
j L3
L2b:
add x5,x5,x7
slli x20,x20,1
L3:
srai x7,x7,1	# shift rigth arithmetic immediate

addi x22,x22,1
j BEGIN_DIV
END_DIV:
addi x5, x20, 0
j RETURN

.text
addi x5, x0, 0 # acc
addi x6, x0, 0 # operator 

addi x15, x0, 0x7f
slli x15, x15, 8
addi x15, x15, 0x20
addi x16, x0, 0 # inputed

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
addi x13, x0, 8  # ADD
bne x6, x13, ADD_END
add x5, x5, x7
j CAL_END
ADD_END:
addi x13, x0, 2  # SUB
bne x6, x13, SUB_END
sub x5, x5, x7
j CAL_END
SUB_END:
addi x13, x0, 4  # SLT
bne x6, x13, SLT_END
slt x5, x5, x7
j CAL_END
SLT_END:
CAL_END:

# display result
sw x5, (x15)

# ready for next loop
addi x16, x0, 0
lw x14, 0x7f10
addi x6, x8, 0

j LOOP

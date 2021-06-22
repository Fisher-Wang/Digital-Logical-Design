.text
addi x5, x0, 0 # acc
addi x6, x0, 0 # operator 

addi x15, x0, 0x7f
slli x15, x15, 8
addi x15, x15, 0x20

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

## LOOP
LOOP:

# another num and op
L11:
lw x8, 0x7f00
lw x7, 0x7f10
sw x7, (x15)
beq x8, x0, L11
L22:
lw x11, 0x7f00
beq x11, x8, L22

# calculate
addi x13, x0, 4  # ADD
beq x6, x13, L4B
j L4E
L4B:
add x5, x5, x7
L4E:

# ready for next loop
addi x6, x8, 0

j LOOP

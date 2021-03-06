.text

# li x5, 40
# li x7, 8
# j DIV

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
beq x6, x13, DIV_FUNC

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

# divisor x7
# reminder x5
# quotient x30
# counter x28

DIV_FUNC:
  andi x20, x0, 0
  andi x21, x0, 0
  andi x22, x0, 0
  andi x23, x0, 0
  andi x24, x0, 0
  mv x20, x5
  mv x21, x7
  # remainder reg: x20
  # devisor reg:   x21
  # quotient reg:  x22
  # counter:       x23
  # buffer:        x24
  addi x23, x0, 17
  slli x21, x21, 16
Loop:
  sub x20, x20, x21
  slt x24, x20, x0 # remainder < 0 ?
  bne x24, x0, Test_Remainder
  slli x22, x22, 1 # remainder >= 0
  addi x22, x22, 1
  j Test_Done
Test_Remainder: # remainder < 0
  add x20, x20, x21
  slli x22, x22, 1
Test_Done:
  srli x21, x21, 1
  addi x23, x23, -1
  bne x23, x0, Loop
  
  mv x5, x22
j CAL_END

.text
main:
  # x5: current result
  # x6: operation
  addi x5, x0, 0  # initially 0
  addi x6, x0, 0  # initially 0
  addi x16, x0, 0x7f # port initial address 0x7f00
  slli x16, x16, 8
  
  # load in the first number and the operation
  # x7: output buffer of portb (0x7f10)
  # x8: output buffer of porta (0x7f00)
  # x9: comparison buffer of portb
  # x10: comparison buffer of porta
init_1:
  lw x7, 16(x16)
  lw x8, 0(x16)
loop_1:
  # if portb changes, store the new value in x7 and output to portc (0x7f20)
  # this tells the user what the current input looks like
  lw x9, 16(x16)
  beq x9, x7, output_1
  mv x7, x9
  sw x7, 32(x16)
output_1:
  # if porta changes, store the new value in x8, wait until porta becomes 0
  lw x10, 0(x16)
  beq x8, x10, loop_1
  mv x8, x10
wait_1:
  lw x10, 0(x16)
  bne x10, x0, wait_1
  # here porta becomes 0,we store the first number nad the first operation
  mv x5, x7
  mv x6, x8
  # if the first operation is =, then we start over
  addi x6, x6, -1
  beq x6 x0, loop_1
  addi x6, x6, 1
  
  # load the second number and calculate
init_2:
  lw x7, 16(x16)
  lw x8, 0(x16)
loop_2:
  # if portb changes, store the new value in x7 and output to portc (0x7f20)
  # this tells the user what the current input looks like
  lw x9, 16(x16)
  beq x9, x7, output_2
  mv x7, x9
  sw x7, 32(x16)
output_2:
  # if porta changes, store the new value in x8, wait until porta becomes 0
  lw x10, 0(x16)
  beq x8, x10, loop_2
  mv x8, x10
wait_2:
  lw x10, 0(x16)
  bne x10, x0, wait_2
  
  # here porta becomes 0, we will use operation x8 later
  # now we use operation x6 to calculate number x5 and x7
  # x11: immediate number buffer
  addi x11, x0, 2
  beq x6, x11, divide
  addi x11, x0, 4
  beq x6, x11, subtract
  addi x11, x0, 8
  beq x6, x11, adding

adding:
  add x5, x5, x7
  j continue

subtract:
  sub x5, x5, x7
  j continue

divide:
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
  j continue

continue:
  # output the result
  sw x5, 32(x16)
  # if operation x8 is not equal, go to loop_2, else loop_1
  addi x11, x0, 1
  beq x8, x11, main
  mv x6, x8  # save the current operation
  j init_2

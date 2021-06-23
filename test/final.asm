.text
main:
    addi x5, x0, 0 
    addi x6, x0, 0
    addi x16, x0, 0x7f
    slli x16, x16, 8
L1:
    lw x7, 16(x16)
    lw x8, 0(x16)
L2:
    lw x9, 16(x16)
    beq x9, x7, L3
    mv x7, x9
    sw x7, 32(x16)
L3:
    lw x10, 0(x16)
    beq x8, x10, L2
    mv x8, x10
L4:
    lw x10, 0(x16)
    bne x10, x0, L4
    mv x5, x7
    mv x6, x8
    addi x6, x6, -1
    beq x6 x0, L2
    addi x6, x6, 1
    
L5:
    lw x7, 16(x16)
    lw x8, 0(x16)
L6:
    lw x9, 16(x16)
    beq x9, x7, L7
    mv x7, x9
    sw x7, 32(x16)
L7:
    lw x10, 0(x16)
    beq x8, x10, L6
    mv x8, x10
L8:
    lw x10, 0(x16)
    bne x10, x0, L8
    
    addi x11, x0, 2
    beq x6, x11, DIV
    addi x11, x0, 4
    beq x6, x11, SUB
    addi x11, x0, 8
    beq x6, x11, ADD

ADD:
    add x5, x5, x7
    j NEXT

SUB:
    sub x5, x5, x7
    j NEXT

DIV:
    andi x20, x0, 0
    andi x21, x0, 0
    andi x22, x0, 0
    andi x23, x0, 0
    andi x24, x0, 0
    mv x20, x5
    mv x21, x7
    addi x23, x0, 17
    slli x21, x21, 16
LOOP:
    sub x20, x20, x21
    slt x24, x20, x0
    bne x24, x0, REMAIN
    slli x22, x22, 1
    addi x22, x22, 1
    j DONE
REMAIN:
    add x20, x20, x21
    slli x22, x22, 1
DONE:
    srli x21, x21, 1
    addi x23, x23, -1
    bne x23, x0, LOOP
    
    mv x5, x22
    j NEXT

NEXT:
    sw x5, 32(x16)
    addi x11, x0, 1
    beq x8, x11, main
    mv x6, x8
    j L5

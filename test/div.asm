# divisor x7
# reminder x5
# quotient x20
# counter x22
li x5 17
li x7 5
li x20 0

li x22,0
li x23,16
slli x7,x7,15

BEGIN:
bge x22,x23,END

sub x5,x5,x7
bltz x5,L2b 	# branch less than zero
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
j BEGIN
END:
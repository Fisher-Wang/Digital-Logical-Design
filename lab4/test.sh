iverilog -W all -o a.vpp singleriscv_tb.v dmem_io.v singleriscv.v riscvparts.v alu.v
if [ $? -eq 0 ]; then
    vvp a.vpp
fi

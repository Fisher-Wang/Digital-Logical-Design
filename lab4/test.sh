iverilog -W all -o a.vpp singleriscv_fpga.v dmem_io.v singleriscv.v riscvparts.v alu.v bcd2bin.v bin2bcd.v display_7seg.v adder3.v
if [ $? -eq 0 ]; then
    vvp a.vpp
fi

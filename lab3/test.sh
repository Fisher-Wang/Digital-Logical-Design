iverilog -o a.vpp stringreco_tb.v stringreco.v binary2BCD.v
if [ $? -eq 0 ]; then
    vvp a.vpp
fi

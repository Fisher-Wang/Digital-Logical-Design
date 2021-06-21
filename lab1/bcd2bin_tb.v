module bcd2_wfsbin_tb;
  wire [3:0] bcd3_wfs, bcd2_wfs, bcd1_wfs, bcd0_wfs;
  reg [13:0] binary_in_wfs;
  wire [13:0] binary_out_wfs;

  integer i_wfs = 0;


  initial begin
    $dumpfile("bcd2bin.vcd");
    $dumpvars(0, u_BCD2bin_wfs);
    $dumpvars(1, u_bin2BCD_wfs);
    $monitor("Binary_in is %b; BCD is %d %d %d %d; Binary_out is %b", binary_in_wfs, bcd3_wfs, bcd2_wfs, bcd1_wfs, bcd0_wfs, binary_out_wfs);
  
    for (i_wfs = 1; i_wfs <= 1001; i_wfs = i_wfs+1) begin
      binary_in_wfs = i_wfs; #50;
    end
    $finish;
    end

  binary2BCD_wfs u_bin2BCD_wfs(binary_in_wfs, bcd3_wfs, bcd2_wfs, bcd1_wfs, bcd0_wfs);
  BCD2binary_wfs u_BCD2bin_wfs(bcd3_wfs, bcd2_wfs, bcd1_wfs, bcd0_wfs, binary_out_wfs);

endmodule

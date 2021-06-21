module BCD2binary_wfs (
  input [3:0] thousands_wfs,
  input [3:0] hundreds_wfs,
  input [3:0] tens_wfs,
  input [3:0] ones_wfs,
  output reg [13:0] binary_wfs
);

  reg [29:0] shifter_wfs;
  integer i_wfs;

  always @(thousands_wfs, hundreds_wfs, tens_wfs, ones_wfs)
  begin
    shifter_wfs[29:26] = thousands_wfs;
    shifter_wfs[25:22] = hundreds_wfs;
    shifter_wfs[21:18] = tens_wfs;
    shifter_wfs[17:14] = ones_wfs;
    shifter_wfs[13:0] = 0;

    for (i_wfs = 0; i_wfs <14; i_wfs = i_wfs + 1) begin
      shifter_wfs = shifter_wfs >> 1;

      if (shifter_wfs[29:26] >= 8)
        shifter_wfs[29:26] = shifter_wfs[29:26] - 3;
      if (shifter_wfs[25:22] >= 8)
        shifter_wfs[25:22] = shifter_wfs[25:22] - 3;
      if (shifter_wfs[21:18] >= 8)
        shifter_wfs[21:18] = shifter_wfs[21:18] - 3;
      if (shifter_wfs[17:14] >= 8)
        shifter_wfs[17:14] = shifter_wfs[17:14] - 3;
    end

    binary_wfs = shifter_wfs[13:0];
  end

endmodule
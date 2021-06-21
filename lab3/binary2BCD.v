module binary2BCD_wfs(
    input [13:0] binary_wfs,
    output reg [3:0] thousands_wfs,
    output reg [3:0] hundreds_wfs,
    output reg [3:0] tens_wfs,
    output reg [3:0] ones_wfs
    ); 
  
    reg [29:0] shifter_wfs; 
    integer i_wfs;
    
    always @(binary_wfs) 
    begin 
        shifter_wfs[13:0] = binary_wfs;
        shifter_wfs[29:14] = 0; 
        
        for (i_wfs = 0; i_wfs < 14; i_wfs = i_wfs + 1) begin 
            if (shifter_wfs[17:14] >= 5) 
                shifter_wfs[17:14] = shifter_wfs[17:14] + 3; 
            if (shifter_wfs[21:18] >= 5)             
                shifter_wfs[21:18] = shifter_wfs[21:18] + 3;
            if (shifter_wfs[25:22] >= 5)             
                shifter_wfs[25:22] = shifter_wfs[25:22] + 3; 
            if (shifter_wfs[29:26] >= 5)              
                shifter_wfs[29:26] = shifter_wfs[29:26] + 3; 
            shifter_wfs = shifter_wfs  << 1;    
        end  
        
        thousands_wfs = shifter_wfs[29:26];
        hundreds_wfs = shifter_wfs[25:22];
        tens_wfs = shifter_wfs[21:18];
        ones_wfs = shifter_wfs[17:14];
    end

endmodule

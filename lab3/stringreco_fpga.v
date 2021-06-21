`timescale 1ns / 1ps

module stringreco_fpga(input clk,        //100MHz
                       input btnC,       //CLR Button
                       input btnD,       //PAUSE Button
                       input [15:0] sw,
                       output [0:6] seg,
                       output [0:3] an);
    
    //generate 10hz clock
    reg [23:0] cnt;
    reg clk_gen; //1KHz
    wire clk_gen_bufg;
    
    parameter PERIOD_CLK = 1000000;
    
    always @(posedge clk)
    begin
        if (cnt == PERIOD_CLK/2)
        begin
            cnt     <= 0;
            clk_gen <= ~clk_gen;
        end
        else
            cnt <= cnt + 1;
    end
    
    BUFG  CLK0_BUFG_INST (.I(clk_gen),
    .O(clk_gen_bufg));
    //generate 10Hz clock
    
    wire clr;
    wire en;
    
    reg sync_clr0, sync_clr1;
    always @(posedge clk_gen_bufg)
    begin
        sync_clr0 <= btnC;
        sync_clr1 <= sync_clr0;
    end
    assign clr = btnC | sync_clr1;
    
    reg sync_en0, sync_en1, sync_en2;
    always @(posedge clk_gen_bufg)
    begin
        sync_en0 <= btnD;
        sync_en1 <= sync_en0;
        sync_en2 <= sync_en1;
    end
    assign en = sync_en2 & ~sync_en1;
    
    //stopwatch
    wire [15:0] count;
    
    //assign count = sw;
    
    stringreco_wfs u_stringreo(
    .clk(clk_gen_bufg), //10Hz,
    .clr(clr),
    .en(en),
    .sw(sw),
    .count(count)
    );
    
    
    wire [3:0] thousands, hundreds, tens, ones;
    //bin2BCD
    binary2BCD_wfs u_binary2BCD(
    .binary_wfs(count[13:0]),
    .thousands_wfs(thousands),
    .hundreds_wfs(hundreds),
    .tens_wfs(tens),
    .ones_wfs(ones)
    );
    //display
    display_7seg_x4 u_display_7seg_x4(
    .CLK(clk), //100MHz
    .in0(ones),
    .in1(tens),
    .in2(hundreds),
    .in3(thousands),
    .seg(seg),
    .an(an)
    );
endmodule

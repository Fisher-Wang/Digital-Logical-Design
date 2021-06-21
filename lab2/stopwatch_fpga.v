`timescale 1ns / 1ps

module stopwatch_fpga(input clk,        //100MHz
                      input btnC,       //CLR Button
                      input btnD,       //PAUSE Button
                      output [0:6] seg,
                      output [0:3] an);
    
    //generate 10hz clock
    reg [23:0] cnt;
    reg clk_10Hz; //1KHz
    wire clk_10Hz_bufg;
    
    parameter PERIOD_CLK = 10000000;
    
    always @(posedge clk) begin
        if (cnt == PERIOD_CLK/2) begin
            cnt      <= 0;
            clk_10Hz <= ~clk_10Hz;
        end
        else
            cnt <= cnt + 1;
    end
    
    BUFG  CLK0_BUFG_INST (.I(clk_10Hz),
    .O(clk_10Hz_bufg));
    //generate 10Hz clock
    
    wire clr;
    wire en;
    
    reg sync_clr0, sync_clr1;
    always @(posedge clk_10Hz_bufg) begin
        sync_clr0 <= btnC;
        sync_clr1 <= sync_clr0;
    end
    assign clr = btnC | sync_clr1;
    
    reg sync_en0, sync_en1, sync_en2;
    reg en_reg;
    always @(posedge clk_10Hz_bufg) begin
        sync_en0 <= btnD;
        sync_en1 <= sync_en0;
        sync_en2 <= sync_en1;
    end
    
    always @(posedge clk_10Hz_bufg) begin
        if (clr)
            en_reg <= 0;
        else if (sync_en2 & ~sync_en1)
            en_reg <= ~en_reg;
    end
    assign en = en_reg;
        
    //stopwatch
    wire [3:0] ms100, sec1, sec10, min1;

    stopwatch_wfs u_stopwatch(
    .clk_10Hz(clk_10Hz_bufg), //10Hz,
    .clr(clr),
    .en(en),
    .min1(min1),
    .sec10(sec10),
    .sec1(sec1),
    .ms100(ms100)
    );

    //display
    display_7seg_x4 u_display_7seg_x4(
    .CLK(clk), //100MHz
    .in0(ms100),
    .in1(sec1),
    .in2(sec10),
    .in3(min1),
    .seg(seg),
    .an(an)
    );
endmodule

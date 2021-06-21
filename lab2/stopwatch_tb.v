`timescale 1ns / 1ps

module stopwatch_tb();
    reg clk_10Hz, clr, en_reg;
    //stopwatch
    wire [3:0] ms100, sec1, sec10, min1;
    initial begin
        
        //delete when vivado simulation
        $dumpfile("stopwatch.vcd");
        $dumpvars(0, u_stopwatch);
        $monitor("%d : %d %d : %d ", min1, sec10, sec1, ms100);
        //delete when vivado simulation
        
        clr      = 1;
        en_reg   = 1;
        #200 clr = 0;
        
        //delete when vivado simulation
        #1000000;
        $finish;
        //delete when vivado simulation
        
    end
    
    always begin
        clk_10Hz      = 0;
        #100 clk_10Hz = 1;
        #100;
    end
    
    stopwatch u_stopwatch(
    .clk_10Hz(clk_10Hz), //10Hz,
    .clr(clr),
    .en(en_reg),
    .min1(min1),
    .sec10(sec10),
    .sec1(sec1),
    .ms100(ms100)
    );
endmodule

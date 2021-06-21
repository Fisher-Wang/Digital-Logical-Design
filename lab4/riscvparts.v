// 
module regfile(input clk,
               input we3,
               input [4:0] ra1,
               input [4:0] ra2,
               input [4:0] wa3,
               input [31:0] wd3,
               output [31:0] rd1,
               output [31:0] rd2);
    
    reg [31:0] rf[31:0];
    
    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 0 hardwired to 0
    
    always @(posedge clk)
        if (we3) rf[wa3] <= wd3;
    
    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
    
// 加法
module adder(
    input [31:0] a,
    input [31:0] b,
    output [31:0] y);
    
    assign y = a + b;
endmodule

// 左移一位
module sl1(input  [31:0] a,
           output [31:0] y);
    
    // shift left by 2
    assign y = {a[30:0], 1'b0};
endmodule

// 12位有符号数扩展
module signext12(input  [11:0] a,
                 output [31:0] y);

    assign y = {{20{a[11]}}, a};
endmodule
    
// 20位有符号数扩展
module signext20(input  [19:0] a,
                 output [31:0] y);

    assign y = {{12{a[19]}}, a};
endmodule
    
module flopr #(parameter WIDTH = 8)
    (input clk,
     input reset,
     input      [WIDTH-1:0] d,
     output reg [WIDTH-1:0] q);
    
    always @(posedge clk, posedge reset) begin
        if (reset) q <= 0;
        else       q <= d;
    end
endmodule
        
module mux2 #(parameter WIDTH = 8)
    (input  [WIDTH-1:0] d0,
     input  [WIDTH-1:0] d1,
     input              s,
     output [WIDTH-1:0] y);
    
    assign y = s ? d1 : d0;
endmodule

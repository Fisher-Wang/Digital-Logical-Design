`timescale 1ns / 1ps

module stopwatch_wfs(
    input clk_10Hz, //10Hz,
    input clr,
    input en,
    output [3:0] min1,
    output [3:0] sec10,
    output [3:0] sec1,
    output [3:0] ms100
    );

reg en_10Hz;
reg [6:0] cnt;

wire min1_clr, sec10_clr, sec1_clr, ms100_clr;
wire min10_en, min1_en, sec10_en, sec1_en, ms100_en;
assign ms100_en = en;
assign sec1_en = (ms100==9) & ms100_en;
assign sec10_en = (sec1==9) & sec1_en;
assign min1_en = (sec10==5) & sec10_en;
assign min10_en = (min1==9) & min1_en;

assign ms100_clr = sec1_en | clr;
assign sec1_clr = sec10_en | clr;
assign sec10_clr = min1_en | clr;
assign min1_clr = min10_en | clr;

wfs_163 u_min1(
  .clk(clk_10Hz),
  .clr(min1_clr),
  .load(1'b0),
  .en(min1_en),
  .in_load(),
  .rco(),
  .Q(min1)
  );
  
wfs_163 u_sec10(
  .clk(clk_10Hz),
  .clr(sec10_clr),
  .load(1'b0),
  .en(sec10_en),
  .in_load(),
  .rco(),
  .Q(sec10)
  );
  
wfs_163 u_sec1(
  .clk(clk_10Hz),
  .clr(sec1_clr),
  .load(1'b0),
  .en(sec1_en),
  .in_load(),
  .rco(),
  .Q(sec1)
  );
  
wfs_163 u_ms100(
  .clk(clk_10Hz),
  .clr(ms100_clr),
  .load(1'b0),
  .en(ms100_en),
  .in_load(),
  .rco(),
  .Q(ms100)
  );
endmodule

module wfs_163(
    input clk,
    input clr,
    input load,
    input en,
    input [3:0] in_load,
    output rco,
    output [3:0] Q
    );
    
    reg [3:0] cnt;
    
    always @(posedge clk) begin
        if (clr)
            cnt <= 0;
        else
            if (load)
                cnt <= in_load;
            else if (en)
                cnt <= cnt + 1;
    end
    
    assign rco = (cnt == 4'b1111);
    assign Q = cnt;
endmodule

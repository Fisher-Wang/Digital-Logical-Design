module singleriscv_fpga(input clk,
                        input btnC,
                        btnU,
                        btnL,
                        btnD,
                        btnR,
                        input [15:0] sw,
                        output [15:0] led,
                        output [6:0] seg,
                        output [3:0] an);
    
    wire [3:0] btn;
    wire [31:0] pc, instr;
    wire [31:0] dmem_address, writedata, readdata;
    wire memwrite;
    
    wire [15:0] portb_in;
    wire [15:0] portc_out;
    wire [15:0] portd_out;
    
    assign bnt      = {btnL, btnC, btnR, btnU}; // add, sub, multiply,      = 
    // TODO: You need connect this portb_in to output of BCD2Bin module which input is sw;
    assign portb_in = sw;		
    
    //generate 10hz clock
    reg [23:0] cnt;
    reg clk_gen; //1KHz
    wire clk_gen_bufg;
    
    parameter PERIOD_CLK = 1000000;
    
    always @(posedge clk) begin
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
    assign mclk = clk_gen_bufg;
    
    reg rst_sync, btnU_reg;
    // synchronize reset input bnt[3]
    always @(posedge mclk) begin
        btnU_reg <= btnU;
        rst_sync <= btnU_reg;
    end
    
    assign reset_global = rst_sync | btnU;
    
    // instantiate devices to be tested
    singleriscv u_singleriscv(mclk, reset_global, pc, instr,
    memwrite, dmem_address, writedata, readdata);
    
    imem_fpga imem_fpga(pc[9:2], instr);
    
    dmem_io dmem_io(mclk, memwrite, dmem_address,
                    writedata, readdata, btn, portb_in, portc_out, portd_out);
    
    assign led = portd_out;

    // TODO: You need connect this IO to output of LED Driver which input is portc_out
    assign seg = 0;
    // TODO: You need connect this IO to output of LED Driver which input is portc_out
    assign an = 4'b1111;
    
endmodule

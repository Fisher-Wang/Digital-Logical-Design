module singleriscv_tb();
    
    reg clk;
    reg btnC, btnU, btnL, btnD, btnR;
    reg [15:0] sw;
    wire [15:0] led;
    wire [6:0] seg;
    wire [3:0] an;
    
    wire [3:0] btn;
    wire [31:0] pc, instr;
    wire [31:0] dmem_address, writedata, readdata;
    wire memwrite;
    
    wire [15:0] portb_in;
    wire [15:0] portc_out;
    wire [15:0] portd_out;
    
    assign bnt      = {btnL, btnC, btnR, btnU}; // add, sub, multiply,      = 
    assign portb_in = sw;		// You need connect this portb_in to output of BCD2Bin module which input is sw;
    
    // instantiate devices to be tested
    singleriscv u_singleriscv(mclk, reset_global, pc, instr,
        memwrite, dmem_address, writedata, readdata);
    
    imem imem(pc[9:2], instr);
    
    dmem_io dmem_io(mclk, memwrite, dmem_address,
        writedata, readdata, btn, portb_in, portc_out, portd_out);
    
    assign led = portd_out;
    assign seg = 0;		// You need connect this IO to output of LED Driver which input is portc_out
    assign an = 4'b1111;		// You need connect this IO to output of LED Driver which input is portc_out
    assign btn = {btnL, btnC, btnR, btnU};
    
    // initialize input
    initial begin
        {btnL, btnC, btnR, btnU} = 0;
        sw   <= 8'h0f;
        btnD <= 1; # 40; btnD <= 0;
    end
    
    assign reset_global = btnD;
    
    // generate clock to sequence tests
    always begin
    # 20;
    clk <= 1; # 20;
    clk <= 0;
    end
    
    assign mclk = clk;
    
    // check results
    always@(negedge clk) begin
        if (memwrite) begin
            if (dmem_address == 32'h00007ffc & writedata == 1) begin
                $display("Simulation succeeded");
                $stop;
            end
            else $display("Simulation Continue...");
            //$stop;
        end
    end
endmodule

module imem (input [7:0] a,
             output [31:0] rd);

	reg [31:0] RAM[256:0];

	initial begin
		$readmemh ("riscvtest.dat",RAM);
	end

	assign rd = RAM[a]; // word aligned

endmodule
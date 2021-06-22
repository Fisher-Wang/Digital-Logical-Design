module alu32 #(parameter WIDTH = 32)
              (input [31:0] srca,
               input [31:0] srcb,
               input [3:0] alucontrol,
               input [4:0] shamt,
               output [31:0] aluout,
               output zero);
    
    wire [31:0]addresult;
    wire [31:0]addresult1 = 0;
    reg[31:0] aluresult;
    wire[31:0] srcc;
    assign srcc = ~srcb+1;
    wire c0,c1,c2,c3;
    
    assign addresult = alucontrol[3] ? (srca - srcb) : (srca+srcb);
    
    always @* begin
        case (alucontrol[2:0])
            3'b000: aluresult    = addresult; //Add/SUB
            3'b001: aluresult    = srca << shamt; //SLL
            3'b010: aluresult    = (srca < srcb) ? 1 : 0; //SLT
            3'b011: aluresult    = {(WIDTH){1'bx}}; //SLTU
            3'b100: aluresult    = srca ^ srcb; //XOR
            3'b101: aluresult    = {{1'b0}, srca[WIDTH-1:1]}; //SRL/SRA, only shift by 1 in this lab
            // 3'b101: aluresult = alucontrol[3] ? (srca >>> shamt) : (srca >> shamt); // ok in 40MHz
            3'b110: aluresult    = srca | srcb; //OR
            3'b111: aluresult    = srca & srcb; //AND
            default: aluresult   = {(WIDTH){1'bx}};
        endcase
    end
    
    assign aluout = aluresult;
    assign zero   = (alucontrol[3]&&addresult == 0)?1:0;
endmodule

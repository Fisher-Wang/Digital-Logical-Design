module alu32 #(parameter WIDTH = 8)
              (input [WIDTH-1:0] srca,
               input [WIDTH-1:0] srcb,
               input [3:0] alucontrol,
               input [4:0] shamt,
               output reg [WIDTH-1:0] aluresult,
               output zero);
    
    assign addresult = alucontrol[3] ? (srca - srcb) : (srca + srcb);
    
    always @*
    begin
    case(alucontrol[2:0])
        3'b000: aluresult  = addresult;
        3'b001: aluresult  = srca << shamt;
        3'b010: aluresult  = (srca < srcb) ? 1 : 0;
        3'b011: aluresult  = {(WIDTH){1'bx}};
        3'b100: aluresult  = srca ^ srcb;
        3'b101: aluresult  = {{1'b0}, srca[WIDTH-1:1]};
        3'b110: aluresult  = srca | srcb;
        3'b111: aluresult  = srca & srcb;
        default: aluresult = {(WIDTH){1'bx}};
    endcase
    end
    
endmodule

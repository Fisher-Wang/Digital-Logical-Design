module CLA_4 (
    input C_in,
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out);

    wire [3:0] P, G;
    wire [4:0] C;

    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = C_in;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C_out = C[4];
endmodule

module CLA_32 (
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C_out);

    wire [8:0] C;
    genvar i;
    generate
        for (i = 0; i < 8; i = i+1) begin
            CLA_4 cla4(
                .C_in(C[i]), 
                .A(A[4*i+3 : 4*i]), 
                .B(B[4*i+3 : 4*i]), 
                .S(S[4*i+3 : 4*i]),
                .C_out(C[i+1])
            );
        end
    endgenerate

    assign C_out = C[8];
endmodule
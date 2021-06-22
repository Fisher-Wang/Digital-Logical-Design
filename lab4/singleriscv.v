// single-cycle RISC-V processor
module singleriscv(input          clk,
                   input          reset,
                   output  [31:0] pc,
                   input   [31:0] instr,
                   output         memwrite,
                   output  [31:0] aluout,
                   output  [31:0] writedata,
                   input   [31:0] readdata);
    
    wire        memtoreg, branch;
    wire        alusrc, resultlui, regwrite, jump;
    wire [3:0]  alucontrol;
    
    controller c(instr[6:0], instr[14:12], instr[31:25],
                 memtoreg, memwrite, branch,
                 alusrc, resultlui, regwrite, jump,
                 alucontrol);
    datapath dp(clk, reset, memtoreg, memwrite, branch,
                alusrc, resultlui, regwrite, jump,
                alucontrol,
                pc, instr,
                aluout, writedata, readdata);
endmodule
    
module controller(input  [6:0] op,
                  input  [2:0] funct3,
                  input  [6:0] funct7,
                  output       memtoreg,
                  output	   memwrite,
                  output       branch,
                  output	   alusrc,
                  output       resultlui,
                  output	   regwrite,
                  output       jump,
                  output [3:0] alucontrol);
    
    wire [1:0] aluop;
    
    maindec md(op, memtoreg, memwrite, branch,
              alusrc, resultlui, regwrite, jump,
              aluop);
    aludec  ad(funct7, funct3, aluop, alucontrol);
endmodule
    
module maindec(
    input  [6:0] op,
    output       memtoreg,
    output		 memwrite,
    output       branch,
    output		 alusrc,
    output       resultlui,
    output		 regwrite,
    output       jump,
    output [1:0] aluop);
    
    reg [8:0] controls;
    
    assign {regwrite, resultlui, alusrc,
            branch, memwrite,
            memtoreg, jump, aluop} = controls;
    
    always @(*)
        case(op)
        //  instr[6:0]
            7'b0110111: controls <= 9'b1100000_00; //LUI (load upper immediate)
            7'b0110011: controls <= 9'b1000000_10; //R-TYP
            7'b0000011: controls <= 9'b1010010_00; //LW (load word)
            7'b0100011: controls <= 9'b0010100_00; //SW (store word)
            7'b1100011: controls <= 9'b0001000_01; //BEQ
            7'b0010011: controls <= 9'b1010000_11; //I-TYPE
            7'b1101111: controls <= 9'b0000001_00; //JAL
            default:   controls  <= 9'bxxxxxx_xxx; //???
        endcase
endmodule
    
module aludec(
    input      [6:0] funct7,
    input	   [2:0] funct3,
    input      [1:0] aluop,
    output reg [3:0] alucontrol);
    
    always @(*)
        case(aluop)
            2'b00: alucontrol <= 4'b0000;  				// add
            2'b01: alucontrol <= 4'b1000;  				// sub
            2'b10: alucontrol <= {funct7[5], funct3};	// R-TYP
            2'b11: alucontrol <= {{1'b0}, funct3};		// I-TYP
            default: alucontrol <= 4'hx;
        endcase
endmodule
    
module datapath(
    input         clk,
    input		  reset,
    input         memtoreg,
    input		  memwrite,
    input		  branch,
    input         alusrc,
    input		  resultlui,
    input         regwrite,
    input	      jump,
    input  [3:0]  alucontrol, // add, sub, R-TYP, I-TYP
    output [31:0] pc,
    input  [31:0] instr,
    output [31:0] aluout,
    output [31:0] writedata,
    input  [31:0] readdata);
        
    wire [4:0]  writereg;
    wire        zero, pcsrc;
    wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
    wire [31:0] pcjump;
    wire [31:0] immext, swimmext;
    wire [31:0] srcbimmext;
    wire [31:0] branchimmext, branchimmextsh;
    wire [31:0] jumpimmext, jumpimmextsh;
    wire [31:0] srca, srcb;
    wire [4:0]  shamt;
    wire [31:0] aluout_lui, result;
    
    // next PC logic
    assign pcsrc = branch & zero;
    
    flopr #(32) pcreg(clk, reset, pcnext, pc);
    adder       pcadd1(pc, 32'b100, pcplus4);
    sl1         branchsh(branchimmext, branchimmextsh);
    sl1			jumpsh(jumpimmext, jumpimmextsh);
    adder       pcadd2(pc, branchimmextsh, pcbranch);
    adder		pcadd3(pc, jumpimmextsh, pcjump);
    // (pcsrc, jump) -> pcnext
    // (0, 0)        -> pcplus4
    // (1, 0)        -> pcbranch
    // (_, 1)        -> pcjump
    mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                        pcnextbr);
    mux2 #(32)  pcmux(pcnextbr, pcjump, jump,
                        pcnext);
    
    
    // register file logic
    // will write `result` to `writereg`
    // will read `srca` from `instr[19:15]`
    // will read `writedata` from `instr[24:20]`
    regfile     rf(clk, regwrite, instr[19:15],
                   instr[24:20], writereg,
                   result, srca, writedata);
    
    
    assign writereg = instr[11:7];

    // equivalent to
    // (resultlui, memtoreg) -> result
    // (0, 0)                -> aluout
    // (1, 0)                -> {instr[31:12], {12{1'b0}}}
    // (_, 1)                -> readdata
    mux2 #(32)  luimux(aluout, {instr[31:12], {12{1'b0}}},
                       resultlui, aluout_lui);
    mux2 #(32)  resmux(aluout_lui, readdata,
                       memtoreg, result);
    
    signext12   se12_imm(instr[31:20], immext);
    signext12	sel2_sw({instr[31:25], instr[11:7]}, swimmext);
    signext20	se21_jump({instr[31], instr[19:12], instr[20], instr[30:21]}, jumpimmext);
    signext12   se12_br({instr[31], instr[7], instr[30:25], instr[11:8]}, branchimmext);
    
    // ALU logic
    // memwrite -> srcbimmext
    // 0        -> immext
    // 1        -> swimmext
    mux2 #(32)  swmux(immext, swimmext, memwrite, srcbimmext);
    // alusrc -> srcb
    // 0      -> writedata
    // 1      -> srcbimmext
    mux2 #(32)  srcbmux(writedata, srcbimmext, alusrc, srcb);
    
    assign shamt = instr[24:20];
    alu32 #(32) alu(srca, srcb, alucontrol, shamt,
                    aluout, zero);
        
endmodule

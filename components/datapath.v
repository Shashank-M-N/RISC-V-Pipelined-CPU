// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         ALUSrc, RegWrite, MemWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
    input         Branch, Jump, Jalr,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] ResultW,
    output [31:0] PCW, ALUResultW, WriteDataW,
    output [31:0] InstrD,
    output        MemWriteM,
    output [2:0]  funct3M
);

wire [31:0] PCNext, PCJalr, PCPlus4, PCTargetE, AuiPC, lAuiPC, lAuiPCM, lAuiPCW;
wire [31:0] ImmExtD, ImmExtE;
wire [31:0] PCD, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W, PCM, PCE;
wire [31:0] ReadData1, ReadData2, ReadData1E, ReadData2E, ReadDataW, WriteDataE, WriteDataM, ALUResultE, ALUResultM;
wire [31:0] SrcAE, SrcBE;
wire [19:0] InstrE_31_12;
wire [4:0] Rs1D, Rs2D, RdD, Rs1E, Rs2E, RdE, RdM, RdW;
wire [3:0] ALUControlE;
wire [2:0] funct3E;
wire [1:0] ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
wire Zero, TakeBranch, InstrE_5;
wire RegWriteE, MemWriteE, JumpE, JalrE, BranchE, ALUSrcE;
wire RegWriteM;
wire RegWriteW;
wire StallF, StallD, FlushE, FlushD;
wire [1:0] ForwardAE, ForwardBE;

wire PCSrcE = ((BranchE & TakeBranch) || JumpE || JalrE) ? 1'b1 : 1'b0;

// next PC logic
mux2 #(32)     pcmux(PCPlus4, PCTargetE, PCSrcE, PCNext);
mux2 #(32)     jalrmux (PCNext, ALUResultE, JalrE, PCJalr);

reset_ff #(32) pcreg(clk, reset, StallF, PCJalr, PC);
adder #(32)    pcadd4(PC, 32'd4, PCPlus4);

// Pipeline Register 1 -> Fetch | Decode
pl_reg_fd      plfd(clk, StallD, FlushD, Instr, PC, PCPlus4, InstrD, PCD, PCPlus4D);

adder #(32)    pcaddbranch(PCE, ImmExtE, PCTargetE);

// register file logic
reg_file       rf (clk, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, ResultW, ReadData1, ReadData2);
imm_extend     ext (InstrD[31:7], ImmSrc, ImmExtD);

// Pipeline Register 2 -> Decode | Execute
pl_reg_de      plde(clk, FlushE, RegWrite, MemWrite, Jump, Jalr, Branch, ALUSrc, ResultSrc, ALUControl, ReadData1, ReadData2, PCD, PCPlus4D, 
                    InstrD[19:15], InstrD[24:20], InstrD[11:7], ImmExtD, InstrD[14:12], InstrD[31:12], InstrD[5], RegWriteE, MemWriteE, JumpE, JalrE, BranchE, 
                    ALUSrcE, ResultSrcE, ALUControlE, ReadData1E, ReadData2E, PCE, PCPlus4E, Rs1E, Rs2E, RdE, ImmExtE, funct3E, InstrE_31_12, InstrE_5);

mux3 #(32)     FAE(ReadData1E, ResultW, ALUResultM, ForwardAE, SrcAE);
mux3 #(32)     FBE(ReadData2E, ResultW, ALUResultM, ForwardBE, WriteDataE);

// ALU logic
mux2 #(32) srcbmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
alu alu (SrcAE, SrcBE, ALUControlE, ALUResultE, Zero);

adder #(32) auipcadder ({InstrE_31_12, 12'b0}, PCE, AuiPC);
mux2 #(32) lauipcmux (AuiPC, {InstrE_31_12, 12'b0}, InstrE_5, lAuiPC);

// Branching unit
branching_unit bu(funct3E, Zero, ALUResultE[31], TakeBranch);

// Pipeline Register 3 -> Execute | Memory
pl_reg_em      plem(clk, RegWriteE, MemWriteE, ResultSrcE, ALUResultE, WriteDataE, PCPlus4E, RdE, PCE, lAuiPC, funct3E,
                    RegWriteM, MemWriteM, ResultSrcM, ALUResultM, WriteDataM, PCPlus4M, RdM, PCM, lAuiPCM, funct3M);

// Pipeline Register 4 -> Memory | Writeback
pl_reg_mw      plmw(clk, RegWriteM, ResultSrcM, ALUResultM, ReadData, PCPlus4M, RdM, PCM, WriteDataM, lAuiPCM,
                    RegWriteW, ResultSrcW, ALUResultW, ReadDataW, PCPlus4W, RdW, PCW, WriteDataW, lAuiPCW); 

// Result Source
mux4 #(32)     resultmux(ALUResultW, ReadDataW, PCPlus4W, lAuiPCW, ResultSrcW, ResultW);

// hazard unit
hazard         hazardunit(InstrD[19:15], InstrD[24:20], Rs1E, Rs2E, RdE, RdM, RdW, ResultSrcE[0], RegWriteM, RegWriteW, PCSrcE,
                          StallF, StallD, FlushE, FlushD, ForwardAE, ForwardBE);

assign Mem_WrData = WriteDataM;
assign Mem_WrAddr = ALUResultM;

endmodule
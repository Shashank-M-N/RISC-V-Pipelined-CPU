module pl_reg_de (
    input             clk, clr,
    input             RegWriteD, MemWriteD, JumpD, JalrD, BranchD, ALUSrcD,
    input [1:0]       ResultSrcD,
    input [3:0]       ALUControlD,
    input [31:0]      ReadData1D, ReadData2D,
    input [31:0]      PCD, PCPlus4D,
    input [4:0]       Rs1D, Rs2D, RdD,
    input [31:0]      ImmExtD,
    input [2:0]       funct3D,
    input [19:0]      InstrD_31_12,
    input             InstrD_5,
    output reg        RegWriteE, MemWriteE, JumpE, JalrE, BranchE, ALUSrcE,
    output reg [1:0]  ResultSrcE,
    output reg [3:0]  ALUControlE,
    output reg [31:0] ReadData1E, ReadData2E,
    output reg [31:0] PCE, PCPlus4E,
    output reg [4:0]  Rs1E, Rs2E, RdE,
    output reg [31:0] ImmExtE,
    output reg [2:0]  funct3E,
    output reg [19:0] InstrE_31_12,
    output reg        InstrE_5
);

always @(posedge clk) begin
    if (clr) begin
        RegWriteE <= 0;
        MemWriteE <= 0;
        JumpE <= 0;
		  JalrE <= 0;
        BranchE <= 0;
        ALUSrcE <= 0;
        ResultSrcE <= 0;
        ALUControlE <= 0;
        ReadData1E <= 0;
        ReadData2E <= 0;
        PCE <= 0;
        PCPlus4E <= 0;
        Rs1E <= 0;
        Rs2E <= 0;
        RdE <= 0;
        ImmExtE <= 0;
        funct3E <= 0;
        InstrE_31_12 <= 0;
        InstrE_5 <= 0;
    end else begin
        RegWriteE <= RegWriteD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
		  JalrE <= JalrD;
        BranchE <= BranchD;
        ALUSrcE <= ALUSrcD;
        ResultSrcE <= ResultSrcD;
        ALUControlE <= ALUControlD;
        ReadData1E <= ReadData1D;
        ReadData2E <= ReadData2D;
        PCE <= PCD;
        PCPlus4E <= PCPlus4D;
        Rs1E <= Rs1D;
        Rs2E <= Rs2D;
        RdE <= RdD;
        ImmExtE <= ImmExtD;
        funct3E <= funct3D;
        InstrE_31_12 <= InstrD_31_12;
        InstrE_5 <= InstrD_5;
    end
end

endmodule
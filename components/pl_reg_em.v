// pl_reg_em.v - pipeline register between Execute and Memory stages

module pl_reg_em (
    input             clk,
    input             RegWriteE, MemWriteE,
    input [1:0]       ResultSrcE,
    input [31:0]      ALUResultE, WriteDataE, PCPlus4E,
    input [4:0]       RdE,
	 input [31:0]      PCE, lAuiPCE,
	 input [2:0]       funct3E,
    output reg        RegWriteM, MemWriteM,
    output reg [1:0]  ResultSrcM,
    output reg [31:0] ALUResultM, WriteDataM, PCPlus4M,
    output reg [4:0]  RdM,
	 output reg [31:0] PCM, lAuiPCM,
	 output reg [2:0]  funct3M
);

always @(posedge clk) begin
	RegWriteM <= RegWriteE;
   MemWriteM <= MemWriteE;
   ResultSrcM <= ResultSrcE;
   ALUResultM <= ALUResultE;
   WriteDataM <= WriteDataE;
   PCPlus4M <= PCPlus4E;
   RdM <= RdE;
	PCM <= PCE;
	lAuiPCM <= lAuiPCE;
	funct3M <= funct3E;
end

endmodule
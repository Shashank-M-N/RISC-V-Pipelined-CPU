// pl_reg_mw.v - pipeline register between Memory and Writeback stages

module pl_reg_mw (
    input             clk,
    input             RegWriteM,
    input [1:0]       ResultSrcM,
    input [31:0]      ALUResultM, ReadDataM, PCPlus4M,
    input [4:0]       RdM,
	 input [31:0]      PCM, WriteDataM, lAuiPCM,
    output reg        RegWriteW,
    output reg [1:0]  ResultSrcW,
    output reg [31:0] ALUResultW, ReadDataW, PCPlus4W,
    output reg [4:0]  RdW,
	 output reg [31:0] PCW, WriteDataW, lAuiPCW
);

always @(posedge clk) begin
	RegWriteW <= RegWriteM;
   ResultSrcW <= ResultSrcM;
   ALUResultW <= ALUResultM;
   ReadDataW <= ReadDataM;
   PCPlus4W <= PCPlus4M;
   RdW <= RdM;
	PCW <= PCM;
	WriteDataW <= WriteDataM;
	lAuiPCW <= lAuiPCM;
end

endmodule
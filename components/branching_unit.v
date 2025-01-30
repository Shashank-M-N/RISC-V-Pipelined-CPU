// branching_unit.v - Logic for branching in execute stage

module branching_unit (
    input [2:0] funct3,      // Function code to determine branch type
    input       Zero,        // Zero flag from ALU
    input       ALUR31,      // ALU result for R31 (signed comparison)
    output reg  Branch       // Branch decision output
);

always @(*) begin
    case (funct3)
        3'b000: Branch =    Zero;    // beq: Branch if equal
        3'b001: Branch =   !Zero;    // bne: Branch if not equal
        3'b100: Branch =  ALUR31;    // blt: Branch if less than (signed)
        3'b101: Branch = !ALUR31;    // bge: Branch if greater or equal (signed)
        3'b110: Branch =  ALUR31;    // bltu: Branch if less than (unsigned)
        3'b111: Branch = !ALUR31;    // bgeu: Branch if greater or equal (unsigned)
        default: Branch = 1'b0;      // Default: No branch
    endcase
end

endmodule

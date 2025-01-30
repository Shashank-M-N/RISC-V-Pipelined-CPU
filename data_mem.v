
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input [2:0] funct3,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output reg  [DATA_WIDTH-1:0] rd_data_mem
);

// array of 64 32-bit data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

wire [ADDR_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64;

// synchronous write logic
always @(posedge clk) begin
    /*
    Purpose:
    ---
    This always block handles write operations on the positive edge of the clock signal. It writes
    to memory based on the funct3 encoding, supporting word (sw), half-word (sh), and byte (sb) stores.
    */
    
    if (wr_en) begin
        if (funct3 == 3'b010) begin
            // sw: Store word
            data_ram[word_addr] <= wr_data;
        end
        case ({funct3, wr_addr[1:0]})
            5'b000_00: data_ram[word_addr][ 7: 0] <= wr_data[7:0];  // sb: Store byte
            5'b000_01: data_ram[word_addr][15: 8] <= wr_data[7:0];  // sb: Store byte
            5'b000_10: data_ram[word_addr][23:16] <= wr_data[7:0];  // sb: Store byte
            5'b000_11: data_ram[word_addr][31:24] <= wr_data[7:0];  // sb: Store byte

            5'b001_00: data_ram[word_addr][15: 0] <= wr_data[15:0]; // sh: Store half-word
            5'b001_10: data_ram[word_addr][31:16] <= wr_data[15:0]; // sh: Store half-word
        endcase
    end
end

// combinational read logic
always @(*) begin
    /*
    Purpose:
    ---
    This always block handles read operations based on funct3. It supports word (lw), half-word (lh/lhu),
    and byte (lb/lbu) loads with appropriate sign extension for signed loads.
    */
    
    if (funct3 == 3'b010) begin
        // lw: Load word
        rd_data_mem = data_ram[word_addr];
    end
    case ({funct3, wr_addr[1:0]})
        5'b000_00: rd_data_mem = {{24{data_ram[word_addr][ 7]}}, data_ram[word_addr][ 7:  0]}; // lb: Load signed byte
        5'b000_01: rd_data_mem = {{24{data_ram[word_addr][15]}}, data_ram[word_addr][15:  8]}; // lb: Load signed byte
        5'b000_10: rd_data_mem = {{24{data_ram[word_addr][23]}}, data_ram[word_addr][23: 16]}; // lb: Load signed byte
        5'b000_11: rd_data_mem = {{24{data_ram[word_addr][31]}}, data_ram[word_addr][31: 24]}; // lb: Load signed byte

        5'b001_00: rd_data_mem = {{16{data_ram[word_addr][15]}}, data_ram[word_addr][15: 0]};  // lh: Load signed half-word
        5'b001_10: rd_data_mem = {{16{data_ram[word_addr][31]}}, data_ram[word_addr][31:16]};  // lh: Load signed half-word

        5'b100_00: rd_data_mem = {24'b0, data_ram[word_addr][ 7:  0]};                         // lbu: Load unsigned byte
        5'b100_01: rd_data_mem = {24'b0, data_ram[word_addr][15:  8]};                         // lbu: Load unsigned byte
        5'b100_10: rd_data_mem = {24'b0, data_ram[word_addr][23: 16]};                         // lbu: Load unsigned byte
        5'b100_11: rd_data_mem = {24'b0, data_ram[word_addr][31: 24]};                         // lbu: Load unsigned byte

        5'b101_00: rd_data_mem = {16'b0, data_ram[word_addr][15:0]};                           // lhu: Load unsigned half-word
        5'b101_10: rd_data_mem = {16'b0, data_ram[word_addr][31:16]};                          // lhu: Load unsigned half-word
    endcase
end

endmodule

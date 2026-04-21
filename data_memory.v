module data_memory(
    input wire clk,
    input wire [31:0] address,
    input wire [31:0] write_data,
    input wire mem_write,
    input wire mem_read,
    output wire [31:0] read_data
);
    // Create a 1KB memory (256 words of 32-bits)
    reg [31:0] ram [0:255];

    // Synchronous Write: Memory is updated on the clock edge
    always @(posedge clk) begin
        if (mem_write)
            ram[address[9:2]] <= write_data; // Bit slicing to align to word addresses
    end

    // Asynchronous Read: Data is available immediately
    assign read_data = (mem_read) ? ram[address[9:2]] : 32'b0;

endmodule

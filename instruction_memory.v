`timescale 1ns / 1ps
module instruction_memory (
    input wire [31:0] addr,    // Changed from 'address'
    output wire [31:0] data    // Changed from 'instruction'
);
    // Physical storage limited for simulation; first 10 addresses populated
    reg [31:0] mem [0:1023]; 

   initial begin
    // 0: ADDI $1, $0, 10  -> Hex: 2001000A (Put 10 in Reg 1)
    mem[0] = 32'h2001000A; 
    
    // 1: ADDI $2, $0, 5   -> Hex: 20020005 (Put 5 in Reg 2)
    mem[1] = 32'h20020005; 
    
    // 2: ADD $3, $1, $2   -> Hex: 00221820
    // This adds Reg 1 (10) + Reg 2 (5) and puts it in Reg 3.
    mem[2] = 32'h00221820; 
    
    // 3: SW $3, 0($0)     -> Hex: AC030000 (Store result to RAM)
    mem[3] = 32'hAC030000;
    
    // 4+: NOPs to fill the pipeline
    mem[4] = 32'h00000000;
    mem[5] = 32'h00000000;
end
    

    // use 31-2 
    assign data = mem[addr[31:2]]; 
endmodule
`timescale 1ns / 1ps

module ex_mem(
    input wire clk,
    input wire [1:0] ctlwb_out,
    input wire [2:0] ctlm_out,
    input wire [31:0] adder_out,
    input wire aluzero,
    input wire [31:0] aluout,
    input wire [31:0] readdat2,
    input wire [4:0] muxout,

    output reg [1:0] wb_ctlout,
    output reg branch, memread, memwrite,
    output reg [31:0] add_result,
    output reg zero,
    output reg [31:0] alu_result,
    output reg [31:0] rdata2out,
    output reg [4:0] five_bit_muxout
);

    // Pipeline registers only update on the rising edge of the clock
    always @(posedge clk) begin
        wb_ctlout       <= ctlwb_out;
        branch          <= ctlm_out[2];
        memread         <= ctlm_out[1];
        memwrite        <= ctlm_out[0];
        add_result      <= adder_out;
        zero            <= aluzero;
        alu_result      <= aluout;
        rdata2out       <= readdat2;
        five_bit_muxout <= muxout;
    end

endmodule
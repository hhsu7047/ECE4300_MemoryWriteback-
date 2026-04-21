module mem_wb(
    input wire clk,
    input wire [1:0] wb_ctl_in,
    input wire [31:0] mem_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] muxout_in,

    output reg [1:0] wb_ctl_out,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] muxout_out
);

    always @(posedge clk) begin
        wb_ctl_out     <= wb_ctl_in;
        mem_data_out   <= mem_data_in;
        alu_result_out <= alu_result_in;
        muxout_out     <= muxout_in;
    end

endmodule
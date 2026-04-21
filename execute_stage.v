`timescale 1ns / 1ps

module execute_stage(
    input wire clk,                // Required for the EX/MEM Latch
    input wire [1:0] wb_ctl,       // Write-back control signals
    input wire [2:0] m_ctl,        // Memory control signals
    input wire regdst,             // Control for destination register mux
    input wire alusrc,             // Control for ALU input mux
    input wire [1:0] aluop,        // Control for ALU Control unit
    input wire [31:0] npcout,      // PC + 4 from Fetch/Decode
    input wire [31:0] rdata1,      // Data from Register RS
    input wire [31:0] rdata2,      // Data from Register RT
    input wire [31:0] s_extendout, // Sign-extended immediate
    input wire [4:0] instrout_2016, // RT field (for I-type dest)
    input wire [4:0] instrout_1511, // RD field (for R-type dest)

    // Outputs from the EX/MEM Latch to the next stage
    output wire [1:0] wb_ctlout,
    output wire branch, memread, memwrite,
    output wire [31:0] EX_MEM_NPC,
    output wire zero,
    output wire [31:0] alu_result,
    output wire [31:0] rdata2out,
    output wire [4:0] five_bit_muxout
);

    // Internal Wires connecting the sub-modules
    wire [31:0] adder_out;
    wire [31:0] alu_b_input;
    wire [31:0] alu_out_raw;
    wire [4:0]  mux_dest_out;
    wire [2:0]  alu_control_signal;
    wire        alu_zero_raw;

    // 1. Branch Target Adder (NPC + SignExtend)
    adder branch_adder (
        .add_in1(npcout),
        .add_in2(s_extendout << 2), // Shifted for MIPS word alignment
        .add_out(adder_out)
    );

    // 2. ALU Source Mux (Selects between Register Data 2 and Immediate)
    top_mux alu_mux (
        .a(s_extendout),    // Input 1
        .b(rdata2),         // Input 0
        .alusrc(alusrc),
        .y(alu_b_input)
    );

    // 3. ALU Control Unit
    alu_control alu_ctrl_unit (
        .funct(s_extendout[5:0]),
        .aluop(aluop),
        .select(alu_control_signal)
    );

    // 4. Main ALU
    alu main_alu (
        .a(rdata1),
        .b(alu_b_input),
        .control(alu_control_signal),
        .result(alu_out_raw),
        .zero(alu_zero_raw)
    );

    // 5. Destination Register Mux (Selects between RT and RD)
    bottom_mux dest_mux (
        .a(instrout_1511),  // Input 1 (RD)
        .b(instrout_2016),  // Input 0 (RT)
        .sel(regdst),
        .y(mux_dest_out)
    );

    // 6. EX/MEM Pipeline Register (The Latch)
    // This is the boundary between the Execute and Memory stages
    ex_mem pipeline_latch (
        .clk(clk),            // Pass the clock down
        .ctlwb_out(wb_ctl),
        .ctlm_out(m_ctl),
        .adder_out(adder_out),
        .aluzero(alu_zero_raw),
        .aluout(alu_out_raw),
        .readdat2(rdata2),
        .muxout(mux_dest_out),
        
        // Final Outputs
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .add_result(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
        );
        endmodule
        
        
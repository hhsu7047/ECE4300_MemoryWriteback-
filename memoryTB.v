`timescale 1ns / 1ps

module memoryTB();
    reg clk;
    
    // Input regs to the Memory Stage
    reg [31:0] alu_result;       
    reg [31:0] rdata2out;        
    reg [4:0]  five_bit_muxout;  
    reg [1:0]  wb_ctl;           
    reg        memwrite, memread, branch, zero;

    // Output wires from the Memory Stage
    wire [31:0] read_data;
    wire [31:0] alu_result_out;
    wire [4:0]  five_bit_muxout_wb;
    wire [1:0]  wb_ctlout;
    wire        pc_src;

  
    memory_stage uut (
        .clk(clk),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout),
        .wb_ctl(wb_ctl),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch),
        .zero(zero),
        .read_data(read_data),
        .alu_result_out(alu_result_out),
        .five_bit_muxout_wb(five_bit_muxout_wb),
        .wb_ctlout(wb_ctlout),
        .pc_src(pc_src)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    
    initial begin
        alu_result = 0; 
        rdata2out = 0; 
        five_bit_muxout = 0;
        wb_ctl = 0; 
        memwrite = 0; 
        memread = 0; 
        branch = 0; 
        zero = 0;
        #15; // Wait to offset from the clock edge

        // --- STEP 1: The Write (Store Word) ---
        $display("Starting Write Test...");
        alu_result = 32'h00000004;    
        rdata2out = 32'h12345678;     
        five_bit_muxout = 5'h02;      
        wb_ctl = 2'b11;               
        memwrite = 1;                 
        memread = 0;
        #10;                          

        // --- STEP 2: The Gap ---
        memwrite = 0;                 
        #10;                          

        // --- STEP 3: The Read (Load Word) ---
        $display("Starting Read Test...");
        memread = 1;                  
        #5;                           
        
        if (read_data === 32'h12345678) 
            $display("SUCCESS: Data matches!");
        else 
            $display("ERROR: Expected 12345678, got %h", read_data);
        
        #5; 

        // --- STEP 4: The Branch Check ---
        $display("Testing Branch Logic...");
        branch = 1;
        zero = 1;
        #10;
        
        if (pc_src === 1) 
            $display("SUCCESS: Branch Logic Correct.");
        else
            $display("ERROR: pc_src did not flip to 1.");

        #20;
        $finish;    
    end
endmodule
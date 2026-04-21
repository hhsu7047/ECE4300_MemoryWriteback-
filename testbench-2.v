`timescale 1ns/1ps

module testbench;

    // testbench inputs
    reg clk;
    reg rst;
    reg [1:0] wb;
    reg [2:0] mem;
    reg zero;
    reg [31:0] aluResult;
    reg [31:0] readData2;
    reg [4:0] fiveBitMux;
    
    // testbench output
    wire regWrite;
    wire [4:0] memWriteReg;
    wire pcSrc;
    wire [31:0] writeData;
    
    // memorywriteback module
    memorywriteback mwb0(
        .clk(clk),
        .rst(rst),
        .wb(wb),
        .mem(mem),
        .zero(zero),
        .aluResult(aluResult),
        .readData2(readData2),
        .fiveBitMux(fiveBitMux),
        .regWrite(regWrite),
        .memWriteReg(memWriteReg),
        .pcSrc(pcSrc),
        .writeData(writeData)
    );
    
    // start clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // set up conditions
    initial begin
        rst = 1'b1;
        wb = 2'b0;
        mem = 3'b0;
        zero = 1'b0;
        aluResult = 32'b0;
        readData2 = 32'b0;
        fiveBitMux = 5'b0;
        
        #1 
        rst = 0;
        
        #1 
        rst = 1;
        
        // wb = 01 so writeData is data from address aluResult (ece04300)
        // mem still = 0, so no write
        wb = 2'b01;
        
        // second clock cycle
        // aluResult increment by 1
        // wb = 01 so writeData is data from address aluResult (ba5eba11)
        // mem still = 0, so no write
        #10
        aluResult = 32'b1;
        
        // wb = 00 so writeData is now address aluResult (00000001)
        // mem still = 0, so no write
        #20
        wb = 2'b00;
        
        // wb = 01 so writeData is data from address aluResult (first ba5eba11, then 2 clk cycles later 00000000)
        // this is because one clk cycle for data memory, second for latch
        // mem = 3'b010, so write readData2 to address aluResult
        #10
        wb = 2'b01;
        mem = 3'b010;
        
        // branch
        // mem = 3'b001
        // zero = 1'b1
        // pcSrc = zero & memBranch (1)
        #10
        mem = 3'b001;
        zero = 1'b1;
        
        // end simulation
        #20 
        $finish;
    
    end
    
endmodule    
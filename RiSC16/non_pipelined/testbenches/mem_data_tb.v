`include "defines.v"

module mem_reg_tb;
    wire[`WORD_LEN-1:0]       dataOut;    // Data for reading
    reg[`ADDR_LEN-1:0]        readAddr;   // Address for reading
    reg[`ADDR_LEN-1:0]        writeAddr;  // Address for writing
    reg[`WORD_LEN-1:0]        dataIn;     // Data for writing

    reg clk;                              // Clock signal
    reg writeEn;                          // Active high signal for enabling write    
    reg rst;                              // Reset whole memory to 0

    mem_data tud (dataOut, readAddr, writeAddr, dataIn, clk, writeEn, rst);

    initial clk = 0;
    always  #1 clk = ~clk;

    integer i;

    initial begin
        $dumpfile("testbenches/mem_data.vcd");
        $dumpvars(0, mem_reg_tb);
        
        for(i = 0; i < 10; i = i + 1)
            $dumpvars(0, tud.memory[i]);
        rst = 1'b1;
        #2
        rst = 1'b0;

        readAddr = 2;
        
        // Write to registers
        writeEn = 1'b1;
        for(i = 0; i < 8; i = i + 1) begin
            dataIn = i**2 + 10;
            writeAddr = 2*i;
            #2;
        end
        writeEn = 1'b0;
        
        // Read from stored addresses
        for(i = 0; i < 8; i = i + 1) begin
            readAddr = 2 * i;
            #2;
        end

        $finish;
    end
endmodule

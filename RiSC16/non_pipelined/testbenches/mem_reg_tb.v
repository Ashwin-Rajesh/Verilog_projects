`include "defines.v"

module mem_reg_tb;
    wire[`WORD_LEN-1:0]    out1;           // Read output 1
    wire[`WORD_LEN-1:0]    out2;           // Read output 2

    reg[`REG_ADDR_LEN-1:0]      src1;      // Read address 1
    reg[`REG_ADDR_LEN-1:0]      src2;      // Read address 2
    reg[`REG_ADDR_LEN-1:0]      tgt;       // Write register address

    reg[`WORD_LEN-1:0]     in;             // Input to write
    reg clk;                              // Clock signal
    reg writeEn;                          // Write enable
    reg rst;                              // Reset all stored values to 0

    mem_reg tud(out1, out2, src1, src2, tgt, in, clk, writeEn, rst);

    initial clk = 0;
    always  #1 clk = ~clk;

    integer i, j, k;

    initial begin
        $dumpfile("testbenches/mem_reg.vcd");
        $dumpvars(0, mem_reg_tb);

        src2 = 2;
        
        // Write to registers
        writeEn = 1'b1;
        for(i = 0; i < 8; i = i + 1) begin
            in = i**2 + 10;
            tgt = i;
            #2;
        end
        writeEn = 1'b0;
        
        // Read from stored addresses
        for(i = 0; i < 8; i = i + 1) begin
            src1 = i;
            src2 = 7 - i;
            #2;
        end

        $finish;
    end
endmodule

`include "./defines.v"

// Register file
// 8 registers, indexed from 000 to 111.
// R0 always stores 0. It cannot be written to.

// Ports
// data - Datapath
// cntr - Controller

// Outputs
// data : out1      : Output from port 1
// data : out2      : Output from port 2

// Inputs
// data : src1      : Read address for port 1
// data : src2      : Read address for port 2
// data : tgt       : Write address
// data : in        : Data to write
// cntr : clk       : Clock signal (positive edge triggered)
// cntr : writeEn   : Write enable (active high)
// cntr : rst       : Reset all to 0 (active high)

module mem_reg (out1, out2, src1, src2, tgt, in, clk, writeEn, rst);
    output[`WORD_LEN-1:0]    out1;           // Read output 1
    output[`WORD_LEN-1:0]    out2;           // Read output 2

    input[`REG_ADDR_LEN-1:0]      src1;      // Read address 1
    input[`REG_ADDR_LEN-1:0]      src2;      // Read address 2
    input[`REG_ADDR_LEN-1:0]      tgt;       // Write register address

    input[`WORD_LEN-1:0]     in;             // Input to write
    input clk;                              // Clock signal
    input writeEn;                          // Write enable
    input rst;                              // Reset all stored values to 0

    reg [`WORD_LEN-1:0] memory[0:`REG_FILE_SIZE];
    
    integer i;

    assign out1 = memory[src1];
    assign out2 = memory[src2];

    always @(negedge clk) begin : write_block
        if(rst)
            for(i = 0; i < `REG_FILE_SIZE; i = i + 1)
                memory[i] <= 0;
        
        else if(writeEn)
            if(tgt != 0)
                memory[tgt] = in; 
    end
endmodule

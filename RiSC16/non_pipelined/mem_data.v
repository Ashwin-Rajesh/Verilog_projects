`include "defines.v"

// Instruction memory

// Ports
// data - Datapath
// cntr - Controller

// Outputs
// data : dataOut   : Data read

// Inputs
// data : readAddr  : Address for reading
// data : writeAddr : Address for writing
// data : dataIn    : Data for writing
// cntr : clk       : Clock signal
// cntr : writeEn   : Enable for writing (active high)
// cntr : rst       : Reset data to 0 (active high)


module mem_data (dataOut, readAddr, writeAddr, dataIn, clk, writeEn, rst);
    output[`WORD_LEN-1:0]       dataOut;    // Data for reading
    
    input[`ADDR_LEN-1:0]        readAddr;   // Address for reading
    input[`ADDR_LEN-1:0]        writeAddr;  // Address for writing
    input[`WORD_LEN-1:0]        dataIn;     // Data for writing

    input clk;                              // Clock signal
    input writeEn;                          // Active high signal for enabling write    
    input rst;                              // Reset whole memory to 0

    // We cannot simulate 2**ADDR_LEN, so we choose a smaller instruction memory size
    wire[$clog2(`DATA_MEM_SIZE):0] readAddr_trunc = 
        readAddr[$clog2(`DATA_MEM_SIZE):0];
    wire[$clog2(`DATA_MEM_SIZE):0] writeAddr_trunc = 
        writeAddr[$clog2(`DATA_MEM_SIZE):0];

    reg[`MEM_CELL_SIZE-1:0] memory[0:`DATA_MEM_SIZE];

    integer i;
    // Reset memory by reading from the file code/reset.data
    always @(posedge clk) begin
        if(rst)
            for (i = 0; i < `DATA_MEM_SIZE; i = i + 1) begin
                memory[i] <= 0;
            end
        else if(writeEn) begin
            {memory[writeAddr_trunc], memory[writeAddr_trunc+1]} <= dataIn;
            $display(".");
        end
    end

    assign dataOut = {memory[readAddr_trunc], memory[readAddr_trunc+1]};
endmodule

`include "defines.v"

// Instruction memory

// Ports
// data - Datapath
// cntr - Controller

// Outputs
// data : out       : Instruction read

// Inputs
// data : addr      : Instruction address
// cntr : rst       : Reset instruction memory (from code/reset.data)

module mem_instr (out, addr, rst);
    output[`WORD_LEN-1:0]       out;        // Instruction read from address
    
    input[`ADDR_LEN-1:0]        addr;       // Address to read instruction from
    input rst;                              // Reset the instruction memory

    // We cannot simulate 2**ADDR_LEN, so we choose a smaller instruction memory size
    wire[$clog2(`INSTR_MEM_SIZE):0] addr_trunc = 
    addr[$clog2(`INSTR_MEM_SIZE):0];

    reg[`MEM_CELL_SIZE-1:0] memory[0:`INSTR_MEM_SIZE];

    // Reset memory by reading from the file code/reset.data
    always @(*) begin
        if(rst)
            $readmemb("code/reset.data", memory);
    end

    assign out = {memory[addr_trunc], memory[addr_trunc+1]};
endmodule

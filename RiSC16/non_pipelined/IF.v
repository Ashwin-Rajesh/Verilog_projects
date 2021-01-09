// Instruction fetch stage

module IF(next_pc, instr, clk, reset, alu_out, mux_pc) ;

    output reg[`WORD_LEN-1:0] instr;            // Instruction register
    output[`WORD_LEN-1:0] next_pc;              // Next program counter

    input clk;                                  // Clock
    input reset;                                // Reset
    input[`WORD_LEN-1:0]    alu_out;            // ALU output
    input[1:0]              mux_pc;             // For selecting source for next PC

    reg[`WORD_LEN-1:0]      pc;                 // Program counter
    
    wire[`WORD_LEN-1:0]     branch_pc;          // Program counter for branch type instructions
    wire[`WORD_LEN-1:0]     next_instr;         // Output from instruction memory

    wire[15:0]              sig_imm;            // Signed immediate value after sign extension
    
    assign sig_imm  = {{9{instr[6]}}, instr[6:0]};
    
    // Assign program counter variables
    assign next_pc   = pc + 2;
    assign branch_pc = next_pc + (sig_imm << 1);  
    
    // Instruction memory instance
    mem_instr d(
        .out(next_instr),
        .addr(pc),
        .rst(reset)
    );
    
    always @(posedge clk) begin
        if(reset) begin
            pc = 0;
            instr = 0;
        end
        else begin
                case(mux_pc)
                `SEL_PC_NPC     : pc = next_pc;
                `SEL_PC_BRANCH  : pc = branch_pc;
                `SEL_PC_ALU     : pc = alu_out; 
                default : pc = pc;
            endcase
            instr = next_instr;
        end
    end

endmodule

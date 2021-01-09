`include "defines.v"

module control (clk, reset);
    input clk;
    input reset;

    // // Instruction module
    // // Note that instructions always start at even addresses. 
    // // So, pc stores only the top 15 bits. The last bit is always 0.
    // reg[`WORD_LEN-2:0]      pc;                 // Program counter
    // reg[`WORD_LEN-1:0]      instr;              // Instruction register

    // wire[`WORD_LEN-2:0]     next_pc;            // Next program counter
    // wire[`WORD_LEN-2:0]     branch_pc;          // Program counter for branch type instructions
    // wire[`WORD_LEN-1:0]     next_instr;         // Output from instruction memory

    // wire[2:0]               opcode;             // Slices of instruction register
    // wire[2:0]               regA;
    // wire[2:0]               regB;
    // wire[2:0]               regC;
    // wire[15:0]              sig_imm;            // Value after sign-extension
    // wire[15:0]              imm;                // Value after left-shift

    // assign opcode   = instr[15:13];
    // assign regA     = instr[12:10];
    // assign regB     = instr[9:7];
    // assign regC     = instr[2:0];
    // assign sig_imm  = {{9{instr[6]}}, instr[6:0]};
    // assign imm      = instr[9:0] << 6;

    // assign next_pc   = pc + 1;
    // assign branch_pc = next_pc + sig_imm;  

    // // Instruction fetching circuit
    // mem_instr d(
    //     .out(next_instr),
    //     .addr({pc,0}),
    //     .rst(reset)
    // );

    // always @(posedge clk) begin
    //     case(mux_pc)
    //         0       : pc = next_pc;
    //         1       : pc = branch_pc;
    //         2       : pc = alu_out; 
    //         default : pc = pc;
    //     endcase
    //     instr = next_instr; 
    // end
    
    // Instruction fetch stage wires
    wire[`ADDR_LEN-1:0]     next_pc;        // Datapath
    wire[`WORD_LEN-1:0]     instr;          // Datapath

    wire[2:0]               opcode;         // Control in

    // Register file wires
    wire[`WORD_LEN-1:0]     reg_src1;       // Datapath
    wire[`WORD_LEN-1:0]     reg_src2;       // Datapath
    wire[`WORD_LEN-1:0]     reg_in;         // Datapath

    wire[`REG_ADDR_LEN-1:0] reg_src1_addr;  // Datapath
    wire[`REG_ADDR_LEN-1:0] reg_src2_addr;  // Datapath
    wire[`REG_ADDR_LEN-1:0] reg_tgt_addr;   // Datapath

    reg                     reg_writeEn;    // Control out

    // ALU wires
    wire[`WORD_LEN-1:0]     alu_ina;        // Datapath
    wire[`WORD_LEN-1:0]     alu_inb;        // Datapath
    wire[`WORD_LEN-1:0]     alu_out;        // Datapath
    
    reg[`FUNCT_LEN-1:0]     alu_funct;      // Control out
    wire                    alu_stat;       // Control in

    // Data memory wires
    wire[`WORD_LEN-1:0]     mem_dataOut;    // Datapath

    reg                     mem_writeEn;    // Control out

    // Multiplexer control signals
    reg[1:0]                mux_pc;         // Control out
    reg[1:0]                mux_tgt;        // Control out
    reg                     mux_rt;         // Control out
    reg                     mux_alua;       // Control out
    reg                     mux_alub;       // Control out

    // Instruction fetch stage
    IF fetch_stage(
        // Output
        next_pc, 
        instr, 
        // Input
        clk, 
        reset, 
        alu_out, 
        mux_pc
    );

    // Register file
    mem_reg reg_file(
        // Outputs
        reg_src1,
        reg_src2,
        // Inputs
        reg_src1_addr,
        reg_src2_addr,
        reg_tgt_addr,
        reg_in,
        clk,
        reg_writeEn,
        reset
    );

    // Instruction decode stage
    ID decode_stage(
        // Outputs
        alu_ina,
        alu_inb,
        reg_tgt_addr,
        reg_src1_addr,
        reg_src2_addr,
        // Inputs
        reg_src1,
        reg_src2,
        instr,
        mux_rt,
        mux_alua,
        mux_alub
    );

    // Execute stage (ALU)
    alu exec_stage(
        // Outputs
        alu_out, 
        alu_stat,
        // Inputs 
        alu_ina, 
        alu_inb, 
        alu_funct
    );

    // Data memory stage
    mem_data mem_stage(
        // Outputs
        mem_dataOut, 
        // Inputs
        alu_out, 
        reg_src2, 
        clk, 
        mem_writeEn, 
        reset
    );

    // Writeback stage
    WB writeback_stage(
        // Outputs
        reg_in,
        // Inputs
        alu_out,
        mem_dataOut,
        next_pc,
        mux_tgt
    );
        
    // Control stage
    assign opcode = instr[15:13];

    always @(alu_stat or opcode) case (opcode)
        `OPCODE_ADD     : begin 
            alu_funct   <= `FUNCT_ADD;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_REG;
            mux_rt      <= `SEL_REGT_REGC;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b1;
            mem_writeEn <= 1'b0;
            end
        `OPCODE_ADDI    : begin 
            alu_funct   <= `FUNCT_ADD;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_IMM;
            mux_rt      <= `SEL_REGT_REGC;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b1;
            mem_writeEn <= 1'b0;
            end
        `OPCODE_NAND    : begin 
            alu_funct   <= `FUNCT_NAND;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_REG;
            mux_rt      <= `SEL_REGT_REGC;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b1;
            mem_writeEn <= 1'b0;
            end
        `OPCODE_LUI     : begin 
            alu_funct   <= `FUNCT_PASSA;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_IMM;
            mux_alub    <= `SEL_ALUB_REG;
            mux_rt      <= `SEL_REGT_REGC;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b1;
            mem_writeEn <= 1'b0;
            end
        `OPCODE_SW      : begin 
            alu_funct   <= `FUNCT_ADD;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_IMM;
            mux_rt      <= `SEL_REGT_REGA;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b0;
            mem_writeEn <= 1'b1;
            end
        `OPCODE_LW      : begin 
            alu_funct   <= `FUNCT_ADD;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_IMM;
            mux_rt      <= `SEL_REGT_REGA;
            mux_tgt     <= `SEL_TGT_MEM;
            
            reg_writeEn <= 1'b1;
            mem_writeEn <= 1'b0;
            end
        `OPCODE_BEQ     : begin 
            alu_funct   <= `FUNCT_SUB;

            mux_pc      <= alu_stat ? `SEL_PC_BRANCH : `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_REG;
            mux_rt      <= `SEL_REGT_REGA;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b0;
            mem_writeEn <= 1'b0;
            end
        `OPCODE_JALR    : begin 
            alu_funct   <= `FUNCT_PASSA;
            
            mux_pc      <= `SEL_PC_ALU;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_REG;
            mux_rt      <= `SEL_REGT_REGA;
            mux_tgt     <= `SEL_TGT_ALU;
            
            reg_writeEn <= 1'b1;
            mem_writeEn <= 1'b0;
            end
        default         : begin 
            alu_funct   <= `FUNCT_PASSA;
            
            mux_pc      <= `SEL_PC_NPC;
            mux_alua    <= `SEL_ALUA_REG;
            mux_alub    <= `SEL_ALUB_REG;
            mux_rt      <= `SEL_REGT_REGA;
            mux_tgt     <= `SEL_TGT_NPC;
            
            reg_writeEn <= 1'b0;
            mem_writeEn <= 1'b0;
            end
    endcase
endmodule

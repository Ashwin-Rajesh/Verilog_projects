`include "defines.v"

// Instruction decode stage

module ID(
    // Outputs
    outa,
    outb,
    tgt_addr,
    src1_addr,
    src2_addr,
    // Inputs
    src1,
    src2,
    instr,
    mux_rt,
    mux_outa,
    mux_outb
);
    output[`WORD_LEN-1:0]       outa;
    output[`WORD_LEN-1:0]       outb;

    output[`REG_ADDR_LEN-1:0]   tgt_addr;
    output[`REG_ADDR_LEN-1:0]   src1_addr;
    output[`REG_ADDR_LEN-1:0]   src2_addr;   

    input[`WORD_LEN-1:0]        src1;
    input[`WORD_LEN-1:0]        src2;
    input[`WORD_LEN-1:0]        instr;
    input mux_rt;
    input mux_outa;
    input mux_outb;    

    // Slices of the instruction register
    wire[2:0]               regA;
    wire[2:0]               regB;
    wire[2:0]               regC;
    wire[15:0]              sig_imm;            // Value after sign-extension
    wire[15:0]              imm;                // Value after left-shift

    // Slice and apply required sign extension or shifting
    assign regA     = instr[12:10];
    assign regB     = instr[9:7];
    assign regC     = instr[2:0];
    assign sig_imm  = {{9{instr[6]}}, instr[6:0]};
    assign imm      = instr[9:0] << 6;

    assign tgt_addr  = regA;
    assign src1_addr = regB;
    assign src2_addr = mux_rt ? regC : regA;

    assign outa = mux_outa ? src1 : imm;
    assign outb = mux_outb ? src2 : sig_imm;

endmodule
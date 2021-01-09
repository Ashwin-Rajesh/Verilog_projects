`include "defines.v"

module WB(
    // Outputs
    tgt,
    // Inputs
    alu_out,
    data_out,
    pc_next,
    mux_tgt
);
    output reg[`WORD_LEN-1:0] tgt;

    input[`WORD_LEN-1:0] alu_out;
    input[`WORD_LEN-1:0] data_out;
    input[`WORD_LEN-1:0] pc_next;
    input[1:0] mux_tgt;

    always @(*)
    case (mux_tgt)
        `SEL_TGT_NPC    : tgt <= pc_next;
        `SEL_TGT_ALU    : tgt <= alu_out;
        `SEL_TGT_MEM    : tgt <= data_out;
        default         : tgt <= tgt;
    endcase
endmodule

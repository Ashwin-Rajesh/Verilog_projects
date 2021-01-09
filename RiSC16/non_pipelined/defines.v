
// Length of word, address bus
`define WORD_LEN        16
`define ADDR_LEN        16

// Size of memory modules
`define DATA_MEM_SIZE   500
`define INSTR_MEM_SIZE  500
`define REG_FILE_SIZE   8
`define REG_ADDR_LEN    3
`define MEM_CELL_SIZE   8

// Function codes for ALU
`define FUNCT_LEN       2

`define FUNCT_ADD       2'b00
`define FUNCT_NAND      2'b01
`define FUNCT_PASSA     2'b10
`define FUNCT_SUB       2'b11

// Opcode definitions
`define OPCODE_ADD      3'b000
`define OPCODE_ADDI     3'b001
`define OPCODE_NAND     3'b010
`define OPCODE_LUI      3'b011
`define OPCODE_SW       3'b100
`define OPCODE_LW       3'b101
`define OPCODE_BEQ      3'b110
`define OPCODE_JALR     3'b111

// Multiplexer select codes
// Program counter loader mux
`define SEL_PC_NPC      2'b00
`define SEL_PC_BRANCH   2'b01
`define SEL_PC_ALU      2'b10
// ALU input A select
`define SEL_ALUA_REG    1'b1
`define SEL_ALUA_IMM    1'b0
// ALU input B select
`define SEL_ALUB_REG    1'b1
`define SEL_ALUB_IMM    1'b0
// ALU target (source 1) register select from register bank
`define SEL_REGT_REGC   1'b1
`define SEL_REGT_REGA   1'b0
// ALU destination register write data
`define SEL_TGT_NPC     2'b00
`define SEL_TGT_ALU     2'b01
`define SEL_TGT_MEM     2'b10 
// 

// Length of word, address bus
`define WORD_LEN        16
`define ADDR_LEN        16

// Size of memory modules
`define DATA_MEM_SIZE   2 ** `ADDR_LEN
`define INSTR_MEM_SIZE  2 ** `ADDR_LEN
`define REG_FILE_SIZE   8
`define REG_ADDR_LEN    3
`define MEM_CELL_SIZE   8
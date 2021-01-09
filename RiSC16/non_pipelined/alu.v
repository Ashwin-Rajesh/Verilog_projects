`include "defines.v"

// ALU

// Ports
// data - Datapath
// cntr - Controller

// Outputs
// data : out   : Output of ALU
// cntr : stat  : Status signal

// Inputs
// data : ina   : Input a
// data : inb   : Input b
// cntrl: funct : Function to be performed

// Functions
// ADD      : out =   ina + inb
// NAND     : out = ~(ina & inb)

// Status bits
// 0        : out == 0

module alu (out, stat, ina, inb, funct);
    output reg[`WORD_LEN-1:0] out;      // Output of ALU
    output stat;                        // Status signals

    input[`WORD_LEN-1:0]    ina;        // Input a
    input[`WORD_LEN-1:0]    inb;        // Input b
    input[`FUNCT_LEN-1:0]   funct;      // Function to be performed

    assign stat = out == {`WORD_LEN{1'b0}};

    always @(*) begin
        case(funct)
            `FUNCT_ADD  : out <= ina + inb;
            `FUNCT_NAND : out <= ~(ina & inb);
            `FUNCT_PASSA: out <= ina;
            `FUNCT_SUB  : out <= ina - inb;
            default     : out <= 0;
        endcase
    end
endmodule
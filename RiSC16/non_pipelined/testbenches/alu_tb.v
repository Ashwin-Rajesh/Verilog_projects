`include "defines.v"

module alu_tb;

    wire[`WORD_LEN-1:0]   out;
    wire stat;

    reg[`WORD_LEN-1:0]    ina;
    reg[`WORD_LEN-1:0]    inb;
    reg[`FUNCT_LEN-1:0]   funct;

    alu dut(out, stat, ina, inb, funct);

    initial begin
        $dumpfile("testbenches/alu.vcd");
        $dumpvars(0, alu_tb);

        for(ina = 0; ina < 2; ina = ina + 1)
            for(inb = 2; inb > 0; inb = inb - 1)begin
                #1 funct = 0;
                #1 funct = 1;
            end

        ina = 10;
        inb = -10;
        funct = 0;
        #1;
    end

endmodule
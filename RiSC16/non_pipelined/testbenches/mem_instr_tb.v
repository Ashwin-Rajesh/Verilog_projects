`include "defines.v"

module mem_instr_tb;
    wire[`WORD_LEN-1:0]       out;
    
    reg[`ADDR_LEN-1:0]        addr;
    reg rst;

    mem_instr dut (out, addr, rst);

    integer i;

    initial begin
        $dumpfile("testbenches/mem_instr.vcd");
        $dumpvars(0, mem_instr_tb);
        
        rst = 1'b1; 
        #2 rst = 1'b0;
        
        // Read from stored addresses
        for(i = 0; i < 100; i = i + 1) begin
            addr = i;
            #1;
        end

        $finish;
    end
endmodule

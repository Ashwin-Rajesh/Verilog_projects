module alu_tb;
    // Port declaration
    reg[7:0] inputa, 
            inputb, 
            mode;

    reg clk = 0;
    
    wire[7:0] out, 
            status;

    alu mod(inputa, inputb, mode, clk, out, status);

    initial
    begin
        $dumpfile("alu.vcd");
        $dumpvars(0, mod);

        inputa = 8'b0;
        inputb = -1;

        mode = 8'b0;

        #5 mode = 8'b1110;
        #10 $finish;
    end

    initial forever #2 clk = ~clk;

endmodule
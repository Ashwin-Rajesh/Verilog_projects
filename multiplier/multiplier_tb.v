module multiplier_tb;
    parameter WIDTH = 16;

    reg[WIDTH - 1:0]        ina, inb;
    reg                     clk;
    wire[2 * WIDTH - 1:0]   out;
    reg[2 * WIDTH - 1:0]    ref;

    multiplier #(WIDTH) mod(ina, inb, clk, out);

    initial begin
        $monitor("%8d * %8d = %16d", ina, inb, out);

        $dumpfile("multiplier.vcd");
        $dumpvars(0, multiplier_tb);

        clk = 0;

        #200 $finish;
    end

    always begin
        #19 
        ina = $random;
        inb = $random;
        ref = ina * inb;
        clk = 0;
        
        #1
        clk = 1;
    end

endmodule
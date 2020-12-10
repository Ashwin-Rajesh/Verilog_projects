`include "dff.v"

module dff_tb();

    reg d, clk;
    wire q, qbar;
    
    dff flipflop(d, clk, q, qbar);
    
    defparam 
        flipflop.delay=2,
        flipflop.diffdelay=2;

    // Initialise values (d = 0, clk = 0) and run simulation for 100 seconds
    initial
    begin
        $monitor("d = %b, clk = %b, q = %b, qbar = %b", d, clk, q, qbar);
        $dumpfile("dff.vcd");
        $dumpvars(0, dff_tb);
        d = 0;
        clk = 0;
        #25 $finish;
    end

    // Flip clk input every 5 seconds
    always
    begin
        #5 clk = ~clk;
    end

    // First wait 2 seconds and then flip d input every 10 seconds
    always
    begin
        #8     d = !d;
        #2;
    end

endmodule
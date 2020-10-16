`include "counter.v"

module counter_tb();

    reg clock, reset, enable;
    wire[7:0] out;

    counter counter(.clk(clock), .reset(reset), .enable(enable), .out(out));

    initial begin
        $monitor("%g  : %b, %b, %b, %b", $time, clock, reset, enable, out);
        
        $dumpfile("counter.vcd");
        $dumpvars(1, counter);
        clock = 1'b1;
        reset = 1'b0;
        enable = 1'b1;

        #1000 reset = 1;
        #100 enable = 0;
        #100 $finish;
    end

    always begin
        #10 clock = ~clock;
    end

endmodule
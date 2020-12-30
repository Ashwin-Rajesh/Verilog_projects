module pattern_detector_tb;
    reg in, clk;
    wire out;

    pattern_detector mod(in, clk, out);

    initial
    begin
        $display("Time, In, Out");
        $monitor($time, "%b, %b", in, out);

        $dumpfile("pattern_detector.vcd");
        $dumpvars(0, mod);

        #100 $finish;
    end

    always begin
       #1 in = $random;
       clk = 0;
       #1 clk = 1; 
    end
endmodule
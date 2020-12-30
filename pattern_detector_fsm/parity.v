module pattern_detector(in, clk, out);

    input in, clk;
    output reg out;

    initial out = 0;

    always @(posedge clk)
        if(in)
            out <= ~out;

endmodule

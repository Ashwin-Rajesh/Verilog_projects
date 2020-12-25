module mux_tb;
    
    reg[7:0] in;
    reg[2:0] sel;
    wire out;

    mux #(.sel_width(3)) mux_instance(.in(in), .sel(sel), .out(out));

    initial
    begin
        in = 0;

        $dumpfile("mux.vcd");
        $dumpvars(0, mux_instance);
        
        $display("%9s| %4s-> %s", "Input", "Sel", "out");
        $monitor("%b | %b -> %b", in, sel, out);

    end

    initial
    begin
        sel = 0;

        repeat(8)
            #32 sel = sel + 1;

        $finish;
    end

    always #1 in = in + 1;

endmodule

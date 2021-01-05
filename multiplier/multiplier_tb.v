module multiplier_tb;
    parameter WIDTH = 8;

    reg signed[WIDTH - 1:0]        ina, inb;
    reg                     clk;
    reg                     clk2;
    reg                     start;
    wire [2 * WIDTH - 1:0]   out;
    reg signed [2 * WIDTH - 1:0]    ref;
    reg [2*WIDTH-1 : 0]     absref;
    wire                    ready; 

    wire [2 * WIDTH - 1:0] eq = ~(out ^ ref);

    integer i;

    // simple_unsigned_multiplier #(WIDTH) tud(ina, inb, clk, out);
    // seq_unsigned_multiplier #(WIDTH) tud(ina, inb, clk2, start, out, ready);
    // streamlined_multiplier #(WIDTH) tud(ina, inb, clk2, start, out, ready);
    // signed_streamlined_multiplier #(WIDTH) tud(ina, inb, clk2, start, out, ready);
    // radix_4_multiplier #(WIDTH) tud(ina, inb, clk2, start, out, ready);
    radix_2_booth_multiplier #(WIDTH) tud(ina, inb, clk2, start, out, ready);

    initial begin
        $monitor("%8d * %8d = %16d", ina, inb, out);

        $dumpfile("multiplier.vcd");
        $dumpvars(0, multiplier_tb);
        // for(i = 0; i < WIDTH; i = i + 1)
        //     $dumpvars(0, tud.partial_sum[i]);    

        clk     = 0;
        clk2    = 0;

        #500 $finish;
    end

    always begin
        #19 
        ina = $random;
        inb = $random;
        ref = ina * inb;
        absref = (absolute(ina) * absolute(inb));
        clk = 0;
        start = 1;
        
        #1
        start = 0;
        clk = 1;
    end

    always #0.5 clk2 = ~clk2;

    function[WIDTH-1:0] absolute;
        input[WIDTH-1:0] in;

        absolute = (in[WIDTH-1])? -in : in;
    endfunction
endmodule
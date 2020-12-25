module adder_tb;
    reg[3:0] a, b;
    reg cin;

    wire[3:0] s;
    wire cout;

    adder mod(a, b, cin, s, cout);

    initial
    begin
        $dumpfile("adder.vcd");
        $dumpvars(0, mod);

        a = 0;
        b = 0;
        cin = 0;

        $monitor("%4d + %4d + %1b = %4d, %1b", a, b, cin, s, cout);

        repeat(10)
        begin
            #10;
            a = $random;
            b = $random;
        end
    end
endmodule
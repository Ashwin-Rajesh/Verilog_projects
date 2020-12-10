// Two input and gate test bench

`timescale 1s/100ms
`include "and2.v"

module and2_tb();
    reg a;
    reg b;
    wire y;

    and2 aandb(a,b,y);

    initial
    begin
        $monitor("a=%b, b=%b, y=%b", a, b, y);
        $dumpfile("and2.vcd");
        $dumpvars(0, and2_tb);
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        $finish;    
    end
endmodule
module full_adder(a, b, cin, s, cout);
    parameter delay = 1;
    
    input   a, b, cin;
    output  s, cout;

    assign #1 {cout, s} = a + b + cin;
endmodule

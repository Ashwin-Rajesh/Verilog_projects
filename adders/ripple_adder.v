`include "full_adder.v"

module adder(a, b, cin, s, cout);

    input[3:0]  a, b;
    input       cin;

    output[3:0] s;
    output      cout;

    wire[3:0] c;

    assign c[0] = cin;

    full_adder fa1(a[0], b[0], c[0], s[0], c[1]);
    full_adder fa2(a[1], b[1], c[1], s[1], c[2]);
    full_adder fa3(a[2], b[2], c[2], s[2], c[3]);
    full_adder fa4(a[3], b[3], c[3], s[3], cout);
    
endmodule

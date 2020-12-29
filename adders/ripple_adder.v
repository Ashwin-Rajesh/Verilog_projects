`include "full_adder.v"

module adder(a, b, cin, s, cout);
    parameter WIDTH = 4;

    input[WIDTH-1:0]  a, b;
    input       cin;

    output[WIDTH-1:0] s;
    output      cout;

    wire[WIDTH:0] c;

    assign c[0] = cin;
    assign cout = c[WIDTH];

    genvar i;

    generate for (i = 0; i < WIDTH; i = i + 1) 
        full_adder fa(a[i], b[i], c[i], s[i], c[i+1]);     
    endgenerate
    
endmodule

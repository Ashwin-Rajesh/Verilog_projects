module adder(a, b, cin, s, cout);
    input[3:0] a,b;
    input cin;

    output[3:0] s;
    output cout;

    wire[3:0] g;
    wire[3:0] p;
    wire[3:0] c;

    assign c[0] = cin;

    assign #1 g = a & b;
    assign #1 p = a ^ b;

    assign #1 s = p ^ c;

    assign #1 c[1] = g[0] | (c[0] & p[0]);
    assign #1 c[2] = g[1] | &{g[0],p[1]} | &{c[0],p[1:0]};
    assign #1 c[3] = g[2] | &{g[1],p[2]} | &{g[0],p[2:1]} | &{g[0],p[2:0]};
    assign #1 cout = g[3] | &{g[2],p[3]} | &{g[1],p[3:2]} | &{g[0], p[3:1]} | &{c[0], p[3:0]};

endmodule
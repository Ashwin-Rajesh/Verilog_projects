module adder(a, b, cin, s, cout);
    parameter WIDTH = 4;
    
    input[WIDTH-1:0]    a,b;
    input               cin;

    output[WIDTH-1:0]   s;
    output              cout;

    wire[WIDTH-1:0]     g, p;
    wire[WIDTH:0]       c;

    assign c[0] = cin;
    assign cout = c[WIDTH];

    assign #1 g = a & b;
    assign #1 p = a ^ b;
    assign #1 s = a ^ b ^ c;

    genvar i;
    genvar j;
    generate 
        for (i = 0; i < WIDTH ; i = i + 1)
        begin
            wire[i+1:0] temp;
            
            assign temp[0] = &{c[0], p[i:0]};
            assign temp[i+1] = g[i];

            for (j = 1; j < i+1; j = j + 1)
                assign temp[j] = &{g[j-1], p[i:j]};

            assign c[i+1] = |(temp);
        end
                
    endgenerate

endmodule
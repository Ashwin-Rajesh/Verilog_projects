module multiplier(ina, inb, clk, out);
    parameter WIDTH=8;
    
    input [WIDTH-1: 0]          ina, inb;
    input                       clk;
    output reg [2*WIDTH - 1: 0] out;
    reg[2*WIDTH-1 : 0]          temp;

    integer                     i;

    always @(posedge clk)
    begin    
        temp = 0;

        // Standard multiplication algorithm
        for(i = 0; i < 2 * WIDTH; i=i+1)
            if(inb[i] == 1'b1)
                temp <= #1 temp + (ina << i);

        out = temp;
    end
endmodule
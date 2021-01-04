module seq_unsigned_multiplier(ina, inb, clk, start, out, ready);

    parameter WIDTH = 8;

    input[WIDTH - 1: 0]         ina;
    input[WIDTH - 1: 0]         inb;
    input                       clk;
    input                       start;

    output reg[2*WIDTH-1: 0]    out;
    output reg                  ready;

    reg[2*WIDTH - 1:0]          partial_product;
    reg[4:0]                    bit;
    reg[2*WIDTH-1: 0]           multiplicand;
    reg[WIDTH-1: 0]             multiplier;

    always @(posedge clk)
    begin
        if(start == 1'b1) begin
            multiplicand = ina;
            multiplier   = inb;
            bit          = WIDTH;
            partial_product         = 0;
            ready        = 1'b0;
        end

        if(bit != 4'b0) begin
            if(multiplier[0] == 1'b1)
                partial_product = partial_product + multiplicand;
            multiplicand = multiplicand << 1;
            multiplier   = multiplier >> 1;
            bit          = bit - 1;

            if(bit == 1'b0) begin
                out = partial_product;
                ready = 1'b1; 
            end
        end
    end
    
endmodule
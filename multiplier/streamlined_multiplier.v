module streamlined_multiplier(ina, inb, clk, start, out, ready);

    parameter WIDTH             = 8;

    input[WIDTH - 1: 0]         ina;
    input[WIDTH - 1: 0]         inb;
    input                       clk;
    input                       start;

    output reg[2*WIDTH-1: 0]    out;
    output reg                  ready;

    reg[2*WIDTH - 1:0]          partial_product;
    reg[4:0]                    bit;
    reg[WIDTH-1: 0]           multiplicand;
    
    always @(posedge clk)
    begin : mult_block
        reg lsb;

        if(start == 1'b1) begin
            multiplicand = ina;
            bit          = WIDTH;
            partial_product = {{WIDTH+1{1'b0}}, inb};
            ready        = 1'b0;
        end

        else if(bit != 4'b0) begin
            
            lsb = partial_product[0];
            
            partial_product = partial_product >> 1;
            bit          = bit - 1;
            
            if(lsb == 1'b1)
                partial_product[2*WIDTH-1:WIDTH-1] = partial_product[2*WIDTH-2:WIDTH-1] + multiplicand;
            
            if(bit == 1'b0) begin
                out = partial_product;
                ready = 1'b1; 
            end
        end
    end
    
endmodule
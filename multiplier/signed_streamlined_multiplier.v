module signed_streamlined_multiplier(ina, inb, clk, start, out, ready);

    parameter WIDTH             = 8;

    input[WIDTH - 1: 0]         ina;
    input[WIDTH - 1: 0]         inb;
    input                       clk;
    input                       start;

    output reg[2*WIDTH-1: 0]    out;
    output reg                  ready;

    reg[2*WIDTH - 1:0]          partial_product;
    reg[4:0]                    bit_count;
    reg[WIDTH-1: 0]             multiplicand;
    reg                         out_sign;
    
    always @(posedge clk)
    begin : mult_block
        reg lsb;

        if(start == 1'b1) begin
            multiplicand = absolute(ina);
            bit_count          = WIDTH;
            partial_product = {{WIDTH+1{1'b0}}, absolute(inb)};
            ready        = 1'b0;
            out_sign     = ina[WIDTH-1] ^ inb[WIDTH-1];
        end

        else if(bit_count != 4'b0) begin
            
            lsb = partial_product[0];
            
            partial_product = partial_product >> 1;
            bit_count          = bit_count - 1;
            
            if(lsb == 1'b1)
                partial_product[2*WIDTH-1:WIDTH-1] = partial_product[2*WIDTH-2:WIDTH-1] + multiplicand;
            
            if(bit_count == 1'b0) begin
                out = out_sign?-partial_product:partial_product;
                ready = 1'b1; 
            end
        end
    end

    function[WIDTH-1:0] absolute;
        input[WIDTH-1:0] in;

        absolute = (in[WIDTH-1])? -in : in;
    endfunction
    
endmodule
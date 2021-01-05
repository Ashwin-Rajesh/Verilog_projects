module radix_2_booth_multiplier(ina, inb, clk, start, out, ready);

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

    always @(posedge clk)
    begin : mult_block
        reg[1:0] lsb;
        reg[WIDTH+1:0] term;
        if(start) begin
            ready           = 1'b0;
            bit_count       = WIDTH;
            partial_product = {{WIDTH{1'b0}}, inb};
            multiplicand    = ina;
            lsb[1]          = 1'b0;
        end

        if(bit_count != 4'b0) begin
            lsb = {partial_product[0],lsb[1]};
            
            case(lsb)
                2'b01 : partial_product[2*WIDTH-1:WIDTH] = partial_product[2*WIDTH-1:WIDTH] + multiplicand;
                2'b10 : partial_product[2*WIDTH-1:WIDTH] = partial_product[2*WIDTH-1:WIDTH] - multiplicand;
            endcase
            
            partial_product = {partial_product[2*WIDTH-1], partial_product[2*WIDTH-1:1]};
            bit_count       = bit_count - 1;

            if(bit_count == 4'b0) begin
                out = partial_product;
                ready = 1'b1;
            end
        end

    end

endmodule
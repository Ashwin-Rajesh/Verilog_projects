module radix_4_multiplier(ina, inb, clk, start, out, ready);

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
    
    wire[WIDTH+1: 0]             multiplicand_X1 = multiplicand;
    wire[WIDTH+1: 0]             multiplicand_X2 = multiplicand << 1;
    wire[WIDTH+1: 0]             multiplicand_X3 = multiplicand_X1 + multiplicand_X2;
    
    always @(posedge clk)
    begin : mult_block
        reg[1:0]        lsb;
        reg[WIDTH+1:0]  term;

        if(start == 1'b1) begin
            multiplicand = ina;
            bit_count          = WIDTH/2;
            partial_product = {{WIDTH+1{1'b0}}, inb};
            ready        = 1'b0;
        end

        else if(bit_count != 4'b0) begin
            
            lsb = partial_product[1:0];
            
            partial_product = partial_product >> 2;
            bit_count          = bit_count - 1;
            
            case(lsb)
                2'd0 : term = 0;
                2'd1 : term = multiplicand_X1;
                2'd2 : term = multiplicand_X2;
                2'd3 : term = multiplicand_X3;
            endcase

            partial_product[2*WIDTH-1:WIDTH-2] = partial_product[2*WIDTH-1:WIDTH-2] + term;
            
            if(bit_count == 1'b0) begin
                out = partial_product;
                ready = 1'b1; 
            end
        end
    end 
    
endmodule
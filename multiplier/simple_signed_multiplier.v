module simple_signed_multiplier(ina, inb, clk, out);
    parameter WIDTH=8;
    
    input [WIDTH-1: 0]          ina, inb;
    input                       clk;
    output reg [2*WIDTH - 1: 0] out;
    
    wire[2*WIDTH-1 : 0]         partial_sum[0:WIDTH-1];

    genvar i;

    assign partial_sum[0] = {(2*WIDTH){inb[0]}} & ina; 
    
    generate
        begin
            for(i = 1; i < WIDTH; i = i + 1) begin : mult_stage
                assign partial_sum[i] = partial_sum[i-1] + ({(2*WIDTH){inb[i]}} & ina);
            end
        end
    endgenerate
    
    always @(posedge clk) out = partial_sum[WIDTH-1];
endmodule
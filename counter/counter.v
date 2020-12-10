module counter(
    input clk, 
    input enable, 
    input reset,
    output [7:0] out 
);

    reg[7:0] out;

    initial
    begin
        out = 8'h00;
    end

    always @ (posedge clk)
    begin
        if (reset == 1'b1) begin
            out <= 8'h00;
        end
        else if(enable == 1'b1) begin
            out <= out + 1;
        end
    end 

endmodule
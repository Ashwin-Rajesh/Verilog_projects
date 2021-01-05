module ram (address, data, write, en, clk);

    parameter WIDTH     = 8;            // Size of each memory address
    parameter A_SIZE    = 8;            // Size of address line

    input[A_SIZE-1:0]   address;        // Address port
    inout[WIDTH-1:0]    data;           // Data port 
    input               write;          // High for write, low for read
    input               en;             // High to enable the module
    input               clk;            // Clock signal
    
    reg[WIDTH-1:0]      memory[(2**A_SIZE)-1:0];
    reg[WIDTH-1:0]      data_out;

    assign data = (en == 1'b1 && write == 1'b0) ? data_out : {WIDTH{1'bz}};

    always @(posedge clk) begin
        if(en == 1'b1)
            if(write == 1'b1)
                memory[address] = data;
            else
                data_out = memory[address];
    end
    
endmodule
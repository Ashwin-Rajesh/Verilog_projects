`timescale 10ns/1ns

module ram_tb;

    localparam A_SIZE = 8;
    localparam WIDTH = 8;

    reg[A_SIZE-1:0]     address;        // Address port
    tri[WIDTH-1:0]     data;           // Data port 
    reg                 write;          // High for write, low for read
    reg                 en;             // High to enable the module
    reg                 clk;            // Clock signal

    reg[WIDTH-1:0]      data_out;
    reg[WIDTH-1:0]      data_in;

    assign data = (write == 1'b1) ? data_in : {WIDTH{1'bz}};
    
    ram #(WIDTH, A_SIZE) tud(address, data, write, en, clk);

    integer i;
        

    initial begin
        $dumpfile("ram.vcd");
        $dumpvars(0, ram_tb);

        $display("%d", 2**A_SIZE);

        $readmemb("./ram.data", tud.memory);

        clk = 0;
        en = 1'b1;

        write = 1'b0;
        for (i = 0; i < 2**A_SIZE; i = i + 1) begin
            address = i;
            data_out = data;
            #1;
        end
        
        write = 1'b1;
        for (i = 0; i < 2**A_SIZE; i = i + 1) begin
            address = i;
            data_in = (i**2);
            #1;
        end

        write = 1'b0;
        for (i = 0; i < 2**A_SIZE; i = i + 1) begin
            address = i;
            data_out = data;
            #1;
        end

        $finish;
    end

    always #0.5 clk = ~clk;
    
endmodule
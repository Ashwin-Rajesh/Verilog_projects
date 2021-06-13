module crc_tb;

    localparam CRC_LEN = 16;
    // Wihtout including MSB, with LSB one
    localparam CRC_POLYNOMIAL = 16'h8005;

    reg data_in = 1'b0;
    reg clk_in  = 1'b0;
    reg reset   = 1'b0;
    reg enable  = 1'b0;

    wire[CRC_LEN-1:0] crc_out;

    crc #(CRC_LEN, CRC_POLYNOMIAL) DUT (
    .data_in(data_in),
    .clk_in(clk_in),
    .reset(reset),
    .enable(enable),
    .crc_out(crc_out)
    );

    localparam  DATA_LEN = 90;

    reg[DATA_LEN-1:0] data = "ABCFA";

    integer i;

    initial begin
        $dumpfile("crc.vcd");
        $dumpvars(0, crc_tb);

        reset   <= 1'b1;
        #1;
        reset   <= 1'b0;

        // Send data
        for(i = DATA_LEN-1; i >= 0; i = i - 1) @(negedge clk_in) begin
            enable      <= 1'b1;
            data_in     <= data[i];
        end
        // Zero padding
        for(i = 0; i < CRC_LEN; i = i + 1) @(negedge clk_in) begin
            enable      <= 1'b1;
            data_in     <= 1'b0;
        end
        

        @(negedge clk_in)
        enable  <= 1'b0;

        #10 
        $display(" CRC value : %b", crc_out);
        $display(" CRC value : %h", crc_out);
        $finish;
    end

    always #1 clk_in  <= ~clk_in;

endmodule
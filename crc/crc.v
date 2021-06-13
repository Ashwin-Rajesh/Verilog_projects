module crc(
    input data_in,
    input clk_in,
    input reset,
    input enable,

    output reg [CRC_LEN-1:0] crc_out
);

    parameter CRC_LEN = 16;

    // Does not include the MSB and includes the LSB (which is always one)
    parameter CRC_POLYNOMIAL = 16'h8005;

    always @(reset)
        if(reset)
            crc_out <= 0;

    wire crc_msb = crc_out[CRC_LEN-1];

    wire[CRC_LEN-1:0] crc_gated;
    wire[CRC_LEN-1:0] crc_next;
    
    assign crc_gated = CRC_POLYNOMIAL                   & {CRC_LEN{crc_msb}};

    assign crc_next  = {crc_out[CRC_LEN-2:0], data_in}  ^ crc_gated;

    always @(posedge (clk_in && enable)) begin
        crc_out     <= crc_next;        
    end

endmodule

module i2c_slave(sda, scl, rst, out);
    inout sda;
    input scl;
    input rst;
    output out; 

    parameter ADDR = 7'h77;

    localparam 
        MODE_INACTIVE   = 0,
        MODE_START      = 1,
        MODE_ADDR       = 2,
        MODE_RW         = 3,
        MODE_ADDR_ACK   = 4,
        MODE_DATA_R     = 5,
        MODE_DATA_R_ACK = 6,
        MODE_DATA_W     = 7,
        MODE_DATA_W_ACK = 8,
        MODE_END        = 9;

    // Status registers
    reg start;          // Bit to indicate start condition
    reg stop;           // Bit to indicate stop condition
    reg[3:0] mode;      // State of state machine
    reg read;           // 1 => Master read wants to read, 0 => Master wants to write
    reg ack;            // Acknowledge bit
    reg sda_o;          // SDA output bit

    assign sda = sda_o ? 1'bz : 1'b0;

    reg[7:0] data;
    reg[2:0] count;

    reg[7:0] mem;

    always @(posedge rst) begin
        start   <= 0;
        stop    <= 0;
        read    <= 0;
        mode    <= MODE_INACTIVE;
        ack     <= 0;
        sda_o   <= 1;

        data    <= 0;
        count   <= 0;

        mem     <= 8'hAA;
    end

    // Detect start and stop conditions.
    // Start condition is detected at negedge sda, when clock is high
    always @(negedge sda)
        if(scl & mode == MODE_INACTIVE)
            start <= 1'b1;          // Detected a start condition!
    
    // Stop condition is detected at posedge sda, when clock is high
    always @(posedge sda)
        if(scl & mode != MODE_INACTIVE)
            stop <= 1'b1;           // Detected a stop condition!

    // What to do if start is detected?!
    always @(posedge start) begin
        start   <= 1'b0;
        mode    <= MODE_START;
        ack     <= 1'b0;
        data    <= 8'b0;
        count   <= 3'b0;
    end

    // What to do if stop is detected?!
    always @(posedge stop) begin
        stop    <= 1'b0;
        mode    <= MODE_INACTIVE;
    end 

    // Inputs are taken at positive edge, outputs are given at negative edge

    // Positive edge
    // State transitions
    // Address, data input
    // Listening ack
    always @(posedge scl) begin
        case(mode)
            MODE_START:begin
                mode    <= MODE_ADDR;
                data    <= {sda, 7'b0};
                count   <= 7;
            end
            MODE_ADDR:begin
                mode    <= count == 0 ? MODE_RW : MODE_ADDR;
                data[count] <= sda;
            end
            MODE_RW:begin
                mode    <= MODE_ADDR_ACK;
                ack     <= (data == ADDR);
                read    <= sda;
            end
            MODE_ADDR_ACK:begin
                mode    <= ack ? (read ? MODE_DATA_R : MODE_DATA_W) : MODE_END;
                count   <= read ? 7 : 8;
            end
            MODE_DATA_R:begin
                mode    <= count == 7 ? MODE_DATA_R_ACK : MODE_DATA_R;
            end 
            MODE_DATA_R_ACK:begin
                mode <= ~sda ? MODE_END : MODE_END;
            end
            MODE_DATA_W:begin
                mode    <= count == 0 ? MODE_DATA_W_ACK : MODE_DATA_W;
                data[count]     <= sda;
            end
            MODE_DATA_W_ACK:begin
                mode    <= MODE_END;
            end
        endcase
    end

    // Negative edge
    // Pulling acknowledge if required
    // Data output on sda
    always @(negedge scl) begin
        case(mode)
            MODE_ADDR:begin
                sda_o   <= 1'b1;
                count   <= count - 1;
            end
            MODE_RW:begin
                sda_o   <= 1'b1;
            end
            MODE_ADDR_ACK:begin
               sda_o    <= ~ack; 
            end
            MODE_DATA_R:begin
                sda_o   <= mem[count];
                count   <= count - 1;
            end
            MODE_DATA_R_ACK:begin
                sda_o   <= 1'b1;
            end
            MODE_DATA_W:begin
                sda_o   <= 1'b1;
                count   <= count - 1;
            end
            MODE_DATA_W_ACK:begin
                sda_o   <= 1'b0;
            end
            MODE_END:begin
                sda_o   <= 1'b1;
            end
            default: sda_o <= 1'b1;
        endcase
    end
endmodule

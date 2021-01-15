// This version is not capable of handling arbitration or clock stretching.i2c_master

module i2c_master(out, stat, scl, sda, clk, rst, inp, cmd);
    output reg[7:0]     out;
    output reg          stat;
    inout               scl;
    inout               sda;
    input               clk;
    input               rst;
    input[7:0]          inp;
    input[2:0]          cmd;

    reg[6:0]            addr;
    reg[7:0]            data;
    reg[3:0]            mode;
    reg[2:0]            count;
    reg                 read;

    reg sda_o;
    reg scl_o;

    assign sda = sda_o ? 1'bz : 1'b0;
    assign scl = scl_o ? 1'bz : 1'b0;

    localparam 
        CMD_NONE    = 0,            // Do nothing
        CMD_ADDR    = 1,            // Store inp to address register
        CMD_DATA    = 2,            // Store inp to data register
        CMD_READ    = 3,            // Read from address stored in address register
        CMD_WRITE   = 4;            // Write data in data reg to address in address register

    localparam
        MODE_INACTIVE   = 0,        // No data transfer
        MODE_START      = 1,        // Start bit to be sent
        MODE_ADDR       = 2,        // Address to be sent
        MODE_RW         = 3,        // Read/Write bit is being sent
        MODE_ADDR_ACK   = 4,        // Address ackowledge is being read
        MODE_DATA_R     = 5,        // Data is being read by master
        MODE_DATA_R_ACK = 6,        // Data read acknowledge is sent
        MODE_DATA_W     = 7,        // Data is being written by master
        MODE_DATA_W_ACK = 8,        // Data write ackwnoledge is received
        MODE_END        = 9;        // Finished transfer. Send stop bit next

    always @(posedge rst) begin
        addr    <= 0;
        data    <= 0;
        mode    <= 0;
        count   <= 0;
        read    <= 0;
    end

    always @(posedge clk) begin
        case(mode)
            MODE_INACTIVE: begin
                case(cmd)
                    CMD_ADDR:begin
                        addr    <= inp[6:0];
                    end
                    CMD_DATA:begin
                        data    <= inp;
                    end
                    CMD_READ:begin
                        mode    <= MODE_START;
                        read    <= 1'b1;
                    end
                    CMD_WRITE:begin
                        mode    <= MODE_START;
                        read    <= 1'b0;
                    end
                endcase
            end
            MODE_START: begin
                sda_o   <= 1'b0;
                scl_o   <= 1'b1;
            end
            MODE_ADDR:begin
                mode    <= count == 7 ? MODE_RW : MODE_ADDR;
            end
            MODE_RW:begin
                mode    <= MODE_ADDR_ACK;
            end 
            MODE_ADDR_ACK:begin
                mode    <= ~sda ? (read ? MODE_DATA_R : MODE_DATA_W) : MODE_END;
                count   <= read ? 8 : 7;
            end
            MODE_DATA_R:begin
                mode    <= count == 0 ? MODE_DATA_R_ACK : MODE_DATA_R;
                data[count] <= sda;
            end
            MODE_DATA_R_ACK:begin
                out     <= data;
                mode    <= MODE_END;
                sda_o   <= 1'b0;
            end
            MODE_DATA_W:begin
                mode    <= count == 7 ? MODE_DATA_W_ACK : MODE_DATA_W;
            end
            MODE_DATA_W_ACK:begin
                mode    <= MODE_END;
                stat    <= ~sda;
            end
            MODE_END:begin
                deassign scl_o;
                scl_o   <= 1'b1;
                sda_o   <= 1'b0;
            end
        endcase
    end

    always @(negedge clk) begin
        case(mode)
            MODE_INACTIVE:begin
                sda_o   <= 1'b1;
                scl_o   <= 1'b1;
            end
            MODE_START:begin
                if(~sda_o) begin
                    mode    <= MODE_ADDR;
                    sda_o   <= addr[6];
                    count   <= 5;
                    assign scl_o = clk;
                end
            end
            MODE_ADDR:begin
                sda_o   <= addr[count];
                count   <= count - 1;
            end
            MODE_RW:begin
                sda_o   <= read;
            end
            MODE_ADDR_ACK:begin
                sda_o   <= 1'b1;
            end
            MODE_DATA_R:begin
                sda_o       <= 1'b1;
                count       <= count - 1;
            end
            MODE_DATA_R_ACK:begin
                sda_o       <= 1'b0;
            end
            MODE_DATA_W:begin
                sda_o       <= data[count];
                count       <= count - 1;
            end
            MODE_DATA_W_ACK:begin
                sda_o       <= 1'b1;
            end
            MODE_END:begin
                if(scl & ~sda) begin
                    sda_o   <= 1'b1;
                    mode    <= MODE_INACTIVE;
                end
            end
        endcase
    end


endmodule
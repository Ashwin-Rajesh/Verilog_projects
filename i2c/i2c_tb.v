`timescale 10ns/1ns

module i2c_tb;
    reg sda_in;
    reg scl;
    reg rst;

    reg ack;
    
    wire sda = sda_in ? 1'bz : 1'b0;
    pullup pu(sda);
    wire sda_out = sda;

    i2c_slave dut(sda, scl, rst, out);

    reg[7:0] data;
    integer i;

    localparam addr = 8'h77;

    initial begin
        $dumpfile("i2c.vcd");
        $dumpvars(0, i2c_tb);
    end

    always #2 scl = ~scl;

    initial begin
        sda_in = 1'b1;
        scl = 1'b1;
        rst = 1'b0;
        ack = 1'b0;
        data = 8'h77;

        #0.5 rst = 1'b1;        // Reset the slave
        #0.5 rst = 1'b0;

        WRITE_DATA(addr, 8'hAB, ack);

        #10;

        READ_DATA(addr, data, ack);
        $display($time, "exit");
        #10 $finish;
    end


    task READ_DATA;
        input[7:0] addr;
        output[7:0] data;
        output ack;

        integer i;

        begin
            // START bit, address, r/w, address ack
            HEADER(addr, 1'b1, ack);

            data = 8'h00;
            if(ack) begin
                // data frame
                for(i = 7; i >= 0; i = i - 1)
                    @(posedge scl) #1 data[i] = sda;
                // data ack
                @(negedge scl) #1 sda_in = 1'b0;
                @(posedge scl);
            end

            // STOP condition
            @(negedge scl) #1 sda_in = 1'b0;
            @(posedge scl) #1 sda_in = 1'b1;
        end
    endtask

    task WRITE_DATA;
        input[7:0] addr;
        input[7:0] data;
        output ack;

        integer i;

        begin
            // START bit, address, r/w, address ack
            HEADER(addr, 1'b0, ack);
            
            if(ack) begin
                // data frame
                for(i = 7; i >= 0; i = i - 1)
                    @(negedge scl) #1 sda_in = data[i];
                // data ack
                @(posedge scl);
                @(posedge scl) ack = sda;
            end

            // STOP condition
            @(negedge scl) #1 sda_in = 1'b0;
            @(posedge scl) #1 sda_in = 1'b1;
        end
    endtask

    task HEADER;
        input[6:0] addr;
        input read;
        output ack;

        integer i;

        begin
            // START condition
            @(posedge scl) #1 sda_in = 1'b0;

            for(i = 6; i >= 0; i = i - 1)
                @(negedge scl) #1 sda_in = addr[i];
            
            @(negedge scl) #1 sda_in = read;        // 1 for read, 0 for write
            
            @(negedge scl) #1 sda_in = 1'b1;        // Release to check acknowledge
            @(posedge scl) #1 ack    = ~sda;
        end
    endtask

endmodule

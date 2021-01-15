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

    initial begin
        $dumpfile("i2c.vcd");
        $dumpvars(0, i2c_tb);
    end

    initial begin
        sda_in = 1'b1;
        scl = 1'b1;
        rst = 1'b0;
        ack = 1'b0;
        data = 8'h77;

        #0.5 rst = 1'b1;        // Reset the slave
        #0.5 rst = 1'b0;

        // START condition
        @(posedge scl) #1 sda_in = 1'b0;

        for(i = 7; i >= 0; i = i - 1)
            @(negedge scl) #1 sda_in = data[i];
        
        @(negedge scl) #1 sda_in = 1'b0;        // 1 for read, 0 for write
        
        @(negedge scl) #1 sda_in = 1'b1;        // Release to check acknowledge
        @(posedge scl) #1 ack    = sda;

        // READ data
        // data = 8'h00;
        // if(~ack) begin
        //     for(i = 7; i >= 0; i = i - 1)
        //         @(posedge scl) #1 data[i] = sda;
        //     @(negedge scl) #1 sda_in = 1'b0;
        //     @(posedge scl);
        // end

        // WRITE data
        data = 8'h55;
        if(~ack) begin
            for(i = 7; i >= 0; i = i - 1)
                @(negedge scl) #1 sda_in = data[i];
            @(posedge scl);
            @(posedge scl) ack = sda;
        end

        // STOP condition
        @(negedge scl) #1 sda_in = 1'b0;
        @(posedge scl) #1 sda_in = 1'b1;

        #10 $finish;
    end

    always #2 scl = ~scl;

endmodule

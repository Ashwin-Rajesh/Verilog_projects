`timescale 10ns/1ns

module i2c_master_tb;
    wire[7:0] out;
    wire stat;
    reg sda_in;
    reg scl_in;
    reg clk;
    reg rst;
    reg[7:0] inp;
    reg[2:0] cmd;

    wire sda = sda_in ? 1'bz : 1'b0;
    wire scl = scl_in ? 1'bz : 1'b0;
    pullup pu1(sda);
    pullup pu2(scl);
    
    localparam 
        CMD_NONE    = 0,            // Do nothing
        CMD_ADDR    = 1,            // Store inp to address register
        CMD_DATA    = 2,            // Store inp to data register
        CMD_READ    = 3,            // Read from address stored in address register
        CMD_WRITE   = 4;            // Write data in data reg to address in address register

    i2c_master dut(out, stat, scl, sda, clk, rst, inp, cmd);
    i2c_slave slave(sda, scl, rst);

    initial begin
        $dumpfile("i2c.vcd");
        $dumpvars(0, i2c_master_tb);

        sda_in = 1;
        scl_in = 1;
        clk    = 0;
        rst    = 0;
        inp    = 0;
        cmd    = 0;

        rst = 1'b1;
        #0.5 rst = 1'b0;
        #0.5 rst = 1'b1;

        @(negedge clk)
        inp     = 7'h77;
        cmd     = CMD_ADDR;

        @(negedge clk)
        inp     = 8'hAB;
        cmd     = CMD_DATA;

        @(negedge clk)
        cmd     = CMD_WRITE;

        @(negedge clk)
        cmd     = CMD_NONE;
        
        #100;

        @(negedge clk)
        cmd     = CMD_READ;

        @(negedge clk)
        cmd     = CMD_NONE;

        #100 $finish;

    end

    always #2 clk = ~clk;
endmodule

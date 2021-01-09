module tb;
    reg clk;
    reg reset;

    control dut(clk, reset);

    integer i;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, tb);

        for(i = 0; i < `REG_FILE_SIZE; i = i + 1)
            $dumpvars(0, dut.reg_file.memory[i]);

        for(i = 0; i < 10; i = i + 1)
            $dumpvars(0, dut.fetch_stage.d.memory[i]);

        clk = 0;
        reset = 1;

        #2;
        reset = 0;

        #100 $finish;
    end

    always #1 clk = ~clk;
endmodule
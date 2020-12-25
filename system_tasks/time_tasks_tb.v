module time_tasks_tb();
    reg [0:64] register;

    initial begin
        register = $time;
        $display("%t", register);
        $stop;
        register = $time;
        $display("%t", register);
    end
endmodule

`timescale 1s/100ms

module monitor_module(input[0:10] a);
    
    always @(a) $display(" Inside monitor module %d",a);
        
endmodule

module display_tasks_tb();
    reg[0:10] a = 100;
    reg[10:0] b;

    monitor_module mon(a);

    initial
    begin

        // Notice the order in which they appear here.
        // Then, notice how they appear in the result.

        $strobe (" Strobe       %m", a);
        $display(" Display      %m", a);
        $monitor(" Monitor      %m", a);
        
        b = a[10:0];
        $display("%b", a);
        $display("%b", b);

        a = 10;
        
        a = a+1; #10
        a = a+1; #10
        $finish;
    end
endmodule
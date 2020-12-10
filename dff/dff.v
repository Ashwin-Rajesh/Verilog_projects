module dff(
    input d, clk,
    output q, qbar
);
    parameter delay=1, diffdelay=0;

    reg q, qbar;

    always @ (posedge clk)
    begin
        #delay;
        q <= d;
        #diffdelay;
        qbar <= !d;
    end

endmodule
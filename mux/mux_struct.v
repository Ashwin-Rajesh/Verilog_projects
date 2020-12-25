module mux_2(input[1:0] in, input sel, output out);

    wire t1, t2, t3;

    not N1(t1, sel);
    and A1(t2, in[0], t1);
    and A2(t3, in[1], sel);
    or  O1(out, t2, t3);

endmodule

module mux_4(input[3:0] in, input[1:0] sel, output out);

    wire t1, t2;
    
    mux_2 m1(in[1:0], sel[0], t1);
    mux_2 m2(in[3:2], sel[0], t2);

    mux_2 m3({t1, t2}, sel[1], out);

endmodule

module mux_8(input[7:0] in, input[2:0] sel, output out);
    
    wire t1, t2;

    mux_4 m1(in[7:4], sel[1:0], t1);
    mux_4 m2(in[3:0], sel[1:0], t2);

    mux_2 m3({t1, t2}, sel[2], out);
    
endmodule

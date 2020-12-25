module mux(in, sel, out);
    parameter sel_width = 2;
    
    input[(2 ** sel_width) - 1 : 0] in;
    input[sel_width - 1 : 0]        sel;
    output out;
    
    assign out = in[sel];
endmodule

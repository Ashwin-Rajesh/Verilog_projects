module test;

    integer a;

    initial begin

        $monitor("0b%32b, 0o%o, 0x%4h, 0d%d", a, a, a, a);

        #1  a = 8'b10x;
        #1  a = 8'b1;
        #1  a = 8'b0;
        #1  a = 8'b101z;

        #1  a = 'sb110;
        #1  a = 8'sb110;

    end

endmodule
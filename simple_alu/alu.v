module alu(inputa, inputb, mode, clk, out, status);
    // Port declaration
    input[7:0] inputa, 
            inputb, 
            mode;

    input clk;
    
    output[7:0] out, 
            status;

    reg[7:0] out, status;

    // First stage : select inputs or their inverted versions
    wire[7:0] nota, notb;

    assign nota = ~inputa;
    assign notb = ~inputb;

    wire[7:0] opa, opb;

    assign opa = (nota & {8{mode[0]}}) | (inputa & {8{~mode[0]}});
    assign opb = (notb & {8{mode[1]}}) | (inputb & {8{~mode[1]}});
    
    wire[7:0] addout, 
            andout,
            orout,
            xorout;
    wire cout;

    // Give those inputs to circuits to perform operations required
    assign {cout, addout} = opa + opb + mode[2];
    assign andout = opa & opb;
    assign orout  = opa | opb;
    assign xorout = opa ^ opb;

    // Initialize status to be 0
    initial status = 8'b0;

    // Assign output and status at positive edge of clock
    always @(posedge clk) begin
        case (mode[7:3])
            1:begin
                $display("Added at %t : %b", $time, addout);
                out         = addout;
                status[1]   = (out[7] & ~opa[7] & ~opb[7]) | (~out[7] & opa[7] & opb[7]);
            end
            2:
                out = andout;
            3:
                out = orout;
            4:
                out = xorout;
            5:
                out = opa;
            6:
                out = opb;
            default:
                out = 8'hxx;
        endcase

        status[0] = ~|out;
        status[2] = out[7];
        status[3] = ~^out;
    end

endmodule
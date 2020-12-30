module pattern_detector(in, clk, out);
    input   in, clk;
    output reg out;
    
    reg[1:0] state;

    initial state = 0;

    always @(posedge clk)
    begin
        case({state, in})
            3'b001:assign {state,out} = 3'b010;
            3'b000:assign {state,out} = 3'b000;
            3'b011:assign {state,out} = 3'b100;
            3'b010:assign {state,out} = 3'b000;
            3'b101:assign {state,out} = 3'b111;
            3'b100:assign {state,out} = 3'b000;
            3'b111:assign {state,out} = 3'b111;
            3'b110:assign {state,out} = 3'b000;
            default: assign {state, out} = 3'b000; 
        endcase
    end
endmodule

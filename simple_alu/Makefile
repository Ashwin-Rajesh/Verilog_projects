source 	= alu.v alu_tb.v

object  = alu.out

output  = alu.vcd

$(object): $(source)
	iverilog $(source) -o $(object)

$(output): $(object)
	./$(object)

simulate: $(output)
	gtkwave $(output)
.PHONY: simulate

compile: $(object)
.PHONY: compile

run: $(object)
	./$(object)

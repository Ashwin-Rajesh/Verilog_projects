source 	= mux.v mux_tb.v

object  = mux.out

output  = mux.vcd

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

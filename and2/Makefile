# Source files used
source 		= and2.v
# Testbench code
testbench	= and2_tb.v

# Result of compilation
object		= and2.out

# Waveform file
wave		= and2.vcd

compile: $(object)
.PHONY: compile

$(object): $(source) $(testbench)
	iverilog $(testbench) -o $(object)

$(wave): $(object)
	./$(object)

simulate: $(wave)
	gtkwave $(wave)
.PHONY: simulate

run: $(object)
	./$(object)
.PHONY:run
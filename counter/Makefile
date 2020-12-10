# Source files used
source 		= counter.v
# Testbench code
testbench	= counter_tb.v

# Result of compilation
object		= counter.out

# Waveform file
wave		= counter.vcd

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
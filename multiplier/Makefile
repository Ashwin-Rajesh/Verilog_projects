# Name of project
proj_name 	= multiplier

# Source files used
source 		= simple_unsigned_multiplier.v \
				seq_unsigned_multiplier.v \
				streamlined_multiplier.v \
				signed_streamlined_multiplier.v

# Testbench code
testbench	= $(proj_name)_tb.v

# Result of compilation
object		= $(proj_name).out

# Waveform file
wave		= $(proj_name).vcd

compile: $(object)
.PHONY: compile

$(object): $(source) $(testbench)
	iverilog $(testbench) $(source) -o $(object)

$(wave): $(object)
	./$(object)

simulate: $(wave)
	gtkwave $(wave)
.PHONY: simulate

run: $(object)
	./$(object)
.PHONY:run
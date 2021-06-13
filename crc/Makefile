# Name of project
proj_name 	= crc

# Source files used
source 		= $(proj_name).v

# Testbench code
testbench	= $(proj_name)_tb.v

# Result of compilation
object		= $(proj_name).out

# Waveform file
wave		= $(proj_name).vcd

compile: $(object)
.PHONY: compile

$(object): $(source) $(testbench)
	iverilog $(source) $(testbench) -o $(object)

$(wave): $(object)
	./$(object)

simulate: $(wave)
	gtkwave $(wave)
.PHONY: simulate

run: $(object)
	./$(object)
.PHONY:run
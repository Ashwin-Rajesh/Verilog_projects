# Name of project
proj_name 	= ram

# Source files used
source 		= $(proj_name).v

# Testbench code
testbench	= $(proj_name)_tb.v

# Result of compilation
object		= $(proj_name).out

# Data file to load to memory
data		= $(proj_name).data

# Waveform file
wave		= $(proj_name).vcd

compile: $(object)
.PHONY: compile

$(object): $(source) $(testbench)
	iverilog $(testbench) $(source) -o $(object)

$(wave): $(object) $(data)
	./$(object)

simulate: $(wave)
	gtkwave $(wave)
.PHONY: simulate

run: $(object)
	./$(object)
.PHONY:run
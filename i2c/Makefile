# Name of project
proj_name 	= i2c

# Source files used
source 		= i2c_slave.v

# Testbench code
testbench	= $(proj_name)_tb.v

# Result of compilation
object		= $(proj_name).out

# Data file to load to memory
data		= 

# Waveform file
wave		= $(proj_name).vcd

compile: $(object)
.PHONY: compile

$(object): $(source) $(testbench)
	iverilog $(testbench) $(source) -o $(object)

$(wave): $(object) $(data)
	./$(object)

view: $(wave)
	gtkwave $(wave)
.PHONY: simulate

run: $(object)
	./$(object)
.PHONY:run
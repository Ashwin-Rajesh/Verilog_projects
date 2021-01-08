# Module to be tested
mut_name 	= mem_reg

# Source file for module
source		= $(mut_name).v

# Testbench code
testbench	= testbenches/$(mut_name)_tb.v

# Result of compilation
object		= testbenches/$(mut_name).out

# Waveform file
wave		= testbenches/$(mut_name).vcd

compile: $(object)
.PHONY: compile

$(object): $(source) $(testbench)
	iverilog $(testbench) $(source) -o $(object)

$(wave): $(object) $(data)
	./$(object)

view: $(wave)
	gtkwave $(wave)
.PHONY: view

run: $(object)
	./$(object)
.PHONY:run
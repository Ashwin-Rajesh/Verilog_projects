# All files
sources 	= ./*.v

object		= bin/test.out

wave		= test.vcd

code		= code/reset.data

assembler   = ../assembler.py

code_src	= code/reset.asm

view	: $(wave)
	gtkwave $(wave)
.PHONY:view

compile	: $(object)
.PHONY:compile

run		: $(object)
	vvp $(object)
.PHONY:object

$(object): $(sources)
	iverilog $(sources) -o $(object)

$(wave): $(object) $(code)
	vvp $(object)

$(code): $(code_src)
	$(assembler) $(code_src) $(code)

# Module testing
# Module to be tested
mod_name 	= mem_reg

# Source file for module
mod_src		= $(mod_name).v

# Testbench code
mod_tb		= testbenches/$(mod_name)_tb.v

# Result of compilation
mod_obj		= bin/$(mod_name).out

# Waveform file
mod_wave	= testbenches/$(mod_name).vcd

mod_compile	: $(mod_obj)
.PHONY: compile

mod_view	: $(mod_wave)
	gtkmod_wave $(mod_wave)
.PHONY: view

mod_run		: $(mod_obj)
	./$(mod_obj)
.PHONY:run

$(mod_obj): $(mod_src) $(mod_tb)
	iverilog $(mod_tb) $(mod_src) -o $(mod_obj)

$(mod_wave): $(mod_obj)
	./$(mod_obj)

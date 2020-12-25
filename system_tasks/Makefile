# Name (eg-display_tasks)
name		= display_tasks

# Testbench code
testbench	= $(name)_tb.v

# Result of compilation
object		= $(name).out

compile: $(object)
.PHONY: compile

$(object): $(testbench)
	iverilog $(testbench) -o $(object)

run: $(object)
	vvp $(object)
.PHONY:run

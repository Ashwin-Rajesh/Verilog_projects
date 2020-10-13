dff.out: dff.v dff_tb.v
	iverilog dff_tb.v -o dff.out

dff.vcd: dff.out
	./dff.out

simulate: dff.vcd
	gtkwave dff.vcd
.PHONY: simulate

compile: dff.out
.PHONY: compile
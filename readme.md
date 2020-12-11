# Learning verilog HDL

Documenting various beginner projects, syntax and common paradigms of verilog HDL. My set-up

- Ubuntu 18.04
- Icarus verilog for compilation
  - [Version 10.1](ftp://ftp.icarus.com/pub/eda/verilog/v10/)
- Visual studio code for editing
  - [Verilog-HDL extension](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL)
- gtkwave for visualising waveforms

---

## Command line interface

- Compiling
  - Using icarus, to compile the ```<test.v>``` file into ```<output.out>```,
  - ```iverilog <test.v> -o <output.out>```
- Running
  - To run a testbench simulation, which was compiled into ```<output.out>```
  - ``` ./<output.out> ```
- Viewing
  - To view the simulation outut of a testbench simulation, whose outputs ere dumped into ```<waveform.vcd>``` using [\$dumpfile](./readme.md#dumpfile) and [\$dumpvars](./readme.md#dumpvars) directives
  - ``` gtkwave <waveform.vcd> ```
- Automation using makefiles
  ```makefile
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
  ```
  - ```make compile``` : compiles to make the object file
  - ```make run``` : runs the object file
  - ```make simulate``` : visualises result stored using ```gtkwave```

---

## Basics of verilog

- Hardware description language - meaning, its used for describing hardware, and not for computation on conventional computers.
- Does not follow line-by-line execution. We are only describing hardware
- Designed with modularity in mind.
- Similar to C

---

## Syntax features

- Verilog does not care about whitespaces! (in most cases)
- Is case sensitive

---

## Comment

- Single line comments:

```verilog
// This is a commment
```

- Multi-line comments

```verilog
/* 
This is a mult-line comment
*/
```

---

## Modules

- Modules are used for modularity. They represent components.

### Ports

- Ports are the interface used by the external world to interface with an instance of a module. They can have 3 types :
  - input
  - output
  - inout

### Syntax

- This is the basic structure of a verilog module.

```verilog
module test_module(port1, port2, port3, ..., portx);
    // Port definitions
    input port1, port2;
    output port3;
    inout portx;
    // Doing stuff
    ...
endmodule
```

- The port types can also be definied in the bracket.

```verilog
module test_module(
    input port1, port2,
    output port3,
    ...
    inout portx
);
    // Doing stuff
    ...
endmodule
```

### Module instantiation


```verilog
test_module test_instance (net1, net2, net3, ... netx);
```

- We can also specify which nets connect to which ports

```verilog
test_module test_instance (.port1(net1), .port2(net2), .port3(net3), ..., .portx(netx));
```

- Both of these connects
  - net1 -> port1
  - net2 -> port2
  - net3 -> port3
  ...
  - netx -> portx

### Parameters

- Used to customize instances of the same module
- basic syntax to define parameters with :

```verilog
parameter 
  param_1=default_value_1,
  param_2=default_value_2,
  ...
  param_x=default_value_x;
```

- During instantiation, parameter values can be overriden by several methods:

```verilog
// First method

test_module #(
  value_1,
  value_2,
  value_3)
test_instance(
  port1,
  ...
  portx
);

// Second method

test_module #(
  .param_1(value_1),
  .param_3(value_3),
  .param_2(value_2))
test_instance(
  port1,
  ...
  portx
);

// Third method

test_module test_instance(
  port1,
  ...
  portx
);
defparam
  test_instance.param_1=value_1,
  test_instance.param_2=value_2,
  test_instance.param_3=value_3;

```

---

## Data types

- Physical data types
  - ```wire``` - Used for wiring different components together
  - ```reg``` - Used for temorarily storing data, like registers

- Abstract data types
  - ```integer``` - 32 bit signed value
  - ```time``` - 64 bit unsigned value from system task $time
  - ```real``` - Floating point value
  - 

---

## Values and literals

- 4 basic values
  - 0
  - 1
  - X (unknown/undefined)
  - Z (high-impedance)
- The last 2 are only for physical data types
- Literals are defined in the following formats

```verilog
// <width>'<sign><radix><value>
4'b1000     // 4-bit unsigned binary 1000     : 1000
4'd15       // 4-bit unsigned decimal 15      : 1000 
8'd32       // 8-bit unsigned decimal 32      : 00100000
8'sd32      // 8-bit signed decimal 32        : 00100000
8'b10x      // 8-bit unsigned binary 10x      : 0000010x

// '<radix><value>
'b10        // Unsigned Binary 10             : 10
'hf0        // Unsigned Hexadecimal f0        : 11110000
'o77        // Unsigned Octal 77              : 111111
'sb110      // Signed Binary 110              : 110       (sign extension with 1s)
'b110       // Unsigned Binary 110            : 110       (sign extension with 0s)

```

- The letters for sign and radix are __not__ case sensitive.

- Signed notation
  - Does not change the bit pattern being converted, only affects its interpretation. [A stack overflow question on this topic](https://stackoverflow.com/questions/42911923/why-have-negative-valued-signed-literals)
  - For signed representation, use s. Else, dont use s.
  - Changes end result when the size is not specified and sign extension is required
  ```verilog
  integer a;

  a = 8'sb110;   // Gives value 6  : 0b00000000000000000000000000000110
  a = 'sb110;    // Gives value -2 : 0b11111111111111111111111111111110
  ```

- Radix abbreviations
  - b - Binary
  - d - Decimal
  - o - Octal
  - h - Hexadecimal

---

## Scalars, Vectors

- In verilog, scalars are 1-bit wide data types, like a simple ```reg``` or ```wire```. 
- We can define buses using vectors. They are defined as follows :

```verilog
wire[7:0] bus1;   // 8-bit wide little-endian bus
wire[0:7] bus2;   // 8-bit wide big-endian bus
```

- The indexing can be either from high:low (little endian) or low:high (big endian).
- Slices of the vectors can be taken as follows:

```verilog
bus1[6:3] = 4'ha;   // Bits 5 to 3 (both inclusive) become 1010
```

---

## Tasks and Functions

Tasks and functions are similar to procedures and functions in c. They are defined inside modules.

### Tasks
- Can have multiple arguments of type
  - input
  - output
  - inout
- Does not return anything
- Tasks are defined as follows:
```verilog
// Defining a task
task test_task;
  input [3:0] businp;
  output out;

  // Body of task
  begin
  ...
  end
endtask
```
- Tasks can be instantiated as follows:
```verilog
test_task(inp, out);
```

### Functions
- Should have at least one input type argument
- Cannot have output type arguments
- Return a single value
- They are defined as follows:
```verilog
function [3:0] test_func;
  input [1:0] businp;
  
  // Body of function
  begin
  ...
  my_func = ...; // Return value
  end
endfunction
```
- Functions are instantiated as follows:
```verilog
out = test_task(inp);
```

---

## Compiler directives

Like in ```#``` directives in c, there are compiler directives in verilog, which are preceeded by ``` ` ```. Some compiler directives are

- ``` `include```
  - Similar to #include in c, used for inserting contents of another verilog file
- ``` `define```
  - Similar to c, used for defining macros
- ``` `undef```
  - Used to discard macros defined using ``` `define```
- ``` `ifdef```
  - Used to define areas of code that should be included if some macro has been defined. The area to be checked will be receeded by the ``` `ifdef``` tag and succeeded by the ``` `endif``` tag, similar to ```#ifdef``` and ```#endif``` tags.
  - Some directives related to this are
    - ``` `endif```
    - ``` `else```
    - ``` `ifndef```
    - ``` `elseif```

---

## References

1. [Summary of verilog syntax](http://www.iitg.ac.in/hemangee/cs224_2020/verilog2.pdf)
2. [asicworld.com verilog tutorial](http://www.asic-world.com/verilog/veritut.html)
3. [chipverify.com verilog tutorial](https://www.chipverify.com/verilog/verilog-tutorial)
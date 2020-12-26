# Learning verilog HDL

Documenting various beginner projects, syntax and common paradigms of verilog HDL. My set-up

- Ubuntu 18.04
- Icarus verilog for compilation
  - [Version 12.0](ftp://ftp.icarus.com/pub/eda/verilog/v10/)
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
  - Changes the effect of arithmetic right shift operator
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
    test_func = ...; // Return value
    end
  endfunction
  ```

- Functions are instantiated as follows:
  ```verilog
  out = test_task(inp);
  ```

---

## System tasks

System tasks are built-in tasks. All system tasks are preceeded with ```$```

### Printing to screen

- ```$display``` : Displays passed arguemnts to console
- ```$strobe``` : Same as ```$display```, but the values are all printed only at the end of current timestep instead of instantly
- ```$monitor``` : Displays every time one of its parameters changes.

  ```verilog
  $display ("format_string", par_1, par_2, ... );
  $strobe ("format_string", par_1, par_2, ... );
  $monitor ("format_string", par_1, par_2, ... );
  ```

- The format string used here is similar to that in normal programming languages and can have the format characters :
  - ```%d``` : Decimal
  - ```%h``` : Hexadecimal
  - ```%b``` : Binary
  - ```%c``` : Character
  - ```%s``` : String
  - ```%t``` : Time
  - ```%m``` : Hierarchy level
  - As usual, we can specify number of spaces (eg : %5d)

### Random
- ```$random``` : Generates signed 32-bit integers
- ```$urandom``` : Generates unsigned 32-bit integers
- ```$urandom_range(a, b)``` : Generates an unsigned integer within a speicified range

### Time

- ```$time``` : Returns time as 64-bit integer
- ```$stime``` : Returns time ass 32-bit integer
- ```$realtime``` : Returns time as real number

### Simulation control

- ```$reset``` : Resets time to 0
- ```$stop``` : Stops simulation and puts it in ```interactive mode```
- ```$finish``` : Exits the simulator

### Dumping to file

- These can dump variable changes to a simulation viewer like GTKWave.

- ```$dumpfile("filename")``` : Sets the file name to dump values into
- ```$dumpvar(n, module)``` : Dumps variables in module instantiated with name ```module``` and n levels below
- ```$dumpon``` : Initiates dump
- ```$dumpoff``` : Stops dump

---

## Operators

- Operators in verilog are almost identical to those used in C. They operate on data. The types are:

### Arithmetic

- They are used to carry out arithmetics on operands. They can be ```unary``` or ```binary```. ```unary``` operators have a single operand and ```binary``` have 2 operands.
- Unary operators are
  - ```+``` (plus sign)
  - ```-``` (minus sign)
- Binary operators are
  - ```+``` (add)
  - ```-``` (subtract)
  - ```*``` (multiply)
  - ```/``` (divide)
  - ```%``` (modulus)
  - ```**``` (exponentiation)

### Bitwise

- Bitwise binary operations. Input and output size are the same
- Unary
  - ```~``` (negation)
- Binary
  - ```|``` (or)
  - ```&``` (and)
  - ```^``` (xor)
  - ```~^``` (xnor)
  
### Reduction

- Input is a unary operant of multiple bits and output is a single bit. (eg. to find 8-bit AND of 8 bits in a register)
- Unary
  - ```&``` (and)
  - ```~&``` (nand)
  - ```|``` (or)
  - ```~|``` (nor)
  - ```^``` (xor)
  - ```~^``` (xnor)
  ```verilog
  &(4'b0111);   // 0 (0 and 1 and 1 and 1)
  &(4'b1111);   // 1 (1 and 1 and 1 and 1)
  ```

### Relational

- Used to compare values, and results in a single bit (0 or 1)
- Binary
  - ```<``` (less than)
  - ```>``` (greater than)
  - ```<=``` (less than or equal to)
  - ```>=``` (greater than or equal to)
  - ```===``` (equal to, including ```x``` and ```z``` states)
  - ```!==``` (not equal to, including ```x``` and ```z```)
  - ```==``` (equal to, excluding ```x``` and ```z```)
  - ```!=``` (equal to, excluding ```x``` and ```z```)

### Logical

- These give output as a single bit (0 or 1). They are **not** bitwise operators
- Unary
  - ```!``` (not)
- Binary
  - ```&&``` (and)
  - ```||``` (or)

### Shifting

- There are logical and arithmetic shift. Arithmetic right shift fills the additional bits with ```1``` if the number was singed and first bit was ```1```, whereas logical shift will always fill them with ```0```.
- Binary
  - ```<< shift_amnt``` Logical left shift
  - ```>> shift_amnt``` Logical right shift
  - ```<<< shift_amnt``` Arithmetic left shift
  - ```>>> shift_amnt``` Arithmetic right shift

  ```verilog
  // Arithmetic shifting example

  8'b11111110  >>> 2;    // 00111111
  8'b01111111  >>> 2;    // 00011111
  8'b11111110  <<< 2;    // 11111000
  8'b01111111  <<< 2;    // 11111100

  8'sb11111110 >>> 2;    // 11111111
  8'sb01111111 >>> 2;    // 00011111
  8'sb11111110 <<< 2;    // 11111000
  8'sb01111111 <<< 2;    // 11111100
  ```

### Assignment

- Assign values
- Binary
  - ```=``` Blocking assignment - is evaluated and assigned immediately
  - ```<=``` Non-blocking assignment - rhs is evaluated immediately but lhs is assigned only after current timestep

  ```verilog
  // Swap upper, lower 8 bytes
  always @(posedge clk)
  {
    begin
      word[15:8] = word[7:0];
      word[7:0]  = word[15:8];
    end
  }
  ```
  This will not work since the statements are evaluated and assigned line-by-line

  ```verilog
  // Swap upper, lower 8 bytes
  always @(posedge clk)
  {
    begin
      word[15:8] <= word[7:0];
      word[7:0]  <= word[15:8];
    end
  }
  ```
  This will work since the statements are non-blocking and are assigned only after current time step.

### Others

- ```{a,b,..c}```
  - Concatenation
  - Concatenation can also be in lhs
  ```verilog
  {2'b11, 3'b010};    // 11010

  {cout, sum} = a + b + cin;    // For an adder
  ```

- ```{m{n}}```
  - Replication operator
  - Is equivalent to {n, n, ... n} (concatenation m times)

  ```verilog
  {4{2'b10}};         // 10101010
  ```

- ```a?b:c```
  - Conditional operator
  - Similar to conditional operator in C
  - if(a) b else c

- ```[n]```
  - Bit selection

- ```[m:n]```
  - Slicing

- Using reg or wire with ```x``` or ```z``` will lead to whole result being ```x```.

---

## Assignments

### Continuous assignments

- For continously assigning values to a net. Only net type variables can be assigned. Reg type variables cannot be assigned.
- Assignments happen outside procedural blocks, in assign statements.

  ```verilog
  // Format
  assign #delay <net_expression> = <expression>;Assignment
  
  // Example - a 10-bit adder
  wire cout;
  wire[10:0] sum;

  assign #5 {cout, sum} = in1 + in2 + cin;
  ```

- The delat is said to be ```inertial```, because if there is are 2 changes within the specified delay, only the 2nd change is considered. The first change is discarded.

### Procedural assignments

- Assignment is done only when control is transferred to it. This is used for reg type variables.
- Assignments occur inside procedural blocks (```always```, ```initial```).

- ```initial``` block
  - Executes once and becomes inactive after that
  - There can be multiple initial blocks that all start at time 0

- ```always``` bock
  - always statement continuously repeats itself throughout the simulation. 
  - If there are
multiple always statements, they all start to execute concurrently at time 0. 
  - May be triggered by events using an event recognizing list @( ).
- ```always``` and ```initial``` statements can only execute a single statement. Use ```begin .... end``` blocks for multiple statements.

- Blocking and non-blocking assignments become relevant here
- Blocking assinments wait for other blocking assignments of the same time and are executed sequentially.
  ```register = expression;```
- Non-blocking assignments do not wait for other non-blocking assignments of the same time. They are all executed concurrently. ```register <= expression;```
- There can be intra-assignment delay (immediate evaluation, delayed assignment) ```register = #delay expression;```

### Quasi-continuous assignments

- LHS must be reg type, and assignment inside procedural blocks.
- We can assign registers to be continously assigned. After doing this, normal procedural assignments on the registers is useless.
- Doing another quasi-continous assignment overrides previous assignment.
- We need to use ```deassign``` statement to de-assign before we can use procedural assignments again. 

  ```verilog
  begin
    ...
    assign register = expression1;  // Activate quasi-continuous
    ...
    register = expression2;         // No effect
    ...
    assign register = expression3;  // Overrides previous quasi-continuous
    ...
    deassign register;              // Disable quasi-continuous
    ...
    register = expression4;         // Executed.
    ...
  end
  ```

- There cannot be delays. Only initialisation can be delayed.

---

## Blocks

- Sequential blocks
  - ```begin``` and ```end```
  - Statements are executed line-by-line

- Parallel blocks
  - ```fork``` and ```join```
  - Statements are all executed at the same time. Order is irrelevant

---

## Timing control

### Delay-baseed

- ```#``` is used to specify delays.
- ```#delay statement;``` will have the statement executed after delay of ```delay``` periods.
- Intra-assignment delay can be used in procedural assignments.
  - ``` register = #delay expression;```

### Event-based

- ```@()``` is used to trigger using signal changes
- ```@(signal) statement;``` will wait for signal to change and if when ther is a change, executes statement.
- ```always @(signal)``` can be used to run procedural statements whenever there is a change in signal.
- ```@(posedge signal)``` triggers at the positive edge of signal.
  - positive edge is defined as ```0 -> x/z -> 1```
- ```@(negedge signal)``` triggers at the negative edge of the signal.
  - negative edge is defined as ```1 -> x/z -> 0```
- Multiple events can be used to trigger by using ```or```
  ```verilog
  always @(posedge clk or reset or my_event)
    $display("hello");
  ```

### Named event

- Define an event using
- ```event my_event```
- Then, we can use the event as ```@(my_event)```  for timing.
- Call the event using ```-> my_event```

---

## Conditional and loop statements

- ```if-else```
  ```verilog
  if ( expr )       statement;
  else if ( expr )  statement;
  else if ( expr )  statement;
  else              statement;
  ```

- ```case```
  ```verilog
  case ( expr )
    value1        : statement;
    value2        : statement;
    value3        : statement;
    ...
    default       : statement;
  endcase
  ```
- 2 variants
  - ```casez``` : Considers ```z``` in case values as dont cares
  - ```casex``` : Considers ```x``` and ```z``` in case values as dont cares
    ```verilog
    casex (sel)
      4'b1xxx : num = 0;    // Matches 4'b10xx
      4'bx1xx : num = 1;    // Matches 4'b01zx
      4'bxx1x : num = 2;
      4'bxxx1 : num = 3;
      default : num = -1;
    endcase
    ```

- ```while```
  ```verilog
  while ( expr )
    statement;
  ```

- ```loop```
  ```verilog
  for ( init ; expr ; step)
    statement;
  ```

- ```repeat```
  ```verilog
  repeat ( no_of_times )
    statement;
  ```
  - If argument is a variable/signal, it is evaluated only when repeat() statment is called

- ```forever```
  ```verilog
  forever
    statement;
  ```

- They all use single statements. To execcute multiple statements sequentially, use ```begin ... end``` blocks.


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
  - Used to define areas of code that should be included if some macro has been defined. The area to be checked will be preceeded by the ``` `ifdef``` tag and succeeded by the ``` `endif``` tag, similar to ```#ifdef``` and ```#endif``` tags.
  - Some directives related to this are
    - ``` `endif```
    - ``` `else```
    - ``` `ifndef```
    - ``` `elseif```

---

## Synthesis rules

Some rules of thumb to see how behavioral statements are usually synthesised.
- ```assign``` statements generally generates combinational logic. However, sequential logic can be formed sismilar to how gates can be used to form sequential building blocks.
- Conditional statements generate n-bit wide 2-to-1 multiplexers.
- Variable indexing on the right produces a multiplexer.
- Variable indexing on the left produces a demultiplexer.
  ```verilog
  // n-bit wide 2-to-1 mux
  assign out1 = selb ? in2 : in1;

  // Mutiplexer
  assign outb = in1[sel];

  // Demultiplexer
  assign out1[sel] = inb;

  // D latch
  assign q = en ? d : q;
  ```

---

## Shortcuts for coding

- Declaring output and reg in same statement

  ```verilog
  output reg[7:0] data;

  // Instead of
  output[7:0]     data;
  reg[7:0]        data;
  ```

- Declaring reg type variables with initial value

  ```verilog
  reg data = 0;

  // Instead of
  reg data;
  initial data = 0;
  ```


---

## References

1. [Summary of verilog syntax](http://www.iitg.ac.in/hemangee/cs224_2020/verilog2.pdf)
2. [asicworld.com verilog tutorial](http://www.asic-world.com/verilog/veritut.html)
3. [chipverify.com verilog tutorial](https://www.chipverify.com/verilog/verilog-tutorial)
4. [nptel course playlist on youtube - IIT KGP](https://www.youtube.com/playlist?list=PLUtfVcb-iqn-EkuBs3arreilxa2UKIChl)
5. [fpga4fun for projects and examples](https://www.fpga4fun.com/)
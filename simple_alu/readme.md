## Simple ALU

This is a very simple ALU which can perform
- Addition
- Subtraction
- All basic logical operations

## Hardware interface

Inputs
- input_a (8 bit)
- input_b (8 bit)
- mode (8 bit)
  - ``` <5'mode><1'cin><1'not1><2'not2>```
  - not1 : Bitwise NOT 1st input
  - not2 : Bitwise NOT 2nd input
  - mode
    - 1 : Add
    - 2 : And
    - 3 : Or
    - 4 : Xor
    - 5 : Select 1
    - 6 : Select 2

Outputs
- output
- status
    - ``` 0,0,0,0,parity,sign,overflow,zero```
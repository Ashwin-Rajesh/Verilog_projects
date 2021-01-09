#!/usr/bin/env python3

import sys
import os

def get_opcode(inp):
    if(inp == "add"):
        return "000", 0
    if(inp == "addi"):
        return "001", 1
    if(inp == "nand"):
        return "010", 2
    if(inp == "lui"):
        return "011", 3
    if(inp == "sw"):
        return "100", 4
    if(inp == "lw"):
        return "101", 5
    if(inp == "beq"):
        return "110", 6
    if(inp == "jalr"):
        return "111", 7
    return "___", -1

def get_reg(inp):
    if(inp[0] == "r"):
        if(int(inp[1]) < 8):
            out = bin(int(inp[1]))[2:]
            if(len(out) < 3):
                out = "0"*(3-len(out)) + out
            return out, int(inp[1])    
    return "___", -1

def get_sigimm(inp):
    neg = (inp[0] == "-")

    abs = 0
    if(neg):
        abs = min(int(inp[1:]), 64)
    else:
        abs = min(int(inp), 63)

    out = ""
    if(neg):
        out = "".join(['1' if x == '0' else '0' for x in bin(abs-1)[2:]])
    else:
        out = bin(abs)[2:]

    out = ("1"*(7-len(out)) if neg else "0"*(7-len(out))) + out

    return out, -abs if neg else abs

def get_imm(inp):
    abs = max(min(int(inp), 1023), 0)

    out = bin(abs)[2:]

    return "0"*(10-len(out)) + out, abs

# Splits the bitstream into sections of 8 each and writes into the file file_name
def write_code(file_name, bitstream):
    with open(file_name, "w") as f:
        for i in range(len(bitstream)//8):
            f.write(bitstream[8*i : 8*(i+1)]+"\n")
            print(bitstream[8*i : 8*(i+1)])
    f.close()

def main():
    if(len(sys.argv) == 1):
        print("No input file name detected. Plesae pass input file name as argument.")
        return

    source_file = sys.argv[1]
    
    if(len(sys.argv) == 2):
        dest_file = os.path.splitext(source_file)[0] + ".data"
    else:
        dest_file   = sys.argv[2]

    print(f"Source      : {source_file}")
    print(f"Destination : {dest_file}")
    
    output = ""

    with open(source_file, "r") as f:
        line_num = 0
        while True:
            line_num = line_num + 1
            line = f.readline()
            if(line == ""):
                break
            line = line.split('#')[0].rstrip()
    
            parts = [x.lower() for x in line.split(' ') if x != '']

            if(len(parts) != 0):
                opcode, code = get_opcode(parts[0])
                
                if(code == -1):
                    print(f"Error at line number {line_num} : {line}")
                    print("Unidentified opcode")
                    return
                
                # RRR - type
                if(code == 0 or code == 2):
                    regA, regAcode = get_reg(parts[1])
                    regB, regBcode = get_reg(parts[2])
                    regC, regCcode = get_reg(parts[3])

                    if(regAcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("1st operand unidentified")
                        return
                    if(regBcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("2nd operand unidentified")
                        return
                    if(regCcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("3rd operand unidentified")
                        return
                    
                    output = output + opcode + regA + regB + "0000" + regC

                # RRI - type
                elif(code == 1 or code == 4 or code == 5 or code == 6 or code == 7):
                    regA, regAcode = get_reg(parts[1])
                    regB, regBcode = get_reg(parts[2])
                    if(code == 7):
                        imm = "0000000"
                        immcode = 0
                    else:
                        imm, immcode   = get_sigimm(parts[3])

                    if(regAcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("1st operand unidentified")
                        return
                    if(regBcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("2nd operand unidentified")
                        return
                    if(immcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("3rd operand unidentified")
                        return
                    
                    output = output + opcode + regA + regB + imm

                # RI type
                else:
                    regA, regAcode = get_reg(parts[1])
                    imm, immcode = get_imm(parts[2])
                    
                    if(regAcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("1st operand unidentified")
                        return
                    if(immcode == -1):
                        print(f"Error at line number {line_num} : {line}")
                        print("2nd operand unidentified")
                        return
                    
                    output = output + opcode + regA + imm

    write_code(dest_file, output)


if __name__ == "__main__":
    main()
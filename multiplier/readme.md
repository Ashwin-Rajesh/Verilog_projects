# Multipliers

Digital multiplier circuits implemented in verilog

---

## Simple unsigned multiplier

- Uses combinational logic
- Space complexity : n^2
- Time complexity : n

```verilog
out = 0;

for(i = 0; i < 2 * WIDTH; i=i+1)
    if(multiplicand[i] == 1'b1)
        out = out + (multiplier << i);
```

---

## References
- https://www.ece.lsu.edu/ee3755/2002/l07.html


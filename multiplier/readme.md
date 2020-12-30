# Multipliers

Digital multiplier circuits implemented in verilog

---

## Simple unsigned multiplier

- Uses combinational logic
- Space complexity : n^2
- Time complexity : n
- Uses simple long-hand procedure
- For example, to compute 5(```0101```) times 12(```1100```),
    ```
        0101 x (multiplicand)
        1100   (multiplier)
    --------
        0000 +  (0)
       0000 +   (0)
      0101 +    (1)
     0101       (1)
    --------
    00111100   (result) 
    ========
    (60)
    ```

- Verilog code is straight-forward. We use a loop for shifting.
    ```verilog
    out = 0;

    for(i = 0; i < 2 * WIDTH; i=i+1)
        if(multiplier[i] == 1'b1)
            out <= out + (multiplicand << i);
    ```

---

## References
- https://www.ece.lsu.edu/ee3755/2002/l07.html


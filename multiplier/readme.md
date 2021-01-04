# Multipliers

Digital multiplier circuits implemented in verilog

---

## Combinational unsigned multiplier

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

- To generate the combinational circuit, we use generate statements.
    ```verilog
    assign partial_sum[0] = {(2*WIDTH){inb[0]}} & ina; 
    
    generate
        begin
            for(i = 1; i < WIDTH; i = i + 1) begin : mult_stage
                assign partial_sum[i] = partial_sum[i-1] + ({(2*WIDTH){inb[i]}} & (ina << i));
            end
        end
    endgenerate
    ```

---

## Sequential unsigned multiplier

- Is a sequeuntial cirtuit.
- Takes several clock cycles to compute result.
- Every clock cycle,
  - If LSB of multiplier is 1, we add the multiplicand
  - We shift multiplier one bit to the right
  - We shigt the multiplicand one bit to the left

- Verilog code
    ```verilog
    always @(posedge clk)
    begin
        if(start == 1'b1) begin
            multiplicand <= ina;
            multiplier   <= inb;
            bit          <= WIDTH;
            temp         <= 0;
            ready        <= 1'b0;
        end

        if(bit != 4'b0) begin
            if(multiplier[0] == 1'b1)
                temp = temp + multiplicand;
            multiplicand = multiplicand << 1;
            multiplier   = multiplier >> 1;
            bit          = bit - 1;

            if(bit == 1'b0) begin
                out = temp;
                ready = 1'b1; 
            end
        end
    end
    ```

---

## Streamlined multiplier

- Uses a single register for storing both the partial product and the multiplier.
- This reduces number of registers required.

- Verilog code
    ```verilog
    always @(posedge clk)
    begin : mult_block
        reg lsb;

        if(start == 1'b1) begin
            multiplicand = ina;
            bit          = WIDTH;
            partial_product = {{WIDTH+1{1'b0}}, inb};
            ready        = 1'b0;
        end

        else if(bit != 4'b0) begin
            
            lsb = partial_product[0];
            
            partial_product = partial_product >> 1;
            bit          = bit - 1;
            
            if(lsb == 1'b1)
                partial_product[2*WIDTH-1:WIDTH-1] = partial_product[2*WIDTH-2:WIDTH-1] + multiplicand;
            
            if(bit == 1'b0) begin
                out = partial_product;
                ready = 1'b1; 
            end
        end
    end
    ```

---

## References
- https://www.ece.lsu.edu/ee3755/2002/l07.html


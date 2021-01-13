# I2C protocol controller
I2C (pronounced I squared C) is a serial communication protocol. It uses a slave-master configuration and uses half duplex mode, meaning data transfer can happen only in one direction at a given time. It is synchronous, meaning it has a clock signal.

There are 2 lines : 
- A data line, called SDA (Serial Data)
- A clock line, called SCL (Serial Clock)
- (and a common ground obviously)

![Image credits to circuitbasics (link in references)[1]](./diag_1.png)

The clock signal is always controlled by the master and the data signal can be controlled by either the master or the slave. Both the clock and data lines are open-collector or open-drain, with a pull-up resistor. Typically, 5v and 3.3v are used. Due to pull-up, the data lines are by default in high state.

The pull-up resistor should be external to the master and the slave. This makes it possible to use multiple masters at the same time. The **pullup resistor** and **open-drain** configuration create a **wired AND** gate. The resistors are typically somewhere in the range 1kOhm to 10kOhm. The value depends on factors like series resitance of bus which can cause LOW signal to not be recognized properly.

To check how parameters of the bus lines affect communication, check out i2c-bus.org[2]



---

## Clock stretching and arbitration

The slave can hold the SCL line low for some time if it needs to slow down the data transfer. The master must read the SCL line to see if this is being done. This practice is called **clock stretching**. This can be done for as much time as the slave wants

i2c speciication also allows multiple master systems. Both masters concurrently monitor SCL and SDA signals and check if some other master is communicating. If not, it starts its transfer, else it delays them. If 2 masters start communicating simulataneously, the masters check if SDA and SCL are what they expect they are. If SDA is low but they expect it to be high, they can be sure that some other master is using the bus. Then, it stops its transfer. This is called **arbitration**

---

## References
1) https://www.circuitbasics.com/basics-of-the-i2c-communication-protocol/#:~:text=I2C%20is%20a%20serial%20communication,always%20controlled%20by%20the%20master.
2) https://www.i2c-bus.org/
3) https://en.wikipedia.org/wiki/I%C2%B2C

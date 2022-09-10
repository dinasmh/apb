Attached in this email is an edaplayground link to my APB master design, implemented and connected to a dummy APB slave which generates the PREADY and PRDATA signals from an internal register file.

In this playground, I used a simple UVM environment to verify the functionality of my design.

In the randomisation process, I specified a constraint to generate the sequences that result in memory read operations only, so that we can examine the wait feature relative to the PREADY of the slave, since PRDATA only gets its value once PREADY is asserted and the slave can effectuate read/write operations.

We can reverse this constraint by commenting the inline constraint in line 17 in apb_base_seq.sv module.

----------------------------------------------------

In the dummy slave module, PREADY can be assigned using a continuous assignment statement with two different methods:
	assigning it through PREADY1 and PREADY2 --> no wait clocks are implemented
	assigning it through PREADY2 and PREADY3 --> 1 wait clock is implemented

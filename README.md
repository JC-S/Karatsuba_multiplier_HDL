# Karatsuba Multiplier HDL

This is a SystemVerilog HDL implementation of Karatsuba multiplier.

## 1. Introduction

In this project, Karatsuba multiplier is implemented in two manners:

a. Basic: This multiplier works in a good old simple way. It breaks the input operands into two parts with equal widths. The multiplication works in a combinational way. *You'll have to make sure that the width of input operands is an even integer.*

b. Recursive: This multiplier works in a fancy new recursive way. You can tell it how many parts you wanna break the input operands into. The module will keep instantiate itself until the width of multiplier meets your requirement. It is worth noting that recursive module may not play well with some EDA tools. The multiplication works in a sequential way, which means you will have to wait for the finish signal to get the result. *You'll have to make sure that the width of input operands and the number of recursive stages meets the following condition:* ``wI % (2^nSTAGE) == 0``.

You can find the source code in ``rtl`` folder.

## 2. Quick Start

You can find the code for testbenchs in the `verif` folder.

To run simulation:

a. Go to the ``workdir`` folder;

b. Change the variables accordingly;

c. Launch verdi: ``make verdi`` ;

d. Run the simulation: ``make all``.

## 3. Dirty Math Behind the Scene

This is the dirty math behind the scene. I wrote this section for reference during coding and do not bother to format it properly. Sorry but I guess we'll just have to make do.

Karatsuba algorithm:
O = X * Y = {X_hi, X_lo} * {Y_hi, Y_lo}
          = (X_hi * 2**(n/2) + X_lo) * (Y_hi * 2**(n/2) + Y_lo)
          = (X_hi * Y_hi) * 2^n + ((X_hi + X_lo) * (Y_hi + Y_lo) - X_hi * Y_hi - X_lo * Y_lo) * 2^(n/2) + X_lo * Y_lo

Assume:
p = X_hi * Y_hi
q = X_lo * Y_lo
r = X_hi + X_lo
s = Y_hi + Y_lo

Then:
O = X * Y = (X_hi * Y_hi) * 2^n + ((X_hi + X_lo) * (Y_hi + Y_lo) - X_hi * Y_hi - X_lo * Y_lo) * 2^(n/2) + X_lo * Y_lo
          = p * 2^n + (r * s - p - q) * 2^(n/2) + q

Additionally, assume:
t = r * s
u = p + q

Then:
O = X * Y = p *2^n + (t - u) * 2^(n/2) + q

Furthermore, the width of r and s is (n/2) + 1, resulting the width of t to be n + 2. To avoid the hardware cost of extra bits in the multiplier, we can calculate t in this way:
t = r * s = {r_hi[0], r_lo} * {s_hi[0], s_lo}
          = (r_hi[0] * s_hi[0]} * 2^n + ((r_hi[0] * s_lo) + (s_hi * r_lo)) * 2^(n/2) + (r_lo * s_lo)

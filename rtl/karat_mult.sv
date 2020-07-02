// This is the karat_mul module for project Karatsuba_multiplier_HDL
// Copyright (C) 2020 JC-S
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

//-----------------------------------------------------------------------------
//
//FILE NAME     : karat_mul.sv
//AUTHOR        : JC-S
//FUNCTION      : Main mult module for project Karatsuba_multiplier_HDL
//INITIAL DATE  : 2020/06/18
//VERSION       : 1.0
//CHANGE LOG    : 1.0: initial version.
//
//-----------------------------------------------------------------------------

module karat_mult #(
parameter wI = 64,
parameter wO = 2 * wI
)
(
input   logic   [wI-1:0]    iX,
input   logic   [wI-1:0]    iY,
output  logic   [wO-1:0]    oO
);

localparam wI_pt = wI / 2;

logic   [wI_pt-1:0] X_hi, X_lo;
logic   [wI_pt-1:0] Y_hi, Y_lo;

assign  {X_hi, X_lo} = iX;
assign  {Y_hi, Y_lo} = iY;

logic   [wI_pt*2-1:0]   p;
logic   [wI_pt*2-1:0]   q;
logic   [wI_pt:0]       r;
logic   [wI_pt:0]       s;
assign  p = X_hi * Y_hi;
assign  q = X_lo * Y_lo;
assign  r = X_hi + X_lo;
assign  s = Y_hi + Y_lo;

logic   [wI_pt*2:0]     u;
assign  u = p + q;

logic   [wI+1:0]        t;
logic   r_hi, s_hi;
logic   [wI_pt-1:0]     r_lo, s_lo;

assign  {r_hi, r_lo} = r;
assign  {s_hi, s_lo} = s;

logic   [wI-1:0]        t_s;

assign t_s = r_lo * s_lo;
assign t = ((r_hi & s_hi) << wI) + ((r_hi * s_lo + s_hi * r_lo) << wI_pt) + t_s;

assign oO = (p << wI) + ((t - u) << wI_pt) + q;

endmodule
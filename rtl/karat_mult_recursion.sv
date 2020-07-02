// This is the karat_mul module with recursion for project 
// Karatsuba_multiplier_HDL
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
//FILE NAME     : karat_mul_recursion.sv
//AUTHOR        : JC-S
//FUNCTION      : Main mult module w. recursion for project 
//                Karatsuba_multiplier_HDL
//INITIAL DATE  : 2020/06/29
//VERSION       : 1.0
//CHANGE LOG    : 1.0: initial version.
//
//-----------------------------------------------------------------------------

module karat_mult_recursion #(
parameter wI = 1024,
parameter wO = 2 * wI,
parameter nSTAGE = 2
)
(
// data IOs
input   logic   [wI-1:0]    iX,
input   logic   [wI-1:0]    iY,
output  logic   [wO-1:0]    oO,
// control IOs
input   logic   clk,
input   logic   rst_n,
input   logic   i_enable,
output  logic   o_finish
);

localparam wI_pt = wI / 2;

logic   finish_p, finish_q, finish_ts;

logic   [wI_pt-1:0] X_hi, X_lo;
logic   [wI_pt-1:0] Y_hi, Y_lo;

assign  {X_hi, X_lo} = iX;
assign  {Y_hi, Y_lo} = iY;

logic   [wI_pt*2-1:0]   p;
logic   [wI_pt*2-1:0]   q;
logic   [wI_pt:0]       r;
logic   [wI_pt:0]       s;

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

generate
begin: p_eq_Xhi_x_Yhi
    if(nSTAGE == 1)
    begin: p_direct_mult
        assign  p = X_hi * Y_hi;
        assign  finish_p = i_enable;
    end
    else
    begin: p_karat_mult
        karat_mult_recursion #(
            .wI         (wI_pt),
            .nSTAGE     (nSTAGE-1)
        )
        u_karat_mult_recursion_p (
            .iX         (X_hi),
            .iY         (Y_hi),
            .oO         (p),
            .clk        (clk),
            .rst_n      (rst_n),
            .i_enable   (i_enable),
            .o_finish   (finish_p)
        );
    end
end
endgenerate

generate
begin: q_eq_Xlo_x_Ylo
    if(nSTAGE == 1)
    begin: q_direct_mult
        assign  q = X_lo * Y_lo;
        assign  finish_q = i_enable;
    end
    else
    begin: q_karat_mult
        karat_mult_recursion #(
            .wI         (wI_pt),
            .nSTAGE     (nSTAGE-1)
        )
        u_karat_mult_recursion_q (
            .iX         (X_lo),
            .iY         (Y_lo),
            .oO         (q),
            .clk        (clk),
            .rst_n      (rst_n),
            .i_enable   (i_enable),
            .o_finish   (finish_q)
        );
    end
end
endgenerate

generate
begin: ts_eq_rlo_x_slo
    if(nSTAGE == 1)
    begin: ts_direct_mult
        assign  t_s = r_lo * s_lo;
        assign  finish_ts = i_enable;
    end
    else
    begin: ts_karat_mult
        karat_mult_recursion #(
            .wI         (wI_pt),
            .nSTAGE     (nSTAGE-1)
        )
        u_karat_mult_recursion_ts (
            .iX         (r_lo),
            .iY         (s_lo),
            .oO         (t_s),
            .clk        (clk),
            .rst_n      (rst_n),
            .i_enable   (i_enable),
            .o_finish   (finish_ts)
        );
    end
end
endgenerate

assign t = ((r_hi & s_hi) << wI) + ((r_hi * s_lo + s_hi * r_lo) << wI_pt) + t_s;

assign oO = (p << wI) + ((t - u) << wI_pt) + q;

always  @(posedge clk or negedge rst_n)
    if(!rst_n)
        o_finish    <= 1'b0;
    else
        o_finish    <= finish_p && finish_q && finish_ts;

endmodule
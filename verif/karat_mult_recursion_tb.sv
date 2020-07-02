// This is the karat_mult_recursion_tb module for project 
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
//FILE NAME     : karat_mult_recursion_tb.sv
//AUTHOR        : JC-S
//FUNCTION      : Testbench for karat_mul module
//INITIAL DATE  : 2020/06/23
//VERSION       : 1.0
//CHANGE LOG    : 1.0: initial version.
//
//-----------------------------------------------------------------------------

`timescale 1ns/10fs

module karat_mult_recursion_tb();

parameter wI = 1024;
parameter wO = 2 * wI;
parameter nSTAGE = 5;
parameter CLK_PERIOD = 10;

logic   [wI-1:0]    iX, iY;
logic   [wO-1:0]    oO_ref;
logic   [wO-1:0]    oO_rec, oO_norm;
assign  oO_ref = iX * iY;

logic   clk, rst_n;
logic   i_enable, o_finish_rec, o_finish_norm;

initial begin
    clk = 1'b1;
    rst_n = 1'b1;
    #CLK_PERIOD;
    rst_n = 1'b0;
    #CLK_PERIOD;
    rst_n = 1'b1;
    #CLK_PERIOD;
    forever begin
        clk = ~clk;
        #(CLK_PERIOD/2);
    end
end

initial begin
    i_enable = 1'b0;
    iX = 'b0;
    iY = 'b0;
    #(CLK_PERIOD*10);
    i_enable = 1'b1;
    forever begin
        if(o_finish_rec && clk)
        begin
            assert (oO_rec == oO_ref) 
            else
            begin
                $error("ERROR: oO != oO_ref!");
                $finish;    
            end
            iX = $urandom();
            iY = $urandom();
        end
        #(CLK_PERIOD/2);
    end
end

string dump_scheme = "fsdb";
string pass_info = "\
  ____                        _ _ \n\
 |  _ \\ __ _ ___ ___  ___  __| | |\n\
 | |_) / _` / __/ __|/ _ \\/ _` | |\n\
 |  __/ (_| \\__ \\__ \\  __/ (_| |_|\n\
 |_|   \\__,_|___/___/\\___|\\__,_(_)\
 ";

initial
begin: sim_ctrl
    if(dump_scheme == "fsdb")
    begin
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars();
    end
    else if(dump_scheme == "vpd")
    begin
        $vcdplusfile("wave.vpd");
        $vcdpluson();
        $vcdplusmemon();
    end
    #(CLK_PERIOD*20000);
    $display("Info: Test case passed!");
    $display(pass_info);
    $finish;
end

karat_mult_recursion #(
    .wI         (wI),
    .nSTAGE     (nSTAGE)
)
u_karat_mult_recursion (
    .o_finish   (o_finish_rec),
    .oO         (oO_rec),
    .*);

endmodule


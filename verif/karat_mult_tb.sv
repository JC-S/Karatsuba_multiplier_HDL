// This is the karat_mult_tb module for project Karatsuba_multiplier_HDL
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
//FILE NAME     : karat_mult_tb.sv
//AUTHOR        : JC-S
//FUNCTION      : Testbench for karat_mul module
//INITIAL DATE  : 2020/06/23
//VERSION       : 1.0
//CHANGE LOG    : 1.0: initial version.
//
//-----------------------------------------------------------------------------

`timescale 1ns/10fs

module karat_mult_tb();

parameter wI = 64;
parameter wO = 2 * wI;
parameter CLK_PERIOD = 10;

logic   [wI-1:0]    iX, iY;
logic   [wO-1:0]    oO_ref;
logic   [wO-1:0]    oO;
assign  oO_ref = iX * iY;

initial begin
    forever begin
        std::randomize(iX, iY);
        #CLK_PERIOD;
        assert (oO == oO_ref) 
        else
        begin
            $error("ERROR: oO != oO_ref!");
            $finish;
        end
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
    #(CLK_PERIOD*200000);
    $display("Info: Test case passed!");
    $display(pass_info);
    $finish;
end

karat_mult #(
    .wI     (wI)
)
u_karat_mult (.*);

endmodule


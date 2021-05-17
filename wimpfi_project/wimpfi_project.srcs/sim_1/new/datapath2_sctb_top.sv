`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/16/2021 04:06:54 PM
// Design Name:
// Module Name: datapath2_sctb_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module datapath2_sctb_top;
    timeunit 1ns / 100ps;

   parameter CLKPD = 10;
   parameter BAUD_RATE = 50_000;

   clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

   logic clk,rst,rxd, dp_n,a_txd, an_n, segs_n;


    datapath_2 DATAPATH_2(.clk(clk),.rst(rst),.rxd(rxd),.dp_n(dp_n),.a_txd(a_txd),.an_n(an_n),.segs_n(segs_n));

    datapath2_sctb DATAPTAH_SCTB(.clk(clk),.rst(rst),.rxd(rxd));


endmodule

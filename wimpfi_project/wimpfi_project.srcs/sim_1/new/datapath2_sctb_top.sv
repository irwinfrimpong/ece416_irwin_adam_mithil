`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Lafayette College
// Engineer:Adam Tunnell, Irwin Frimpong, Mithil Shah
// Create Date: 05/16/2021 04:06:54 PM
// Module Name: datapath2_sctb_top
// Project Name: WimpFi Project
// Description: Top Level file for datapath2_sctb
// Dependencies: datapath_2, datapath2_sctb
//////////////////////////////////////////////////////////////////////////////////


module datapath2_sctb_top;
    timeunit 1ns / 100ps;

   parameter CLKPD = 10;
   parameter BAUD_RATE = 50_000;

   clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

   logic clk,rst,rxd, dp_n,a_txd, cfgclk, cfgdat,a_rxd,o_txd;
   logic [7:0] an_n;
   logic [6:0] segs_n;

   datapath_2 DATAPATH_2(.clk(clk),.rst(rst),.rxd(rxd),.dp_n(dp_n),.a_txd(a_txd),.cfgclk(cfgclk),.cfgdat(cfgdat),.a_rxd(a_rxd),.o_txd(o_txd),.an_n(an_n),.segs_n(segs_n));


   datapath2_sctb DATAPTAH_SCTB(.clk(clk), .a_txd(a_txd), .rst(rst), .rxd(rxd));


endmodule

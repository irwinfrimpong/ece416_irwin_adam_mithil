`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 04/07/2021 08:07:58 PM
// Design Name: Manchester Reciever
// Module Name: mx_rcvr_sctb_top
// Project Name: Manchester Receiver Implementation
//////////////////////////////////////////////////////////////////////////////////


module mx_rcvr_sctb_top;

   timeunit 1ns / 100ps;
   parameter CLKPD = 10;
   parameter BAUD_RATE = 9600;

   logic clk, rst, valid, cardet, error, rxd;
   logic [7:0] data;

   clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

   mx_rcvr_sctb #(.BAUD_RATE(BAUD_RATE)) SCTB(.clk(clk), .valid(valid), .cardet(cardet), .error(error), .data(data), .rst(rst), .rxd(rxd));
   mx_rcvr #(.BIT_RATE(BAUD_RATE)) DUV(.clk(clk), .rst(rst), .rxd(rxd), .valid(valid), .cardet(cardet), .error(error), .data(data));

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2021 06:05:23 PM
// Design Name: 
// Module Name: xmittrans_top_sctb
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


module xmittrans_top_sctb;
 timeunit 1ns / 100ps;

    parameter CLKPD = 10;
    parameter BAUD_RATE = 9600;

    logic clk,rst,valid, rdy,txd, txen;
    logic [7:0] data ;

    clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) DUV(.clk(clk), .rst(rst), .valid(valid), .data(data), .rdy(rdy), .txen(txen), .txd(txd));

    xmittrans_sctb #(.BAUD_RATE(BAUD_RATE)) MANCHESTER_TB(.clk(clk), .rdy(rdy), .txen(txen), .txd(txd), .valid(valid), .rst(rst),.data(data));

endmodule
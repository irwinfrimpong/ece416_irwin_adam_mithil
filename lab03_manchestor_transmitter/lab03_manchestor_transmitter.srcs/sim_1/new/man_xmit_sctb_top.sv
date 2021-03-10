`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/09/2021 08:59:07 PM
// Design Name:
// Module Name: man_xmit_sctb_top
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


module man_xmit_sctb_top;

    timeunit 1ns / 100ps;

    parameter CLKPD = 10;
    parameter BAUD_RATE = 9600;

    logic clk,rst,valid, rdy,txd, txen;
    logic [7:0] data ;

    clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) DUV(.clk(clk), .rst(rst), .valid(valid), .data(data), .rdy(rdy), .txen(txen), .txd(txd));

    manchester_sctb #(.BAUD_RATE(BAUD_RATE)) MANCHESTER_TB(.clk(clk), .rdy(rdy), .txen(txen), .txd(txd), .valid(valid), .rst(rst),.data(data));

endmodule

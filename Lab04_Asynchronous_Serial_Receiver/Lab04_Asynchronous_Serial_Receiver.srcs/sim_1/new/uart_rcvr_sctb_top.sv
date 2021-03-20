`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/20/2021 04:11:31 PM
// Design Name:
// Module Name: uart_rcvr_sctb_top
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


module uart_rcvr_sctb_top;

    timeunit 1ns / 100ps;
    parameter CLKPD = 10;
    parameter BAUD_RATE = 9600;

    logic clk,rst,valid, rdy,rxd, ferr, oerr;
    logic [7:0] data ;

    clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

    uart_rcvr #(.BAUD_RATE(BAUD_RATE)) DUV (.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy),.valid(valid),.ferr(ferr),.oerr(oerr),.data(data));

    uart_rcvr_sctb UART_RCVR_TB (.clk(clk), .valid(valid), .ferr(ferr), .oerr(oerr), .data(data),.rxd(rxd), .rst(rst), .rdy(rdy));

endmodule

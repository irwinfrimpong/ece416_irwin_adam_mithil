`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/22/2021 06:16:39 PM
// Design Name:
// Module Name: uart_lab2_sctb_top
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


module uart_lab2_sctb_top;

    timeunit 1ns / 100ps;
    parameter CLKPD = 10;
    parameter BAUD_RATE = 9600;

    logic clk, rst, ferr, oerr;
    logic [7:0] data_in, data_out;

    clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));


    uart_lab2test_top UART_TOP(.clk(clk) ,.rst(rst),.data_in(data_in),.ferr(ferr),.oerr(oerr),.data_out(data_out));
    uart_lab2_sctb UART_SCTB(.clk(clk),.ferr(ferr),.oerr(oerr),.data_out(data_out),.rst(rst),.data_in(data_in));

endmodule

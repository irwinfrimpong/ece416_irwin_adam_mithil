`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/15/2021 03:35:28 PM
// Design Name:
// Module Name: lab05_top
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


module lab05_top(
    input logic clk, rst,
    input logic [7:0] data_in;
    output logic cardet, error, txen,
    output logic [7:0] data_out );

    parameter BAUD_RATE = 9600;
    logic txd, valid, rdy;

    // RECIEVER
    mx_rcvr #(.BIT_RATE(BAUD_RATE)) U_RECEIVER(.clk(clk), .rst(rst), .rxd(txd), .valid(valid), .cardet(cardet), .error(error), .data(data_out));

    // TRANSMITTER
    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) U_TRANSMITTER(.clk(clk),.rst(rst),.valid(valid), .data(data_in), .rdy(rdy), .txen(txen), .txd(txd));

endmodule

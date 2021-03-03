`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/02/2021 06:49:44 PM
// Design Name:
// Module Name: lab02_top
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


module lab02_top(
    input logic clk,rst,BTNU,BTND,
    input [7:0] sw,
    output logic rdy_led, rdy_ext, txd, txd_ext

    );
    logic valid, pulse_output;

    assign valid = pulse_output|BTND;

    single_pulser SINGLE_PULSER(.clk(clk), .din(BTNU), .d_pulse(pulse_output));
    transmitter_top UART_XMIT(.clk(clk) , .rst(rst), .valid(valid), .data(sw), .txd(txd), .rdy(rdy_led));
    assign rdy_ext = rdy_led;
    assign txd_ext = txd;
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Mithil Shah, Irwin Frimpong, Adam Tunnell
//
// Create Date: 03/22/2021 06:37:05 PM
// Design Name: UART Receiver
// Module Name: uart_lab2test_top
// Project Name: UART Receiver
// Description: top-level module connecting uart reciever to uart transmitter
// for simulation
//
// Dependencies: transmitter_top, uart_rcvr
//
//////////////////////////////////////////////////////////////////////////////////


module uart_lab2test_top(
    input logic clk , rst,
    input logic [7:0] data_in,
    output logic ferr, oerr,
    output logic [7:0] data_out
    );

    logic valid, rdy, txd;
    parameter BAUD_RATE = 9600;

    transmitter_top #(.BAUD_RATE(BAUD_RATE)) DUV_TRANS (.clk(clk) ,.rst(rst), .valid(valid),.data(data_in),.txd(txd),.rdy(rdy));
    uart_rcvr #(.BAUD_RATE(BAUD_RATE)) DUV (.clk(clk),.rst(rst),.rxd(txd),.rdy(rdy),.valid(valid),.ferr(ferr),.oerr(oerr),.data(data_out));
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 04/15/2021 03:35:28 PM
// Design Name: Manchester Reciever
// Module Name: lab05_top
// Project Name: Manchester Receiver Implementation
// Description: Top level file used for self checking testbenches
// Dependencies: mxtest_21,mx_rcvr,manchester_xmit, single_pulser,sync_fifo, uart_trans_top
//////////////////////////////////////////////////////////////////////////////////


module lab05_top(
    //input logic clk, rst,send,btnd,
    input logic clk, rst,send,
    input logic [5:0] length,
    output logic cardet, error, txen,
    output logic [7:0] data_out );

    parameter BAUD_RATE = 9600;
    logic txd, valid, rdy,buffer_valid,uart_txd,uart_rdy,buffer_pulse;
    logic [7:0] data_in,buffer_out;



    mxtest_21 U_MXTEST(.clk(clk), .rst(rst), .send(send), .rdy(rdy), .frame_len(length), .data(data_in),.valid(valid));

    // RECIEVER
    mx_rcvr #(.BIT_RATE(BAUD_RATE)) U_RECEIVER(.clk(clk), .rst(rst), .rxd(txd), .valid(buffer_valid), .cardet(cardet), .error(error), .data(data_out));

    // TRANSMITTER
    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) U_TRANSMITTER(.clk(clk),.rst(rst),.valid(valid), .data(data_in), .rdy(rdy), .txen(txen), .txd(txd));



endmodule

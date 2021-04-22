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
    input logic clk, rst,send,btnd,
    input logic [5:0] length,
    output logic cardet, error, txen,
    output logic [7:0] data_out );

    parameter BAUD_RATE = 9600;
    logic txd, valid, rdy,buffer_valid,uart_txd,uart_rdy,buffer_pulse;
    logic [7:0] data_in,buffer_out;


    // logic send, d_pulse;
    // single_pulser U_SP (.clk(clk), .din(btnu), .d_pulse(d_pulse));
    // assign send = d_pulse || btnd;

    mxtest_21 U_MXTEST(.clk(clk), .rst(rst), .send(send), .rdy(rdy), .frame_len(length), .data(data_in),.valid(valid));

    // RECIEVER
    mx_rcvr #(.BIT_RATE(BAUD_RATE)) U_RECEIVER(.clk(clk), .rst(rst), .rxd(txd), .valid(buffer_valid), .cardet(cardet), .error(error), .data(data_out));

    single_pulser U_SP (.clk(clk), .din(buffer_valid), .d_pulse(buffer_pulse));

    // TRANSMITTER
    manchester_xmit #(.BAUD_RATE(9600)) U_TRANSMITTER(.clk(clk),.rst(rst),.valid(valid), .data(data_in), .rdy(rdy), .txen(txen), .txd(txd));

    // FIFO
    sync_fifo #(.DEPTH(32)) U_FIFO(.clk(clk), .rst(rst), .push(buffer_pulse),.pop(btnd),.din(data_out),.dout(buffer_out),.full(full),.empty(empty));

    // UART TRANSMITTER
    uart_trans_top UART_XMIT(.clk(clk) , .rst(rst), .valid(btnd),.data(buffer_out),.txd(uart_txd),.rdy(uart_rdy));

endmodule

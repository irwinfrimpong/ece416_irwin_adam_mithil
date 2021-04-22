`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer:
// Create Date: 04/15/2021 03:34:20 PM
// Design Name: Manchester Reciever
// Module Name: trans_rcvr_sctb_top
// Project Name:  Manchester Receiver Implementation
// Description: Self checking testbench of manchester transmitter connected to reciever
// Dependencies: lab05_top , trans_rcvr_sctb
//////////////////////////////////////////////////////////////////////////////////


module trans_rcvr_sctb_top;

    timeunit 1ns / 100ps;
    parameter CLKPD = 10;
    parameter BAUD_RATE = 9600;

    //logic clk, rst, cardet, error, txen, send, btnd;
    logic clk, rst, cardet, error, txen, send;
    logic [5:0] length;
    //logic [7:0] data_out,data_in;
    logic [7:0] data_out;
    clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

    //lab05_top #(.BAUD_RATE(BAUD_RATE)) DUV(.clk(clk), .rst(rst), .data_in(data_in), .cardet(cardet), .error(error), .txen(txen), .data_out(data_out),.send(send),.length(length));
    //lab05_top #(.BAUD_RATE(BAUD_RATE)) DUV(.clk(clk), .rst(rst),.cardet(cardet), .error(error), .txen(txen), .data_out(data_out),.send(send),.length(length), .btnd(btnd));


    //trans_rcvr_sctb #(.BAUD_RATE(BAUD_RATE)) SCTB(.clk(clk), .rst(rst), .cardet(cardet), .error(error), .txen(txen), .data_trans(data_in), .data_rec(data_out), .send(send), .length(length));
    //trans_rcvr_sctb #(.BAUD_RATE(BAUD_RATE)) SCTB(.clk(clk), .rst(rst), .cardet(cardet), .error(error), .txen(txen), .data_rec(data_out), .send(send), .length(length),.btnd(btnd));

    // 4/22 1%
    lab05_top #(.BAUD_RATE(BAUD_RATE)) DUV(.clk(clk), .rst(rst),.cardet(cardet), .error(error), .txen(txen), .data_out(data_out),.send(send),.length(length));
    trans_rcvr_sctb #(.BAUD_RATE(BAUD_RATE)) SCTB(.clk(clk), .rst(rst), .cardet(cardet), .error(error), .txen(txen),.data_rec(data_out), .send(send), .length(length));
endmodule

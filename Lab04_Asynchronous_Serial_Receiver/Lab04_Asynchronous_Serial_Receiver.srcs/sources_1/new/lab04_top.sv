`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 03/23/2021 05:24:03 PM
// Design Name: UART Receiver
// Module Name: lab04_top
// Project Name: UART Receiver
// Description: Top-level module for connecting the seven segment controller
// to the uart receiver
// Dependencies: uart_receiver, sevenseg_ctl
//
//////////////////////////////////////////////////////////////////////////////////


module lab04_top(
        input logic clk,rst,rxd,rdy,
        output logic valid,ferr, oerr,
        output logic [7:0] an_n,
        output logic [6:0] segs_n,
        output logic dp_n
        );

    logic[7:0] data;
    logic[5:0] datacon = 7'd0;
    logic d_pulse, rdy_pulsed;
    logic dp;
    assign dp_n = ~dp;

uart_rcvr #(.BAUD_RATE(9600)) UART_RCVR(.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy),.valid(valid),.ferr(ferr), .oerr(oerr),.data(data));
sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7({datacon,data[7]}), .d6({datacon,data[6]}), .d5({datacon,data[5]}), .d4({datacon,data[4]}), .d3({datacon,data[3]}), .d2({datacon,data[2]}), .d1({datacon,data[1]}),.d0({datacon,data[0]}), .segs_n(segs_n),.dp_n(dp), .an_n(an_n));

endmodule

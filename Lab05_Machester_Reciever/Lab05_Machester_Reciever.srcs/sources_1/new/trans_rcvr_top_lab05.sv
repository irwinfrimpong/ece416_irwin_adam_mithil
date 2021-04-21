`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/20/2021 09:18:29 PM
// Design Name:
// Module Name: trans_rcvr_top_lab05
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


module trans_rcvr_top_lab05(
    input logic clk, rst,btnu,
    input logic [5:0] length,
    output logic cardet, error, txen,
    output logic [7:0] an_n,
    output logic [6:0] segs_n,
    output logic dp_n
    );


    parameter BAUD_RATE = 9600;
    logic txd, valid, rdy;
    logic [7:0] data_in,data_out;
    logic[5:0] datacon = 7'd0;

    logic d_pulse;
    single_pulser U_SP (.clk(clk), .din(btnu), .d_pulse(d_pulse));
    assign send = d_pulse; 

    mxtest_21 U_MXTEST(.clk(clk), .rst(rst), .send(send), .rdy(rdy), .frame_len(length), .data(data_in),.valid(valid));

    // RECIEVER
    mx_rcvr #(.BIT_RATE(BAUD_RATE)) U_RECEIVER(.clk(clk), .rst(rst), .rxd(txd), .valid(valid), .cardet(cardet), .error(error), .data(data_out));

    // TRANSMITTER
    manchester_xmit #(.BAUD_RATE(9600)) U_TRANSMITTER(.clk(clk),.rst(rst),.valid(valid), .data(data_in), .rdy(rdy), .txen(txen), .txd(txd));

    // SEVEN SEG DISPLAY

    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7({datacon,data_out[7]}), .d6({datacon,data_out[6]}), .d5({datacon,data_out[5]}), .d4({datacon,data_out[4]}), .d3({datacon,data_out[3]}), .d2({datacon,data_out[2]}), .d1({datacon,data_out[1]}),.d0({datacon,data_out[0]}), .segs_n(segs_n),.dp_n(dp), .an_n(an_n));
endmodule

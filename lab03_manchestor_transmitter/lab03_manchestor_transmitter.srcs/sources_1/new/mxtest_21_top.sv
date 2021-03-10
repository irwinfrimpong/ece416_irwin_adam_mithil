//-----------------------------------------------------------------------------
// Module Name   : mx21_top - top-level module for mxtest_21
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : March 1 2021
//-----------------------------------------------------------------------------
// Description   : Generates a burst of characters on the ready-valid
// interface of the UART transmitter when send is asserted
//-----------------------------------------------------------------------------

module mxtest_21_top(
    input logic clk, rst, btnu, btnd,
    input logic [5:0] sw,
    output txd, txen, rdy, rdy_led
    );

    logic send, d_pulse;

    assign rdy_led = rdy;

    single_pulser U_SP (.clk(clk), .din(btnu), .d_pulse(d_pulse));

    assign send = d_pulse || btnd;

    parameter BAUD_RATE=10000;

    logic valid;
    logic [7:0] data;

    mxtest_21 U_MXTEST (.clk(clk), .rst(rst), .send(send), .rdy(rdy), .frame_len(sw), .data(data), .valid(valid));

    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) U_MX4 (.clk(clk), .rst(rst), .valid(valid), .data(data), .rdy(rdy), .txen(txen), .txd(txd));

endmodule: mxtest_21_top

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer:Mithil Shah, Irwin Frimpong, Adam Tunnell
//
// Create Date: 04/20/2021 09:18:29 PM
// Design Name: Macnhester Reciever
// Module Name: trans_rcvr_top_lab05
// Project Name: Manchester Receiver Implementation
//
// Description: Top Level file for hardware
//
// Dependencies: single_pulser,mxtest_21,mx_rcvr,manchester_xmit, sync_fifo, uart_trans_top,sevenseg_ctl
//////////////////////////////////////////////////////////////////////////////////


module trans_rcvr_top_lab05(
    input logic clk, rst,btnu,btnd,
    input logic [5:0] length,
    output logic cardet, error, txen,
    output logic [7:0] an_n,
    output logic [6:0] segs_n,
    output logic dp_n,uart_txd,uart_rdy,full,empty
    );


    parameter BAUD_RATE = 9600;
    logic txd, valid, rdy, d_pulse,btnd_pulse,buffer_valid, valid_pulse;
    logic [7:0] data_in,data_out, buffer_out;
    logic[5:0] datacon = 7'd0;

    single_pulser U_SP (.clk(clk), .din(btnu), .d_pulse(d_pulse));
    single_pulser U_SP2 (.clk(clk), .din(btnd), .d_pulse(btnd_pulse));
    single_pulser U_SP3 (.clk(clk), .din(buffer_valid), .d_pulse(valid_pulse));

    assign send = d_pulse;


    mxtest_21 U_MXTEST(.clk(clk), .rst(rst), .send(send), .rdy(rdy), .frame_len(length), .data(data_in),.valid(valid));

    // RECIEVER
    mx_rcvr #(.BIT_RATE(BAUD_RATE)) U_RECEIVER(.clk(clk), .rst(rst), .rxd(txd), .valid(buffer_valid), .cardet(cardet), .error(error), .data(data_out));


    // MACNHESTER TRANSMITTER
    manchester_xmit #(.BAUD_RATE(9600)) U_TRANSMITTER(.clk(clk),.rst(rst),.valid(valid), .data(data_in), .rdy(rdy), .txen(txen), .txd(txd));

    // FIFO
    sync_fifo #(.DEPTH(32)) U_FIFO(.clk(clk), .rst(rst), .push(valid_pulse),.pop(btnd_pulse),.din(data_out),.dout(buffer_out),.full(full),.empty(empty));

    // UART TRANSMITTER
    uart_trans_top UART_XMIT(.clk(clk) , .rst(rst), .valid(btnd_pulse),.data(buffer_out),.txd(uart_txd),.rdy(uart_rdy));

    // SEVEN SEG DISPLAY - displaying fifo contents as they are popped on the seven seg display
    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7({datacon,buffer_out[7]}), .d6({datacon,buffer_out[6]}), .d5({datacon,buffer_out[5]}), .d4({datacon,buffer_out[4]}), .d3({datacon,buffer_out[3]}), .d2({datacon,buffer_out[2]}), .d1({datacon,buffer_out[1]}),.d0({datacon,buffer_out[0]}), .segs_n(segs_n),.dp_n(dp), .an_n(an_n));

endmodule

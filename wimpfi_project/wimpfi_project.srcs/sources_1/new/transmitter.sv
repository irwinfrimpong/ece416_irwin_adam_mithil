`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/29/2021 02:53:37 PM
// Design Name:
// Module Name: transmitter
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


module transmitter(
    input logic clk, rst, xvalid, xsend, cardet, fs_cteq, difs_eq,slot_eq,
    input logic [7:0] xdata,
    output logic [7:0] xerrcnt, pop_count,
    output logic xrdy, txd, xbusy, txen,failsafe_enb, failsafe_rst,difs_rst, difs_enb,slot_clr,slot_enb,slotreg_enb
    );

    logic valid, buffer_pop, full, empty, rdy, buffer_clr, xrdy_assert, xvalid_pulse, xsend_pulse,xrdy_clear;
    logic [7:0] trans_buffdata, cntl_data;
    // assign xrdy =empty && xrdy_assert;
    parameter RATE_HZ = 50_000 ;



    single_pulser XVALID_SINGLEPULSER(.clk(clk),.din(xvalid),.d_pulse(xvalid_pulse));
    single_pulser XSEND_SINGLEPULSER(.clk(clk), .din(xsend), .d_pulse(xsend_pulse));

    // Manchetser Transmitter
    manchester_xmit #(.BAUD_RATE(RATE_HZ)) MX_XMIT(.clk(clk),.rst(rst),.valid(valid),.data(cntl_data),.rdy(rdy),.txen(txen),.txd(txd));

    trans_fsm MX_XMIT_CONTROLLER(.clk(clk), .rst(rst), .rdy(rdy), .difs_eq(difs_eq), .xsend(xsend_pulse), .cardet(cardet), .slot_eq(slot_eq), .buffdata_empty(empty), .trans_buffdata(trans_buffdata), .data(cntl_data),
    .xbusy(xbusy), .failsafe_enb(failsafe_enb), .failsafe_rst(failsafe_rst), .difs_rst(difs_rst), .difs_enb(difs_enb), .slot_clr(slot_clr), .slot_enb(slot_enb), .buffer_pop(buffer_pop), .valid(valid), .slotreg_enb(slotreg_enb),.buffer_clr(buffer_clr),.xrdy_assert(xrdy_assert),.xrdy_clear(xrdy_clear));

    sync_fifo #(.WIDTH(8),.DEPTH(255)) TRANS_BUFFER(.clk(clk), .rst(rst||buffer_clr), .push(xvalid_pulse), .pop(buffer_pop), .din(xdata), .dout(trans_buffdata),.full(full), .empty(empty));

    err_counter #(.W(8)) X_ERR_COUNT (.clk(clk), .rst(rst), .enb(fs_cteq),.q(xerrcnt));

    //ADDED FOR DEBUGGING
    err_counter #(.W(8)) BUFFER_POP_COUNT (.clk(clk), .rst(rst), .enb(buffer_pop),.q(pop_count));

    dreg XRDY_REG (.clk(clk),.rst(rst), .clr(xrdy_clear), .enb(empty && xrdy_assert),.q(xrdy));

endmodule

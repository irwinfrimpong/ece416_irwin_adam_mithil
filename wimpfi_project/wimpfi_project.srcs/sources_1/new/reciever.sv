`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 04/29/2021 02:53:37 PM
// Module Name: reciever
// Project Name: WimpFi Project
// Description: Receiver module for the WimpFi project
//
// Dependencies: mx_rcvr, single_pulser, mac_check, sync_fifo, cardet_det, dreg, rcvr_fsm
//////////////////////////////////////////////////////////////////////////////////


module reciever(
    input logic clk ,rst, rxd, rrdy,
    output logic rvalid, cardet,
    output logic [7:0] rdata, rerrcnt
    );

    logic valid_fifo, empty, rcvr_bufferpop, error_pulse, push,cardet_det,full,push_pulse, rec_buffer_clr,rvalid_c;
    logic [7:0] data_rcvr,rcvr_buffdata;
    parameter BAUD_RATE = 50_000 ;

    // rst | rvalid to address the req of ignoring incoming frame until all bytes are read from buffer
    mx_rcvr #(.BIT_RATE(BAUD_RATE)) U_RECEIVER(.clk(clk), .rst(rst), .rxd(rxd), .valid(valid_fifo), .cardet(cardet), .error(error), .data(data_rcvr));
    single_pulser SINGLE_PULSER (.clk(clk), .din(error),.d_pulse(error_pulse)) ;
    mac_check MAC_ADDY_CHECK (.clk(clk),.rst(rst),.rec_buffer_clr(rec_buffer_clr),.data_in(data_rcvr), .push(push));
    single_pulser PUSH_PULSER (.clk(clk), .din(valid_fifo & push),.d_pulse(push_pulse)) ;
    sync_fifo #(.WIDTH(8),.DEPTH(255)) U_FIFO(.clk(clk), .rst(rst), .push(push_pulse),.pop(rcvr_bufferpop),.din(data_rcvr),.dout(rcvr_buffdata),.full(full),.empty(empty));
    err_counter #(.W(8)) RCVR_ERR_COUNT(.clk(clk),.rst(rst),.enb(error_pulse),.q(rerrcnt));
    // To detect when cardet goes from high to low signal an end of tansmission
    cardet_det CARDET_DETECT (.clk(clk), .din(cardet),.d_pulse(cardet_det));
    dreg CARDET_REG (.clk(clk),.rst(rst),.clr(empty),.enb(cardet_det),.q(rvalid_c));
    rcvr_fsm U_CONTROLLER (.clk(clk),.rrdy(rrdy), .rst(rst),.rcvr_empty(empty),.rvalid_c(rvalid_c),.rcvr_buffdata(rcvr_buffdata),.rcvr_bufferpop(rcvr_bufferpop),.rcvr_dataout(rdata),.rec_buffer_clr(rec_buffer_clr),.rvalid(rvalid));

endmodule

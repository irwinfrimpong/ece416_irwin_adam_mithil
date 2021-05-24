`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
// Create Date: 05/12/2021 09:47:04 AM
// Module Name: xmit_adapter
// Project Name: WimpFi Project
// Description: Adapter for telling the transmitter fsm when the data frame is
// finished
// Dependencies: None
//////////////////////////////////////////////////////////////////////////////////


module xmit_adapter(
    input logic xrdy, valid,
    input logic [7:0] data,
    output logic xvalid, xsend, rdy,
    output logic [7:0] xdata
);

    always_comb begin
        xvalid = valid;
        xdata = data;
        xsend = (data == 8'h04);
        rdy = xrdy;
    end
endmodule

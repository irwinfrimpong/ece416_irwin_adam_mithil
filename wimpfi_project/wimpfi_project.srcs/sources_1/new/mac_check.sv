`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 04/29/2021 03:23:42 PM
// Module Name: mac_check
// Project Name: WimpFi Project
// Description: Checks that the destination address matches the MAC or broadcast
// address and sets a register when they match, only allowing matching
// transmissions through
//
// Dependencies: dreg
//
//////////////////////////////////////////////////////////////////////////////////


module mac_check(
    input logic clk,rst,rec_buffer_clr,
    input logic [7:0] data_in,
    output logic push
    );

    localparam  mac_address = 8'b00100100;
    logic recieve;

    //Checks for mac address and braodcast address
    assign recieve = (mac_address == data_in)||(8'h2A == data_in)? 1'b1 : 1'b0;

    // Register for the Push Signal for Fifo
    dreg REC_BUFFER_REG(.clk(clk),.rst(rst),.clr(rec_buffer_clr),.enb(recieve),.q(push));


endmodule

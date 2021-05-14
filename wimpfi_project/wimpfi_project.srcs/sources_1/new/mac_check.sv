`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/29/2021 03:23:42 PM
// Design Name:
// Module Name: mac_check
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


module mac_check(
    input logic clk,rst,rec_buffer_clr,
    input logic [7:0] data_in,
    output logic push
    );

    localparam  mac_address = 8'b00100100;
    logic recieve;
    //Checks for mac address and braodcast address
    assign recieve = (mac_address == data_in)||(8'h2A == data_in)? 1'b1 : 1'b0;

    dreg REC_BUFFER_REG(.clk(clk),.rst(rst),.clr(rec_buffer_clr),.enb(recieve),.q(push));


endmodule

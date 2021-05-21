`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/20/2021 10:59:38 PM
// Design Name:
// Module Name: network_interface
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


module network_interface(
    input logic clk,rst, rxd, xvalid, xsnd, rrdy,
    input logic [7:0] xdata,
    output logic txen, txd, xrdy, rvalid,
    output logic [7:0] rdata, rerrcnt, xerrcnt

    );

logic cardet;

    reciever RECIEVER (.clk(clk) ,.rst(rst), .rxd(rxd), .rrdy(rrdy), .rvalid(rvalid), .cardet(cardet), .rdata(rdata), .rerrcnt(rerrcnt));








endmodule

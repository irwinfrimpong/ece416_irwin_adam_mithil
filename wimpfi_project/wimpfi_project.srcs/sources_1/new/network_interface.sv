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
    input logic clk, rst, rxd, xvalid, xsend, rrdy,
    input logic [7:0] xdata,
    output logic txen, txd, xrdy, rvalid,cardet,difs_eq,
    output logic [7:0] rdata, rerrcnt, xerrcnt,pop_count
    );



    reciever RECIEVER (.clk(clk) ,.rst(rst), .rxd(rxd), .rrdy(rrdy), .rvalid(rvalid), .cardet(cardet), .rdata(rdata), .rerrcnt(rerrcnt));

    datapath TRANSMITTER(.clk(clk),.rst(rst),.xvalid(xvalid),.xsend(xsend),.cardet(cardet),.xdata(xdata),.xrdy(xrdy),.txen(txen),.txd(txd),.xerrcnt(xerrcnt),.pop_count(pop_count), .difs_eq(difs_eq));


endmodule

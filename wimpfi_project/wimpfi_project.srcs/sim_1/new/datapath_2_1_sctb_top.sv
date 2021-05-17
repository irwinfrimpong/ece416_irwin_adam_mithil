`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/16/2021 10:46:10 PM
// Design Name:
// Module Name: datapath_2_1_sctb_top
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


module datapath_2_1_sctb_top;

    timeunit 1ns / 100ps;

    parameter CLKPD = 10;
    parameter BAUD_RATE = 50_000;

    logic clk, rst, rxd, a_txd, valid, rdy, txen, cardet,rrdy, rvalid;
    logic [7:0] data, rdata, rerrcnt;

    clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

    datapath2_1_sctb DUV_SCTB (.clk(clk),.rst(rst), .valid(valid),.data_trans(data));
    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) MANCHESTER_TRANSMITTER(.clk(clk), .rst(rst), .valid(valid), .data(data),.rdy(rdy), .txen(txen),.txd(rxd));

    reciever RECIEVER (.clk(clk) ,.rst(rst),.rxd(rxd),.rrdy(rrdy),.rvalid(rvalid),.cardet(cardet),.rdata(rdata), .rerrcnt(rerrcnt));
    uart_xmit #(.BAUD_RATE(9600)) SERIAL_TRANS (.clk(clk) , .rst(rst), .valid(rvalid), .data(rdata), .txd(a_txd), .rdy(rrdy));


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/17/2021 06:37:47 PM
// Design Name:
// Module Name: datapath_1_sctb_top
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


module datapath_1_sctb_top;

timeunit 1ns / 100ps;

 parameter CLKPD = 10;
 parameter BAUD_RATE = 50_000;



logic clk, rst,xvalid,xsend,cardet, xrdy,txen, txd, valid,rdy,rxd, ferr,oerr;
logic [7:0] xdata , xerrcnt, data,pop_count;
assign cardet = '0;

clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

datapath #(.RATE_HZ(50_000)) XMIT_DATAPATH(.clk(clk), .rst(rst),.xvalid(xvalid), .xsend(xsend), .cardet(cardet),.xdata(xdata),.xrdy(xrdy), .txen(txen), .txd(txd),.xerrcnt(xerrcnt),.pop_count(pop_count));

xmit_adapter XMIT_ADAPTER(.xrdy(xrdy), .valid(valid), .data(data), .xvalid(xvalid), .xsend(xsend), .rdy(rdy), .xdata(xdata));

uart_rcvr #(.BAUD_RATE(9600)) SERIAL_RCVR(.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy),.valid(valid),.ferr(ferr),.oerr(oerr),.data(data));

//datapath1_sctb DUV_SCTB (.clk(clk), .rst(rst), .rxd(rxd), .rdy(rdy));
datapath1_sctb DUV_SCTB (.clk(clk), .rst(rst), .rxd(rxd));



endmodule

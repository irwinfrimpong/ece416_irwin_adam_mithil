`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/06/2021 01:46:57 PM
// Design Name:
// Module Name: wimpfitrans_sctb_top
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


module wimpfitrans_sctb_top;

    timeunit 1ns / 100ps;

       parameter CLKPD = 10;
       parameter BAUD_RATE = 9600;

       logic clk,rst,txd,txen, xrdy,xvalid,xsend,cardet;
       logic [7:0] xdata,xerrcnt ;

       clk_gen #(.CLKPD(CLKPD)) CG(.clk(clk));

       wimpfitrans_sctb SCTB (.clk(clk),.xrdy(xrdy),.txen(txen), .txd(txd), .xerrcnt(xerrcnt), .xdata(xdata),.rst(rst),.xvalid(xvalid), .xsend(xsend), .cardet(cardet));

       datapath DUV_TRANS(.clk(clk), .rst(rst),.xvalid(xvalid), .xsend(xsend), .cardet(cardet),.xdata(xdata),.xrdy(xrdy), .txen(txen), .txd(txd),.xerrcnt(xerrcnt));

endmodule

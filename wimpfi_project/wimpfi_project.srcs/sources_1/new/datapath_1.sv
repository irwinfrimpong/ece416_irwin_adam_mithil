`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/14/2021 10:25:35 AM
// Design Name:
// Module Name: datapath_1
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

// Hardware Top Level File for the Transmitter Side

module datapath_1(input logic clk, rst, a_rxd, cardet,
    output logic txd, txen,
    output logic dp_n,
    output logic [7:0] an_n,
    output logic [6:0] segs_n
    );

    logic [6:0] blank ;
    logic [3:0] hundreds_xmit, tens_xmit, ones_xmit;
    logic xvali, xrdy,xsend;
    logic [7:0] data, xdata;
    assign blank = '0;


    datapath XMIT_DATAPATH(.clk(clk), .rst(rst),.xvalid(xvalid), .xsend(xsend), .cardet(cardet),.xdata(xdata),.xrdy(xrdy), .txen(txen), .txd(txd),.xerrcnt(xerrnt));

    xmit_adapter XMIT_ADAPTER(.clk(clk), .rst(rst), .xrdy(xrdy), .valid(valid), .data(data), .xvalid(xvalid), .xsend(xsend), .rdy(rdy), .xdata(xdata));

    uart_rcvr #(.BAUD_RATE(9600)) SERIAL_RCVR(.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy),.valid(calid),.ferr(ferr),.oerr(oerr),.data(data));

    dbl_dabble BCD_RCVR (.b(xerrcnt), .hundreds(hundreds_xmit), .tens(tens_xmit), .ones(ones_xmit));

    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7(blank), .d6(blank), .d5(blank), .d4(blank), .d3(blank), .d2({3'b000,hundreds_xmit}), .d1({3'b000,tens_xmit}),.d0({3'b000,ones_xmit}), .segs_n(segs_n),.dp_n(dp_n), .an_n(an_n));


endmodule

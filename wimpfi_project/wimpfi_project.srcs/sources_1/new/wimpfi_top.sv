`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/12/2021 07:02:02 PM
// Design Name:
// Module Name: wimpfi_top
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


module wimpfi_top(
    input logic clk,rst,a_rxd,
    output logic txen, txd, dp_n,
    output logic [7:0] an_n,
    output logic [6:0] segs_n
    );

    logic [7:0] data, xdata, xerrcnt;
    logic rxd, rdy, valid, ferr, oerr, xrdy, xvalid, xsend;
     logic[6:0] blank;
    logic[3:0] ones_trans, tens_trans, hundreds_trans;


    uart_rcvr SERIAL_RCVR(.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy),.valid(valid),.ferr(ferr),.oerr(oerr),.data(data));


    xmit_adapter SMIT_ADAPTER(.clk(clk), .rst(rst),.xrdy(xrdy),.valid(valid),.data(data),.xvalid(xvalid),.xsend(xsend),.rdy(rdy),.xdata(xdata));

    //datapath DATAPATH(.clk(clk), .rst(rst),.xvalid(xvalid),.xsend(xsend),.rrdy(rrdy),.rxd(a_rxd),.xdata(xdata),.xrdy(xrdy), .txen(txen), .txd,rvalid,xerrcnt, rdata, rerrcnt);


    //uart_xmit #(.BAUD_RATE(9600)) SERIAL_TRANS (.clk(clk) , .rst(rst), .valid(rvalid), .data(rdata), .txd(a_txd), .rdy(rrdy));

    dbl_dabble BCD_TRANS(.b(xerrcnt), .hundreds(hundreds_trans), .tens(tens_trans), .ones(ones_trans));

    //dbl_dabble BCD_RECIEVR(.b(xerrcnt), .hundreds(hundreds), .tens(tens), .ones(ones));

    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7(blank), .d6(blank), .d5(blank), .d4(blank), .d3(blank), .d2({3'b000,hundreds_trans}), .d1({3'b000,tens_trans}),.d0({3'b000,ones_trans}), .segs_n(segs_n),.dp_n(dp_n), .an_n(an_n));


endmodule

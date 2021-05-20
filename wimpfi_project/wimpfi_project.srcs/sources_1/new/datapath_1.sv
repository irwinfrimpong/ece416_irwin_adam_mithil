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

module datapath_1(
    input logic clk, rst, a_rxd,
   // output logic txd, txen,cfgdat,
    output logic txd,cfgdat,
    output logic dp_n,cfgclk,txen_led,txd_led,
    output logic [7:0] an_n,
    output logic [6:0] segs_n
    );

    logic [6:0] blank ;
    logic [3:0] hundreds_xmit, tens_xmit, ones_xmit, hundreds_data, tens_data, ones_data;
    logic xvalid, xrdy,xsend,valid,cardet,rdy,ferr,oerr;
    logic [7:0] data, xdata,xerrcnt,pop_count;
    assign blank = '0;
    assign cfgclk = '0 ;
    assign cfgdat = '1;
    assign cardet = '0;
    assign txen_led= ~txen ;
    assign txd_led = txd;


    datapath #(.RATE_HZ(50_000)) XMIT_DATAPATH(.clk(clk), .rst(rst),.xvalid(xvalid), .xsend(xsend), .cardet(cardet),.xdata(xdata),.xrdy(xrdy), .txen(txen), .txd(txd),.xerrcnt(xerrcnt), .pop_count(pop_count));

    xmit_adapter XMIT_ADAPTER(.xrdy(xrdy), .valid(valid), .data(data), .xvalid(xvalid), .xsend(xsend), .rdy(rdy), .xdata(xdata));

    uart_rcvr #(.BAUD_RATE(9600)) SERIAL_RCVR(.clk(clk),.rst(rst),.rxd(a_rxd),.rdy(rdy),.valid(valid),.ferr(ferr),.oerr(oerr),.data(data));

    dbl_dabble BCD_RCVR (.b(pop_count), .hundreds(hundreds_xmit), .tens(tens_xmit), .ones(ones_xmit));

    dbl_dabble BCD_RCVR_TEST (.b(data), .hundreds(hundreds_data), .tens(tens_data), .ones(ones_data)); //USED FOR TESTING

    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7(blank), .d6(blank), .d5({3'b000,hundreds_data}), .d4({3'b000,tens_data}), .d3({3'b000,ones_data}), .d2({3'b000,hundreds_xmit}), .d1({3'b000,tens_xmit}),.d0({3'b000,ones_xmit}), .segs_n(segs_n),.dp_n(dp_n), .an_n(an_n));


endmodule

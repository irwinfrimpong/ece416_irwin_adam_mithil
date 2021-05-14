`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/12/2021 08:35:26 PM
// Design Name:
// Module Name: datapath_2
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

// Reciver top level to test recieving data
module datapath_2(input logic clk,rst,rxd,
    output logic dp_n, a_txd,
    output logic [7:0] an_n,
    output logic [6:0] segs_n
    );

    logic rrdy, rvalid, cardet;
    logic [7:0] rdata, rerrcnt;
    logic [6:0] blank ;
    logic [3:0] hundreds_rcvr, tens_rcvr, ones_rcvr;

    assign blank = '0;

    reciever RECIEVER (.clk(clk) ,.rst(rst),.rxd(rxd),.rrdy(rrdy),.rvalid(rvalid),.cardet(cardet),.rdata(rdata), .rerrcnt(rerrcnt));

    uart_xmit #(.BAUD_RATE(9600)) SERIAL_TRANS (.clk(clk) , .rst(rst), .valid(valid), .data(rdata), .txd(a_txd), .rdy(rrdy));

    dbl_dabble BCD_RCVR (.b(rerrcnt), .hundreds(hundreds_rcvr), .tens(tens_rcvr), .ones(ones_rcvr));

    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7(blank), .d6(blank), .d5(blank), .d4(blank), .d3(blank), .d2({3'b000,hundreds_rcvr}), .d1({3'b000,tens_rcvr}),.d0({3'b000,ones_rcvr}), .segs_n(segs_n),.dp_n(dp_n), .an_n(an_n));

endmodule

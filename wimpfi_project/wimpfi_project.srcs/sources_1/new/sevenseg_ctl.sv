`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Irwin Frimpong , Adam Tunnell, Mithil Shah
//
// Create Date: 02/18/2021 01:15:00 PM
// Design Name: 7-Segment LED Controller
// Module Name: sevenseg_ctl
// Project Name: 7-Segment LED Controller
// Target Devices:
// Tool Versions:
// Description: Generates time multiplexed display of eight digits on the Nexys Board Seven-Seg displays
//
// Dependencies: rate_enb, counter, dec_3_8_n, mux8,sevenseg_ext
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module sevenseg_ctl(
    input logic clk, rst,
    input logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0,
    output logic [6:0] segs_n,
    output logic dp_n,
    output logic [7:0] an_n
    );

    //Wires!
    logic enb; // Rate Enb Output, counter input
    logic [2:0] q; //counter output, decoder and mux input
    logic [6:0] y; // Mux 8 Output, sevenseg_ext input
    logic [7:0] an;

    // Instantiating Rate Enable
    rate_enb #(.RATE_HZ(40000)) RATE_TOP(.clk(clk), .rst(rst), .clr(rst), .enb_out(enb));

    //Instantiating Counter
    counter_7seg #(.W(3)) COUNTER_7SEG(.clk(clk),.rst(rst),.enb(enb),.q(q));

    //Instantiating Decoder
    dec_3_8_n DECODER(.a(q),.y(an));
    assign an_n = ~an;

    //Instantiating Mux
    mux8 #(.W(7)) MUX8(.d0(d0), .d1(d1), .d2(d2), .d3(d3), .d4(d4), .d5(d5), .d6(d6), .d7(d7), .sel(q), .y(y));

    //Instantiating SEVENSEG_EXT
    sevenseg_ext SEVENSEG_EXT (.data(y), .segs_n(segs_n), .dp_n(dp_n));

endmodule
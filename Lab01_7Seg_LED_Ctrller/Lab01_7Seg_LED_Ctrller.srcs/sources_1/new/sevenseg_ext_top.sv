`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Irwin Frimpong , Adam Tunnell, Mithil Shah
//
// Create Date: 02/11/2021 02:21:49 PM
// Design Name: 7-Segment LED Controller
// Module Name: sevenseg_ext_top
// Project Name: 7-Segment LED Controller
// Target Devices:
// Tool Versions:
// Description: Top Level File for sevenseg_ext instantiation
//
// Dependencies: sevenseg_ext
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module sevenseg_ext_top(
    input logic [6:0] SW,
    output logic [6:0] seg_n,
    output logic dp_n,
    output logic [7:0] an_n

    );

    // Turning on the right most 7 Seg Display- Logic Low
    assign an_n = 8'b11111110;
    sevenseg_ext SEVENSEG_TOP(.data(SW), .segs_n(segs_n), .dp_n(dp_n));
endmodule

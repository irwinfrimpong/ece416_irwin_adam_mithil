`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/29/2021 02:55:04 PM
// Design Name:
// Module Name: rate_enb
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


module rate_enb(input logic clk, rst, clr, output logic enb_out);
    parameter RATE_HZ = 100;  // desired rate in Hz (change as needed)
    parameter CLKFREQ = 100_000_000;  // Nexys4 clock
    localparam DIVAMT = (CLKFREQ / RATE_HZ);
    localparam DIVBITS = $clog2(DIVAMT);   // enough bits to represent DIVAMT

    logic [DIVBITS-1:0] q;

    assign enb_out = (q == DIVAMT-1);

    always_ff @(posedge clk)
        if (rst || clr || enb_out) q <= '0;
        else                       q <= q + 1;

endmodule: rate_enb

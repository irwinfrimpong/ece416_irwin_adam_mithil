`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2021 05:11:21 PM
// Design Name: 
// Module Name: hw4_2
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


module hw4_2(
input logic clk,rst,
   output logic [3:0] q1, q2
);

   logic        clr1, clr2;

   assign       clr1 = (q1 == 4'd9);
   assign       clr2 = (q2 == 4'd9);

   always_ff @(posedge clk)
      if (clr1 || rst) q1 <= 4'd0;
      else q1 <= q1 + 1;

   always_ff @(posedge clk or posedge clr2 )
      if (clr2 || rst) q2 <= 4'd0;
      else q2 <= q2 + 1;

endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/07/2021 05:38:14 PM
// Design Name:
// Module Name: t_flipflop
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


module t_flipflop(
    input logic clk, rst, enb,clr,
    output logic q

    );

always @(posedge clk)
begin
    if(rst || clr )
    q <= 0;
    else if (enb)
    q <= ~q;
    else q <= q;
end

endmodule

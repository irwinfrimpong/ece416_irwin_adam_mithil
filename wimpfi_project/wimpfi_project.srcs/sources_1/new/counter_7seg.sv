`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2021 05:19:52 PM
// Design Name: 
// Module Name: counter_7seg
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


module counter_7seg #(parameter W=4) (
    input logic clk, rst, enb,
    output logic [W-1:0] q
    );

    always_ff @(posedge clk)
        if (rst)      q <= '0;
        else if (enb) q <= q + 1;

endmodule: counter_7seg
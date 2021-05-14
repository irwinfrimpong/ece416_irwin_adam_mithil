`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/12/2021 08:55:37 PM
// Design Name:
// Module Name: cardet_det
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


module cardet_det(
    input logic clk, din,
    output logic d_pulse);
    logic dq1, dq2;

    always_ff @(posedge clk)
    begin
        dq1 <= din;
        dq2 <= dq1;
    end

    assign d_pulse = ~dq1 & dq2;
endmodule: cardet_det

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/04/2021 02:21:49 PM
// Design Name:
// Module Name: txd_output
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


module txd_output( input logic clk,rst,NRZ, sq_wave, txd_idle_en,enb,
    output logic txd
    );

    always_ff @(posedge clk)
    begin
        if(rst) txd <= 1'b1;
        else if(enb) txd <= ~(NRZ ^ sq_wave)| txd_idle_en;
    end
endmodule

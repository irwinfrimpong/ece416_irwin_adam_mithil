`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 05/12/2021 08:55:37 PM
// Module Name: cardet_det
// Project Name: WimpFi Project
// Description: Detects the falling edge of a signal. Used to detect falling
// edge of cardet
// Dependencies: None
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

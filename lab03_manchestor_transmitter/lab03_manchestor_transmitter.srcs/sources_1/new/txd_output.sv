`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
// Create Date: 03/04/2021 02:21:49 PM
// Design Name: Manchester Transmitter
// Module Name: txd_output
// Project Name: Manchester Transmitter
// Target Devices:
// Tool Versions:
// Description: module that takes a NRZ signal and a square wave and XNORs them
// in order to create a manchester coded output. The XNOR can also
// be overwritten to only output a 1 using the txd_idle_en input
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

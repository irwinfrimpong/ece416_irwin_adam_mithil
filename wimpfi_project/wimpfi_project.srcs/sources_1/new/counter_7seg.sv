`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
// Create Date: 03/23/2021 05:19:52 PM
// Module Name: counter_7seg
// Project Name: Wimpfi Project
// Description:  Counter Used for the Seven-Seg Display 
//////////////////////////////////////////////////////////////////////////////////


module counter_7seg #(parameter W=4) (
    input logic clk, rst, enb,
    output logic [W-1:0] q
    );

    always_ff @(posedge clk)
        if (rst)      q <= '0;
        else if (enb) q <= q + 1;

endmodule: counter_7seg

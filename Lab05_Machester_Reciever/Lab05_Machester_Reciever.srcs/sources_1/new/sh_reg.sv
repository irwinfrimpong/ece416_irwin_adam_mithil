`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 03/17/2021 09:35:37 PM
// Design Name: Manchester Receiver
// Module Name: sh_reg
// Project Name: Manchester Receiver Implementation
// Description: shift register for Manchester Recever , shifts in one bit at a time
// and outputs the stored bits on enable
//
//////////////////////////////////////////////////////////////////////////////////


module sh_reg #(parameter W=8)(
    input logic clk,rst,edge_det, sh_en,sh_rst, sh_ld,
    output logic [7:0] data
    );

    logic [7:0] d ;

    always_ff @(posedge clk)
    begin
        if (rst || sh_rst) data <= 8'd0;
        else if (sh_en) data <= d;
        else data <= data;

        if (rst || sh_rst) d <= 8'd0;
        else if (sh_ld) d <= {edge_det, d[W-1:1]};
        else d <= d;
    end
endmodule

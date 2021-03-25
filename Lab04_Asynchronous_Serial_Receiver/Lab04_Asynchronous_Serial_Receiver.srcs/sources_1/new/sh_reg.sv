`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 03/17/2021 09:35:37 PM
// Design Name: UART Receiver
// Module Name: sh_reg
// Project Name: UART Receiver
// Description: shift register for UART Receiver, shifts in one bit at a time
// and outputs the stored bits on enable
//
//////////////////////////////////////////////////////////////////////////////////


module sh_reg #(parameter W=8)(
    input logic clk,rst,rxd, sh_en,sh_rst, sh_ld,
    output logic [7:0] data
    );

    logic [7:0] d ;
    //assign data = sh_en ? d : data;

    always_ff @(posedge clk)
    if (rst || sh_rst)
        begin
            d <= 8'd0;
            data <= 8'd0;
        end
    else if (sh_ld) d <= {rxd,d[W-1:1]};
    else if (sh_en) data <= d;
    else d <= d;
endmodule

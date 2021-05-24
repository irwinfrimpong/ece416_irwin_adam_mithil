`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
// Create Date: 05/17/2021 05:51:13 PM
// Module Name: sh_reg_uartrcvr
// Project Name: WimpFi Project
// Description: Shift Register Module used for the UART Receiver
//////////////////////////////////////////////////////////////////////////////////

module sh_reg_uartrcvr#(parameter W=8)(
    input logic clk,rst,rxd, sh_en,sh_rst, sh_ld,
    output logic [7:0] data
    );

    logic [7:0] d ;

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

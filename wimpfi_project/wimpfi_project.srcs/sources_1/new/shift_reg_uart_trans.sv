`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 05/13/2021 12:07:43 PM
// Module Name: shift_reg_uart_trans
// Project Name: WimpFi Project
// Description: Shift register for the uart transmitter
//////////////////////////////////////////////////////////////////////////////////

module shift_reg_uart_trans(
    input logic clk, sh_ld, sh_idle, sh_en, rst,br_en,
    input logic [7:0] data,
    output logic txd);

    logic [8:0] d;

    always_ff @(posedge clk)
    begin
        if(rst)
        begin
            txd <= 1'b1;
            d <= 10'd0;
        end
        else if(sh_en && br_en)
        begin
            d <= d >> 1;
            txd <= d[0];
        end
        else if(sh_ld)
        begin
            d <= {1'b1,data};
            txd <= 1'd0;
        end
        else if(sh_idle)
        begin
            txd <= 1'b1;
            d <= d;
        end
        else
        begin
            txd <= txd;
            d <= d;
        end
    end
endmodule

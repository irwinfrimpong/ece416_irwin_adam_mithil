`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunell, Irwin Frimpong, Mithil Shah
// Create Date: 03/07/2021 05:38:14 PM
// Design Name: Manchester Transmitter
// Module Name: t_flipflop
// Project Name: Manchester Transmiter
// Description: t_flipflop used to generate square wave
//////////////////////////////////////////////////////////////////////////////////


module t_flipflop(
    input logic clk, rst, enb,clr,
    output logic q

    );

always @(posedge clk)
begin
    if(rst || clr )
    q <= 0;
    else if (enb)
    q <= ~q;
    else q <= q;
end

endmodule

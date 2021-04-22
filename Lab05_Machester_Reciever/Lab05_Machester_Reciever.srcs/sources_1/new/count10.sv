`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: lafayette College
// Engineer: Mithil Shah, Irwin Frimpong, Adam Tunnell
//
// Create Date: 02/25/2021 01:15:26 PM
// Design Name: Count10
// Module Name: control_fsm
// Project Name: Serial Data Transmitter
// Target Devices:
// Tool Versions:
// Description: Counts up from 0 to 9
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module count10 (
    input logic ct_clr, clk, rst, ct_en,br_en,
    output logic ct_eq9
    );

    logic[3:0] Q ;  // Variable used for countiing

   //assign ct_eq9 = (Q == 4'd9);

    always_ff @(posedge clk)
    begin
        if (ct_clr || rst)
        begin
            ct_eq9 <= 1'b0;
            Q <= 4'b0;
        end
        else if (ct_en && br_en)
        begin
            Q <= Q +1;
            ct_eq9 <= (Q == 4'd8);
        end
        //else if (Q == 4'd9 ) ct_eq9 <= 1'b1;
        else Q <= Q ;

    end
endmodule

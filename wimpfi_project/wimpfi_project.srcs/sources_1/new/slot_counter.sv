`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/08/2021 04:43:23 PM
// Design Name:
// Module Name: slot_counter
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

module slot_counter(
    input logic ct_clr, clk, rst, ct_en,br_en,
    input logic [5:0] max_val,
    output logic ct_max
    );
    localparam W = $clog2(512);
    logic[W-1:0] Q ;  // Variable used for countiing

    always_ff @(posedge clk)
    begin
        if (ct_clr || rst)
        begin
            ct_max <= 1'b0;
            Q <= '0;
        end
        else if (ct_en && br_en)
        begin
            Q <= Q + 1;
            ct_max <= (Q >= (max_val*8));
        end
        else Q <= Q ;

    end
endmodule

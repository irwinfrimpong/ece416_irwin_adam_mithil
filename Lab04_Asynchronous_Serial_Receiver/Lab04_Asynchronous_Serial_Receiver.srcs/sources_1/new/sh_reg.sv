`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/17/2021 09:35:37 PM
// Design Name:
// Module Name: sh_reg
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


module sh_reg #(parameter W=8)(
    input logic clk,rst,rxd, sh_en,sh_rst, sh_ld,br_en,
    output logic [7:0] data
    );

    logic [7:0] d ;
    assign data = sh_en ? d : data;

    always_ff @(posedge clk)
    if (rst || sh_rst)
        begin
            d <= 8'd0;
            data <= 8'd0;
        end
    else if (sh_ld && br_en) d <= {rxd,d[W-1:1]};
    else d <= d;
endmodule

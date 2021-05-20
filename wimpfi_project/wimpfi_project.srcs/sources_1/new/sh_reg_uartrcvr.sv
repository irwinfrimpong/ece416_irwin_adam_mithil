`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 05:51:13 PM
// Design Name: 
// Module Name: sh_reg_uartrcvr
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


module sh_reg_uartrcvr#(parameter W=8)(
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

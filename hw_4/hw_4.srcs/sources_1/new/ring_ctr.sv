`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2021 06:09:39 PM
// Design Name: 
// Module Name: ring_ctr
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


module ring_ctr #(parameter W=4)(
    input logic clk, rst,enb,s_in,
    output logic [W-1:0] q
    );
    
    always_ff @(posedge clk)
    begin
    if (rst) q <= 1;
    else if (enb && (q[W-1] == 1)) q <= 1 ;
    else if (enb) q <= {q[W-1:0],s_in };
    else q <= q;
    end

endmodule //

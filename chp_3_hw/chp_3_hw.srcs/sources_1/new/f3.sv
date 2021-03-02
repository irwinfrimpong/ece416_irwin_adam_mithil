`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2021 12:02:35 PM
// Design Name: 
// Module Name: f3
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


module f3(
input logic [7:0] a, b, c,
    output logic [7:0] y
);

always_comb begin
    if (a > b) y = a;
    else y = b;
    if (c > y) y = c;
end

endmodule: f3



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2021 12:29:20 PM
// Design Name: 
// Module Name: ctest
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


module ctest (
    input logic [7:0] a, b,
    input logic [1:0] s,
    output logic [7:0] y1, y2
);

    always_comb
      begin
      y1 = 0; 
      y2 = 0 ;
        case (s)
            2'b00 : 
              begin
                y1 = a;
                y2 = b;
              end
            2'b01 : if (a < b) y1 = a;
                    else y1 = b;
            2'b10 : if (a > b) y2 = a;
                    else y2 = b;

        endcase
      end
endmodule

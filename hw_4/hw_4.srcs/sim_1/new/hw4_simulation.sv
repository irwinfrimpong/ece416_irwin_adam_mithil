`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2021 05:13:15 PM
// Design Name: 
// Module Name: hw4_simulation
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


module hw4_simulation; 

logic clk,rst;
logic [3:0] q1,q2; 

hw4_2 DUV (.clk(clk),.rst(rst), .q1(q1), .q2(q2)) ;

// Clock Generator
    always
    begin
        clk = 0 ; #10
        clk = 1 ; #10;
    end
    
    // Generating Stimulus 
    initial begin 
    rst =0;
     @(posedge clk); //turn on reset
      rst = 1; #20;
     @(posedge clk);
       rst = 0; #20;
      #220 ;
      $stop;
     end
 endmodule  
    



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2021 06:13:32 PM
// Design Name: 
// Module Name: ringctr_sim
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


module ringctr_sim;

logic clk,rst,enb,s_in;
logic [8:0] q;

ring_ctr #(.W(9)) DUV (.clk(clk),.rst(rst), .enb(enb), .q(q), .s_in(1'b0)) ;

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
       enb = 1;
      #500 ;
      $stop;
     end
 endmodule  
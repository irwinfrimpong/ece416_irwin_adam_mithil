`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2021 11:27:20 AM
// Design Name: 
// Module Name: lab02_sim
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


module lab02_sim;
    logic clk,rst,BTNU,BTND,txd,txd_ext,rdy_led,rdy_ext;
    logic [7:0] sw ;
    
    // Instantiating the Lab02 Top Level File
    
    lab02_top #(.BAUD_RATE(50000000)) DUV (.clk(clk), .rst(rst),.BTNU(BTNU),.BTND(BTND),.sw(sw),.txd(txd),.txd_ext(txd_ext),.rdy_led(rdy_led),.rdy_ext(rdy_ext));
    
        // Clock Generator
    always
    begin
        clk = 0 ; #10
        clk = 1 ; #10;
    end

        //generating stimulus
    initial begin
        rst = 0;
        BTNU = 0;
        BTND= 0 ;
        sw = 8'b0;
        @(posedge clk); //turn on reset
        rst = 1; #20;
        @(posedge clk);
        #1 rst = 0;
        #10 sw = 8'b00110011;
        #40 BTNU = 1; 
        BTND = 1;
        @(posedge clk);
        #20
        BTNU = 0;
        BTND = 0;
        #370;
        BTNU = 1 ;
        sw = 8'b00000000;
        #20
        BTNU=0 ;
     end

  
endmodule

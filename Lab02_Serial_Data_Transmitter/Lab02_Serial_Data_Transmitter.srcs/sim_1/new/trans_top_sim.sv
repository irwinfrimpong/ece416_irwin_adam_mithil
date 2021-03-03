`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/25/2021 02:44:48 PM
// Design Name:
// Module Name: trans_top_sim
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


module trans_top_sim;
    logic clk, rst, valid, txd, rdy;
    logic [7:0] data;

    // Instantiate Transmitter Top Level
    transmitter_top #(.BAUD_RATE(50000000)) DUV(.clk(clk), .rst(rst), .valid(valid), .data(data), .txd(txd), .rdy(rdy));

    // Clock Generator
    always
    begin
        clk = 0 ; #10
        clk = 1 ; #10;
    end

    //generating stimulus
    initial begin
        rst = 0;
        valid = 0;
        data = 8'b0;
        @(posedge clk); //turn on reset
        rst = 1; #30;
        @(posedge clk);
        #1 rst = 0;
        #10 data = 8'b01010101;
        #40 valid = 1;
        @(posedge clk);
        #20
        valid = 0;
        #370;
        valid = 1 ;
        data = 8'b00110011;
        #20
        valid =0 ;






    end
endmodule

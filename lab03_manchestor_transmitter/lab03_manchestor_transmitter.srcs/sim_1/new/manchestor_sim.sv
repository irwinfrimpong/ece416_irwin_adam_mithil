`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/04/2021 03:40:30 PM
// Design Name:
// Module Name: manchestor_sim
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


module manchestor_sim;
    logic clk, rst, valid, rdy, txen, txd;
    logic [7:0] data;


    // Instantiate Transmitter Top Level
    manchester_xmit #(.BAUD_RATE(10000000)) DUV(.clk(clk), .rst(rst), .valid(valid), .data(data), .txd(txd), .rdy(rdy), .txen(txen));

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
        #30 valid = 1;
        @(posedge clk);
        #20
        valid = 0;
        data = 8'b00110011;
        #1510;
        valid = 1 ;
        #100
        valid =0 ;
        data = 8'b11110000;
        #1510;
        valid = 1 ;
        #100
        valid =0 ;
    end

endmodule

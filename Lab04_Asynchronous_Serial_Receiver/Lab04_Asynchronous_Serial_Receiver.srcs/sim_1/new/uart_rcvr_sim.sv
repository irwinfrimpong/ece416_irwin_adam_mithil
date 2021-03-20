`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/18/2021 01:14:01 PM
// Design Name:
// Module Name: uart_rcvr_sim
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


module uart_rcvr_sim;

    logic clk,rst,rxd,rdy,valid,ferr, oerr;
    logic[7:0] data;

    parameter BAUD_RATE = 100000;
    uart_rcvr #(.BAUD_RATE(BAUD_RATE)) UART_RCVR(.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy), .valid(valid),.ferr(ferr), .oerr(oerr),.data(data));

    parameter CLK_PD = 10;
    localparam BITPD_NS = 1_000_000_000/BAUD_RATE;
    logic [7:0] inputdata;

    always begin
        clk = 0; #(CLK_PD/2);
        clk = 1; #(CLK_PD/2);
    end

    initial begin
        rst = 1 ;
        rdy = 1 ;
        rxd = 1;
        inputdata = 8'b01010101;
    @(posedge clk) #1;
        rst = 0;

    @(posedge clk) #1;
    repeat(5)
    begin
        //#(BITPD_NS)
        //rdy = 0;
        rxd = 0;  // Startbit
        #(BITPD_NS)
        rxd = inputdata[0];
        rdy = 0;
        #(BITPD_NS)
        rxd = inputdata[1];
        #(BITPD_NS)
        rxd = inputdata[2];
        #(BITPD_NS)
        rxd = inputdata[3];
        #(BITPD_NS)
        rxd = inputdata[4];
        #(BITPD_NS)
        rxd = inputdata[5];
        #(BITPD_NS)
        rxd = inputdata[6];
        #(BITPD_NS)
        rxd = inputdata[7];
        #(BITPD_NS)
        rxd = 1; // Stop bit
        rdy = 1;
        //#(BITPD_NS);
    end
    // $stop;
     end
endmodule

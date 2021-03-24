`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/23/2021 08:52:44 PM
// Design Name:
// Module Name: lab04_sim_top
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


module lab04_sim_top;
 logic clk,rst,rxd,rdy,valid,ferr, oerr, dp_n;
 logic [7:0] an_n;
 logic [6:0] segs_n;

lab04_top DUV(.clk(clk),.rst(rst),.rxd(rxd),.rdy(rdy),.valid(valid),.ferr(ferr), .oerr(oerr),.an_n(an_n),.segs_n(segs_n),.dp_n(dp_n));

parameter BAUD_RATE = 9600;
parameter CLK_PD = 10;
localparam BITPD_NS = 1_000_000_000/BAUD_RATE;
logic [7:0] inputdata, inputdata2;

always begin
    clk = 0; #(CLK_PD/2);
    clk = 1; #(CLK_PD/2);
end

initial begin
    rst = 1 ;
    rdy = 1 ;
    rxd = 1;
    inputdata = 8'b01100001;
    inputdata2 = 8'b01100001;
@(posedge clk) #1;
    rst = 0;

//@(posedge clk) #1;
//repeat(5)
//begin
//    //#(BITPD_NS)
//    //rdy = 0;
//    rxd = 0;  // Startbit
//    #(BITPD_NS)
//    rxd = inputdata[0];
//    rdy = 0;
//    #(BITPD_NS)
//    rxd = inputdata[1];
//    #(BITPD_NS)
//    rxd = inputdata[2];
//    #(BITPD_NS)
//    rxd = inputdata[3];
//    #(BITPD_NS)
//    rxd = inputdata[4];
//    #(BITPD_NS)
//    rxd = inputdata[5];
//    #(BITPD_NS)
//    rxd = inputdata[6];
//    #(BITPD_NS)
//    rxd = inputdata[7];
//    #(BITPD_NS)
//    rxd = 1; // Stop bit
////    rdy = 1;
//    #(BITPD_NS);
//    rdy = 1;
//end
@(posedge clk) #1;
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
//    rdy = 1;
    #(BITPD_NS);
    rdy = 1;
// $stop;

rxd = 0;  // Startbit
    #(BITPD_NS)
    rxd = inputdata2[0];
    rdy = 0;
    #(BITPD_NS)
    rxd = inputdata2[1];
    #(BITPD_NS)
    rxd = inputdata2[2];
    #(BITPD_NS)
    rxd = inputdata2[3];
    #(BITPD_NS)
    rxd = inputdata2[4];
    #(BITPD_NS)
    rxd = inputdata2[5];
    #(BITPD_NS)
    rxd = inputdata2[6];
    #(BITPD_NS)
    rxd = inputdata2[7];
    #(BITPD_NS)
    rxd = 1; // Stop bit
//    rdy = 1;
    #(BITPD_NS);
    rdy = 1;
// $stop;
 end
endmodule

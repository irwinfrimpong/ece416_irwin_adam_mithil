`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/04/2021 06:06:50 PM
// Design Name:
// Module Name: mx_rcvr_tb
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


module mx_rcvr_tb;

logic clk, rst, rxd, valid, cardet, error;
logic [7:0] data;

mx_rcvr MX_RCVR(.clk(clk),.rst(rst),.rxd(rxd),.valid(valid),.cardet(cardet),.error(error),.data(data));

parameter BAUD_RATE = 9600;
parameter CLK_PD = 10;
localparam BITPD_NS = 1_000_000_000/BAUD_RATE;
logic [15:0] sfd, preamble;

always begin
    clk = 0; #(CLK_PD/2);
    clk = 1; #(CLK_PD/2);
end

initial begin
    rst = 1;
    preamble = 16'b10_01_10_01_10_01_10_01;
    sfd = 16'b10_10_01_10_01_01_01_01;

    @(posedge clk) #1;
        rst = 0;


        rxd = preamble[0];
        #(BITPD_NS/2)
        rxd = preamble[1];
        #(BITPD_NS/2)
        rxd = preamble[2];
        #(BITPD_NS/2)
        rxd = preamble[3];
        #(BITPD_NS/2)
        rxd = preamble[4];
        #(BITPD_NS/2)
        rxd = preamble[5];
        #(BITPD_NS/2)
        rxd = preamble[6];
        #(BITPD_NS/2)
        rxd = preamble[7];
        #(BITPD_NS/2)
        rxd = preamble[8];
        #(BITPD_NS/2)
        rxd = preamble[9];
        #(BITPD_NS/2)
        rxd = preamble[10];
        #(BITPD_NS/2)
        rxd = preamble[11];
        #(BITPD_NS/2)
        rxd = preamble[12];
        #(BITPD_NS/2)
        rxd = preamble[13];
        #(BITPD_NS/2)
        rxd = preamble[14];
        #(BITPD_NS/2)
        rxd = preamble[15];
        #(BITPD_NS/2)
        rxd = sfd[0];
        #(BITPD_NS/2)
        rxd = sfd[1];
        #(BITPD_NS/2)
        rxd = sfd[2];
        #(BITPD_NS/2)
        rxd = sfd[3];
        #(BITPD_NS/2)
        rxd = sfd[4];
        #(BITPD_NS/2)
        rxd = sfd[5];
        #(BITPD_NS/2)
        rxd = sfd[6];
        #(BITPD_NS/2)
        rxd = sfd[7];
        #(BITPD_NS/2)
        rxd = sfd[8];
        #(BITPD_NS/2)
        rxd = sfd[9];
        #(BITPD_NS/2)
        rxd = sfd[10];
        #(BITPD_NS/2)
        rxd = sfd[11];
        #(BITPD_NS/2)
        rxd = sfd[12];
        #(BITPD_NS/2)
        rxd = sfd[13];
        #(BITPD_NS/2)
        rxd = sfd[14];
        #(BITPD_NS/2)
        rxd = sfd[15];
        #(BITPD_NS/2);



end

endmodule

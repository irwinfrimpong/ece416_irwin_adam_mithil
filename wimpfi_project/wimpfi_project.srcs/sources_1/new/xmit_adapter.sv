`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/12/2021 09:47:04 AM
// Design Name:
// Module Name: xmit_adapter
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


module xmit_adapter(
    input logic xrdy, valid,
    input logic [7:0] data,
    output logic xvalid, xsend, rdy,
    output logic [7:0] xdata
);

    always_comb begin
        xvalid = valid;
        xdata = data;
        xsend = (data == 8'h04);
        rdy = xrdy;
    end
endmodule

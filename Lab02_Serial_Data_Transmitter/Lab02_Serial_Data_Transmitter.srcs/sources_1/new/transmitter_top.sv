`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/25/2021 02:33:47 PM
// Design Name:
// Module Name: transmitter_top
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


module transmitter_top(
    input logic clk , rst, valid,
    input logic [7:0] data,
    output logic txd, rdy

    );
      parameter BAUD_RATE = 9600;
      

    logic sh_ld, sh_idle, sh_en, br_st,ct_clr, ct_en, ct_eq9;

    control_fsm CONTROLLER_TRANS(.valid(valid), .clk(clk), .ct_eq9(ct_eq9), .rst(rst), .br_en(br_en), .rdy(rdy), .sh_ld(sh_ld), .sh_idle(sh_idle), .sh_en(sh_en), .br_st(br_st), .ct_clr(ct_clr), .ct_en(ct_en));
    datapath_uart_trans #(.BAUD_RATE(BAUD_RATE)) DATAPATH_TRANS (.sh_ld(sh_ld), .sh_idle(sh_idle), .sh_en(sh_en), .br_st(br_st), .ct_clr(ct_clr), .clk(clk), .rst(rst), .ct_en(ct_en), .data(data),.ct_eq9(ct_eq9), .txd(txd), .br_en(br_en));
endmodule

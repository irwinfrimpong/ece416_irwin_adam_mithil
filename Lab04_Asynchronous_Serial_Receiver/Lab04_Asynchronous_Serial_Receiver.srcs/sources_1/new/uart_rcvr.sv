`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/17/2021 10:16:24 PM
// Design Name:
// Module Name: uart_rcvr
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

module uart_rcvr(
    input logic clk,rst,rxd,rdy,
    output logic valid,ferr, oerr,
    output logic [7:0] data
    );

    parameter BAUD_RATE = 9600;
    logic set_oerr, clr_oerr, set_ferr, clr_ferr, br_en, br_st, ct_initclr,
    ct_initenb, ct_initeq, br_2en, br_2st, sh_en, sh_ld,sh_rst, ct_clr, ct_en, ct_eq,
    clr_valid, set_valid;

    controller U_FSM_CNTRL(.clk(clk), .rst(rst), .rdy(rdy), .rxd(rxd), .br_en(br_en),.ct_initeq(ct_initeq), .br_2en(br_2en), .ct_eq(ct_eq),.valid(valid),
    .set_oerr(set_oerr), .clr_oerr(clr_oerr), .set_ferr(set_ferr), .clr_ferr(clr_ferr), .br_st(br_st), .ct_initclr(ct_initclr), .ct_initenb(ct_initenb),
    .br_2st(br_2st), .sh_en(sh_en), .sh_ld(sh_ld),.sh_rst(sh_rst),.ct_clr(ct_clr), .ct_en(ct_en), .clr_valid(clr_valid), .set_valid(set_valid));

    datapath #(.BAUD_RATE(BAUD_RATE)) U_DATAPATH(.clk(clk), .rst(rst),.set_ferr(set_ferr), .clr_ferr(clr_ferr), .set_oerr(set_oerr), .clr_oerr(clr_oerr), .set_valid(set_valid), .clr_valid(clr_valid),
    .ct_initclr(ct_initclr), .ct_initenb(ct_initenb), .br_2st(br_2st), .sh_en(sh_en),.sh_ld(sh_ld),.sh_rst(sh_rst),.ct_clr(ct_clr),.ct_en(ct_en), .rxd(rxd),
    .br_en(br_en), .ct_initeq(ct_initeq), .br_2en(br_2en), .ct_eq(ct_eq), .valid(valid), .ferr(ferr), .oerr(oerr), .data(data));

endmodule

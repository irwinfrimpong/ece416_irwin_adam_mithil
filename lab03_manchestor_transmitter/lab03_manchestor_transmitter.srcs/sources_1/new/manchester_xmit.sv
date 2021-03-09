`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/04/2021 03:25:37 PM
// Design Name:
// Module Name: manchester_xmit
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


module manchester_xmit(
    input logic clk,rst,valid,
    input logic [7:0] data ,
    output logic rdy, txen, txd
    );

    parameter BAUD_RATE = 9600;

    logic idle_clr, idle_en, idle_biteq, ct_en, ct_clr, ct_eq7, br_en, br_st, br2_st, sh_idle, sh_ld, sh_en, txd_idle_en,txen_reg, enb2x_out;

    datapath #(.BAUD_RATE(BAUD_RATE)) DATAPATH(.clk(clk),.rst(rst),.idle_clr(idle_clr), .idle_en(idle_en), .ct_en(ct_en), .ct_clr(ct_clr), .br_st(br_st), .br2_st(br2_st), .sh_idle(sh_idle), .sh_ld(sh_ld), .sh_en(sh_en),.data(data), .ct_eq7(ct_eq7), .idle_biteq(idle_biteq), .br_en(br_en), .txd(txd), .txd_idle_en(txd_idle_en), .enb2x_out(enb2x_out));
    control_fsm CONTROLLER(.valid(valid), .clk(clk), .ct_eq7(ct_eq7), .rst(rst), .br_en(br_en), .idle_biteq(idle_biteq), .rdy(rdy), .sh_ld(sh_ld), .sh_idle(sh_idle), .sh_en(sh_en), .br_st(br_st), .ct_clr(ct_clr), .ct_en(ct_en), .br_2st(br2_st),
    .idle_clr(idle_clr), .idle_en(idle_en), .txen(txen_reg), .txd_idle_en(txd_idle_en));
    dreg #(.W(1)) DELAYTXEN(.clk(clk), .rst(rst),.enb(enb2x_out),.d(txen_reg), .q(txen));
endmodule

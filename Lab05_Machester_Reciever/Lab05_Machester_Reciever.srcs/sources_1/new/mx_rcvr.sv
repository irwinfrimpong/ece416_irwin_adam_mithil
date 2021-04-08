`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/04/2021 05:43:39 PM
// Design Name:
// Module Name: mx_rcvr
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


module mx_rcvr(
    input logic clk, rst, rxd,
    output logic valid, cardet, error,
    output logic [7:0] data
    );

    parameter BIT_RATE = 9600;

    logic sfd_cnt_eq, sfd_cnt_enb, sfd_cnt_rst, clr_tout, timeout_eq, t_enb, enb_wait, wait_eq, rst_wait, rst_pre, pre_det, sfd_det, rst_sfd, eof_det, rst_eof, rst_edg, edge_h, edge_l, rst_err, err_det, br_4en, br_4st, br_8en, br_8st, errct_eq, errct_rst, ct_rst, ct_enb, ct_eq, sh_en, sh_ld, clr_cardet, set_cardet, clr_err_reg, set_err_reg, clr_valid, set_valid;

    control_fsm CONTROLLER (.clk(clk),.rst(rst), .sfd_cnt_eq(sfd_cnt_eq), .wait_eq(wait_eq), .pre_det(pre_det), .sfd_det(sfd_det), .eof_det(eof_det), .edge_h(edge_h), .edge_l(edge_l), .err_det(err_det), .br_4en(br_4en), .br_8en(br_8en), .errct_eq(errct_eq), .ct_eq(ct_eq), .timeout_eq(timeout_eq),
    .sfd_cnt_rst(sfd_cnt_rst), .sfd_cnt_enb(sfd_cnt_enb), .enb_wait(enb_wait), .rst_wait(rst_wait), .rst_pre(rst_pre), .rst_sfd(rst_sfd), .rst_eof(rst_eof), .rst_edg(rst_edg), .rst_err(rst_err), .br_4st(br_4st), .br_8st(br_8st), .errct_rst(errct_rst), .ct_rst(ct_rst), .ct_enb(ct_enb), .sh_en(sh_en), .sh_ld(sh_ld), .clr_cardet(clr_cardet),.set_cardet(set_cardet),.clr_err_reg(clr_err_reg),.set_err_reg(set_err_reg),.clr_valid(clr_valid),.set_valid(set_valid));

    datapath #(.BIT_RATE(BIT_RATE)) DATAPATH (.clk(clk),.rst(rst),.rxd(rxd),.sfd_cnt_enb(sfd_cnt_enb),.sfd_cnt_rst(sfd_cnt_rst),.rst_wait(rst_wait),.rst_pre(rst_pre),.rst_sfd(rst_sfd),.rst_eof(rst_eof),.rst_edg(rst_edg),.rst_err(rst_err),.br_4st(br_4st),.br_8st(br_8st),.errct_rst(errct_rst),.ct_rst(ct_rst),.ct_enb(ct_enb),
    .sh_en(sh_en),.sh_ld(sh_ld),.clr_cardet(clr_cardet),.set_cardet(set_cardet),.clr_err_reg(clr_err_reg),.set_err_reg(set_err_reg),.clr_valid(clr_valid),.set_valid(set_valid),.clr_tout(clr_tout),.t_enb(t_enb),
    .sfd_cnt_eq(sfd_cnt_eq),.wait_eq(wait_eq),.pre_det(pre_det),.sfd_det(sfd_det),.eof_det(eof_det),.edge_h(edge_h),.edge_l(edge_l),.err_det(err_det),.br_4en(br_4en),.br_8en(br_8en),.errct_eq(errct_eq),.ct_eq(ct_eq),.valid(valid),.error(error),.cardet(cardet),.data(data));

endmodule

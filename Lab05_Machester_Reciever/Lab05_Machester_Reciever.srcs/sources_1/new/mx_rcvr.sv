`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer:  Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 04/04/2021 05:43:39 PM
// Design Name: Manchester Reciever
// Module Name: mx_rcvr
// Project Name:  Manchester Receiver Implementation
// Description: Top level file for the manchester reciever
//
// Dependencies: control_fsm, datapath
//////////////////////////////////////////////////////////////////////////////////

module mx_rcvr(
    input logic clk, rst, rxd,
    output logic valid, cardet, error,
    output logic [7:0] data
    );

    parameter BIT_RATE = 9600;

    logic sfd_cnt_eq, sfd_cnt_enb, sfd_cnt_rst, clr_tout, timeout_eq, t_enb, enb_wait, wait_eq, rst_wait, rst_pre, pre_det, sfd_det, rst_sfd, eof_det, rst_eof, rst_edg, edgerise_det, edgefall_det, rst_err, err_det, br_en, br_st,br_4en, br_4st, br_8en, br_8st, errct_eq, errct_rst, ct_rst, ct_enb, ct_eq, sh_en, sh_ld, clr_cardet, set_cardet, clr_err_reg, set_err_reg, clr_valid, set_valid,sh_ct_max,clr_sh_max,set_sh_max, errwait_enb, errwaitct_rst, errwaitct_eq;

    control_fsm CONTROLLER (.clk(clk),.rst(rst), .sfd_cnt_eq(sfd_cnt_eq), .wait_eq(wait_eq), .pre_det(pre_det), .sfd_det(sfd_det), .eof_det(eof_det), .edgerise_det(edgerise_det), .edgefall_det(edgefall_det), .err_det(err_det),.br_en(br_en), .br_4en(br_4en), .br_8en(br_8en), .errct_eq(errct_eq), .ct_eq(ct_eq), .timeout_eq(timeout_eq), .sh_ct_max(sh_ct_max),
    .sfd_cnt_rst(sfd_cnt_rst), .sfd_cnt_enb(sfd_cnt_enb), .t_enb(t_enb),.enb_wait(enb_wait), .rst_wait(rst_wait), .rst_pre(rst_pre), .rst_sfd(rst_sfd), .rst_eof(rst_eof), .rst_edg(rst_edg), .rst_err(rst_err),.br_st(br_st), .br_4st(br_4st), .br_8st(br_8st), .errct_rst(errct_rst), .ct_rst(ct_rst), .ct_enb(ct_enb), .sh_en(sh_en), .sh_ld(sh_ld), .clr_cardet(clr_cardet),.set_cardet(set_cardet),.clr_err_reg(clr_err_reg),.set_err_reg(set_err_reg),.clr_valid(clr_valid),.set_valid(set_valid),.clr_tout(clr_tout), .set_sh_max(set_sh_max), .clr_sh_max(clr_sh_max),.errwait_enb(errwait_enb), .errwaitct_rst(errwaitct_rst), .errwaitct_eq(errwaitct_eq));

    datapath #(.BIT_RATE(BIT_RATE)) DATAPATH (.clk(clk),.rst(rst),.rxd(rxd),.sfd_cnt_enb(sfd_cnt_enb),.sfd_cnt_rst(sfd_cnt_rst),.errwait_enb(errwait_enb), .errwaitct_rst(errwaitct_rst),.rst_wait(rst_wait),.rst_pre(rst_pre),.rst_sfd(rst_sfd),.rst_eof(rst_eof),.rst_edg(rst_edg),.rst_err(rst_err),.br_st(br_st),.br_4st(br_4st),.br_8st(br_8st),.errct_rst(errct_rst),.ct_rst(ct_rst),.ct_enb(ct_enb),
    .sh_en(sh_en),.sh_ld(sh_ld),.clr_cardet(clr_cardet),.set_cardet(set_cardet),.clr_err_reg(clr_err_reg),.set_err_reg(set_err_reg),.clr_valid(clr_valid),.set_valid(set_valid),.clr_tout(clr_tout),.t_enb(t_enb), .enb_wait(enb_wait),
    .sfd_cnt_eq(sfd_cnt_eq),.wait_eq(wait_eq),.pre_det(pre_det),.sfd_det(sfd_det),.eof_det(eof_det),.edgerise_det(edgerise_det),.edgefall_det(edgefall_det),.err_det(err_det),.br_4en(br_4en),.br_8en(br_8en),.br_en(br_en),.errct_eq(errct_eq),.ct_eq(ct_eq),.valid(valid),.error(error),.cardet(cardet),.data(data),.timeout_eq(timeout_eq),.clr_sh_max(clr_sh_max),.set_sh_max(set_sh_max),.sh_ct_max(sh_ct_max),.errwaitct_eq(errwaitct_eq));

endmodule

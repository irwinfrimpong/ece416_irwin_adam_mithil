`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 04/04/2021 04:52:45 PM
// Design Name: Manchester Reciever
// Module Name: datapath
// Project Name: Manchester Receiver Implementation
// Description: Datapath Module
// Dependencies: correlator, dreg, counter,sh_reg, rate_enb
//////////////////////////////////////////////////////////////////////////////////

module datapath_rcvr(
    input logic clk, rst, rxd, sfd_cnt_enb, sfd_cnt_rst, rst_wait, rst_pre,rst_sfd, rst_eof, rst_edg, rst_err,br_st, br_4st, br_8st, errct_rst,ct_rst,ct_enb, sh_en, sh_ld, clr_cardet, set_cardet, clr_err_reg, set_err_reg, clr_valid, set_valid, clr_tout, t_enb, enb_wait,clr_sh_max,set_sh_max, errwait_enb, errwaitct_rst,
    output logic sfd_cnt_eq, wait_eq, pre_det, sfd_det, eof_det, edgerise_det, edgefall_det, br_4en,br_en, br_8en, errct_eq, ct_eq,errwaitct_eq, valid, error, cardet , timeout_eq,sh_ct_max,
    output logic [7:0] data,
    output logic [3:0] byte_trans
    );
parameter BIT_RATE = 9600;
parameter CORLEN = 64;
parameter CORW = $clog2(CORLEN)+1 ;
logic l_out_pre, l_out_sfd, l_out_eof, br_100en, br_100st , br_16en, br_16st;
logic [CORW-1:0] csum_sfd;
logic [$clog2(16):0] csum_edgerise;
logic [$clog2(16):0] csum_eof;
logic [127:0] csum_pre;


//CORRELATORS

//PREAMBLE CORRELATOR
correlator #(.LEN(128), .PATTERN(128'b1111111100000000_0000000011111111_1111111100000000_0000000011111111_1111111100000000_0000000011111111_1111111100000000_0000000011111111), .HTHRESH(121), .LTHRESH(7), .W($clog2(128)+1)) PREAMBLE_COR(
.clk(clk),.rst(rst),.enb(br_16en),.d_in(rxd), .csum(csum_pre),.h_out(pre_det),.l_out(l_out_pre));

//SFD CORRELATOR
correlator #(.LEN(CORLEN), .PATTERN(64'b00001111_00001111_00001111_00001111_11110000_00001111_11110000_11110000), .HTHRESH(54), .LTHRESH(10), .W(CORW)) SFD_COR(
.clk(clk),.rst(rst),.enb(br_8en),.d_in(rxd), .csum(csum_sfd),.h_out(sfd_det),.l_out(l_out_sfd));

//EOF CORRELATOR
correlator #(.LEN(16), .PATTERN(16'b11111111_11111111), .HTHRESH(15), .LTHRESH(1), .W($clog2(16)+1)) EOF_COR(
.clk(clk),.rst(rst),.enb(br_8en),.d_in(rxd), .csum(csum_eof),.h_out(eof_det),.l_out(l_out_eof));

//EDGE DETECTION CORRELATOR
correlator #(.LEN(16), .PATTERN(16'b0000000011111111), .HTHRESH(12), .LTHRESH(4), .W($clog2(16)+1)) EDGERISE_COR(
.clk(clk),.rst(rst || rst_edg),.enb(br_100en),.d_in(rxd), .csum(csum_edgerise),.h_out(edgerise_det),.l_out(edgefall_det));


//REGISTERS

//ERROR REGISTER
dreg ERROR_REG(.clk(clk),.rst(rst),.clr(clr_err_reg),.enb(set_err_reg),.q(error));

//CARDET REGISTER
dreg CARDET_REG(.clk(clk),.rst(rst),.clr(clr_cardet),.enb(set_cardet),.q(cardet));

//VALID REGISTER
dreg VALID_REG(.clk(clk),.rst(rst),.clr(clr_valid),.enb(set_valid),.q(valid));

// SHIFT COUNT MAX REGISTERS
dreg SHIFT_MAX_REG(.clk(clk),.rst(rst),.clr(clr_sh_max),.enb(set_sh_max),.q(sh_ct_max));


//COUNTERS

// SFD COUNTER
counter #(.MAX_VAL(16)) SFD_COUNTER(.ct_clr(sfd_cnt_rst), .clk(clk), .rst(rst), .ct_en(sfd_cnt_enb),.br_en(br_en),.ct_max(sfd_cnt_eq));

// WAIT COUNTER
counter #(.MAX_VAL(1)) WAIT_COUNTER(.ct_clr(rst_wait), .clk(clk), .rst(rst), .ct_en(enb_wait), .br_en(br_4en),.ct_max(wait_eq));

//TIMEOUT COUNTER
counter #(.MAX_VAL(32)) TIMEOUT_COUNTER(.ct_clr(clr_tout), .clk(clk), .rst(rst), .ct_en(t_enb), .br_en(br_8en),.ct_max(timeout_eq));

//SHIFT COUNTER
counter #(.MAX_VAL(8)) SHIFT_COUNTER(.ct_clr(ct_rst), .clk(clk), .rst(rst), .ct_en(ct_enb), .br_en(1'b1),.ct_max(ct_eq));

//ERROR COUNTER
counter #(.MAX_VAL(8)) ERR_COUNTER(.ct_clr(errct_rst), .clk(clk), .rst(rst), .ct_en(br_en), .br_en(br_en),.ct_max(errct_eq));

// ERRWAIT_COUNTER

counter #(.MAX_VAL(6)) ERRWAIT_COUNTER(.ct_clr(errwaitct_rst), .clk(clk), .rst(rst), .ct_en(errwait_enb), .br_en(br_8en),.ct_max(errwaitct_eq));

//BYTE COUNTER
err_counter #(.W(4)) BYTE_COUNTER (.clk(clk), .rst(rst||ct_rst), .enb(ct_enb), .q(byte_trans));


//SHIFT REGISTER
sh_reg SHIFT_REG(.clk(clk), .rst(rst), .edge_det(~edgerise_det), .sh_en(sh_en), .sh_rst(rst), .sh_ld(sh_ld), .data(data));



//RATE ENABLES

//1X
rate_enb #(.RATE_HZ(BIT_RATE)) RATE_EN(.clk(clk),.rst(rst),.clr(br_st),.enb_out(br_en));

//4X
rate_enb #(.RATE_HZ(BIT_RATE*4)) RATE_4EN(.clk(clk),.rst(rst),.clr(br_4st),.enb_out(br_4en));

//8X
rate_enb #(.RATE_HZ(BIT_RATE*8)) RATE_8EN(.clk(clk),.rst(rst),.clr(br_8st),.enb_out(br_8en));

//16X
rate_enb #(.RATE_HZ(BIT_RATE*16)) RATE_16EN(.clk(clk),.rst(rst),.clr(br_16st),.enb_out(br_16en));

//64x
rate_enb #(.RATE_HZ(BIT_RATE*100)) RATE_100EN(.clk(clk),.rst(rst),.clr(br_100st),.enb_out(br_100en));

endmodule

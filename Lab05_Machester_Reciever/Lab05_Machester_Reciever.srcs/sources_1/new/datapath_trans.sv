`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Irwin Frimpong, Adam Tunnell , Mithil Shah
//
// Create Date: 03/04/2021 03:01:32 PM
// Design Name: Manchester Transmiter
// Module Name: datapath
// Project Name: Manchester Transmiter
// Target Devices:
// Tool Versions:
// Description: Datapath module for Machnester Trasnmitter
// Dependencies: rate_enb, t_flipflop,counter, sh_reg, txd_output
//////////////////////////////////////////////////////////////////////////////////


module datapath_trans(
    input logic clk,rst,idle_clr, idle_en, ct_en, ct_clr, br_st, br2_st, sh_idle, sh_ld, sh_en, txd_idle_en,sq_clr,
    input logic [7:0] data,
    output logic ct_eq15, idle_biteq, br_en, txd, enb2x_out

    );
    parameter BAUD_RATE = 9600;
    localparam BAUD_RATE2X = BAUD_RATE << 1 ;
    parameter IDLE_BITS = 2;
    parameter SHIFT_COUNT = 16;
    logic NRZ_out, sq_wave;

    // Instantiating Baud Rate Enable Module
    rate_enb #(.RATE_HZ(BAUD_RATE)) BAUD_ENB(.clk(clk), .rst(rst), .clr(br_st), .enb_out(br_en));
    // Instantiating 2X Baud Rate Enable Module for square wave
    rate_enb #(.RATE_HZ(BAUD_RATE2X)) BAUD_2XENB(.clk(clk), .rst(rst), .clr(br2_st), .enb_out(enb2x_out));

    t_flipflop SQWAVE(.clk(clk), .rst(rst),.clr(sq_clr), .enb(enb2x_out), .q(sq_wave));

    // Counter for shift register
    counter #(.MAX_VAL(SHIFT_COUNT)) COUNT16(.ct_clr(ct_clr), .clk(clk), .rst(rst), .ct_en(ct_en), .br_en(enb2x_out), .ct_max(ct_eq15));
    //Counter for idlebits
    counter #(.MAX_VAL(IDLE_BITS)) COUNTIDLE(.ct_clr(idle_clr), .clk(clk), .rst(rst), .ct_en(idle_en), .br_en(br_en), .ct_max(idle_biteq));

    shreg_trans SH_REG(.clk(clk), .sh_ld(sh_ld), .sh_idle(sh_idle), .sh_en(sh_en), .rst(rst), .br_en(br_en), .data(data), .txd(NRZ_out));

    txd_output txd_out( .clk(clk), .rst(rst), .NRZ(NRZ_out),.enb(enb2x_out),.sq_wave(~sq_wave), .txd_idle_en(txd_idle_en), .txd(txd));

endmodule
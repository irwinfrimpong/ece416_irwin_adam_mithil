`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Mithil Shah, Adam Tunnell, Irwin Frimpong
//
// Create Date: 03/17/2021 09:36:19 PM
// Design Name: UART Receiver
// Module Name: datapath_uart_rcvr
// Project Name: UART Receiver
//
// Dependencies: counter, dff, rate_enb, sh_reg
//
//////////////////////////////////////////////////////////////////////////////////

module datapath_uart_rcvr(
    input logic clk, rst,set_ferr, clr_ferr, set_oerr, clr_oerr, set_valid, clr_valid,ct_initclr, ct_initenb, br_st, br_2st, sh_en, sh_ld,sh_rst, ct_clr, ct_en, rxd,
    output logic br_en, ct_initeq, br_2en, ct_eq, valid, ferr, oerr,
    output logic [7:0] data
    );

    parameter BAUD_RATE = 9600;

    counter_uartrvcr #(.MAX_VAL(8)) U_SHIFT_COUNTER (.ct_clr(ct_clr), .clk(clk), .rst(rst), .ct_en(ct_en),.ct_max(ct_eq));
    counter_uartrvcr #(.MAX_VAL(8)) U_INIT_COUNTER (.ct_clr(ct_initclr), .clk(clk), .rst(rst), .ct_en(ct_initenb),.ct_max(ct_initeq));

    dff U_OERR_REG(.clk(clk), .rst(rst), .clr(clr_oerr), .enb(set_oerr), .q(oerr));
    dff U_FERR_REG(.clk(clk), .rst(rst), .clr(clr_ferr), .enb(set_ferr), .q(ferr));
    dff U_VALID_REG(.clk(clk), .rst(rst), .clr(clr_valid), .enb(set_valid), .q(valid));

    rate_enb #(.RATE_HZ(BAUD_RATE)) U_RATE_EN (.clk(clk), .rst(rst), .clr(br_st), .enb_out(br_en));
    rate_enb #(.RATE_HZ(BAUD_RATE*16)) U_RATE_EN_16X (.clk(clk), .rst(rst), .clr(br_2st), .enb_out(br_2en));

    sh_reg_uartrcvr #(.W(8)) UARTRCVR_SHFT_REG (.clk(clk),.rxd(rxd),.rst(rst), .sh_en(sh_en),.sh_rst(sh_rst), .sh_ld(sh_ld),.data(data));

endmodule

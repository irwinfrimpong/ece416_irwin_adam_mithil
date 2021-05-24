`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 04/29/2021 02:29:25 PM
// Module Name: datapath
// Project Name: WimpFi Project
// Description: Datapath for the WimpFi project. Instantiates and connects all
// modules used for the transmitter.
//
// Dependencies:rate_enb, counter, err_counter, dregre, slot_counter, dreg,
// transmitter
//
//
//////////////////////////////////////////////////////////////////////////////////

module datapath (
    input logic clk, rst,xvalid, xsend, cardet,
    input logic [7:0] xdata,
    output logic xrdy, txen, txd,difs_eq,
    output logic [7:0] xerrcnt, pop_count

    );


    parameter RATE_HZ = 50_000;

    logic fs_cteq, rand_enb,slotreg_enb, difs_rst,br_en;
    logic [5:0] random_count,slotreg_out;

    rate_enb #(.RATE_HZ(RATE_HZ)) RATE_ENB(.clk(clk), .rst(rst), .clr(br_st), .enb_out(br_en));

    counter #(.MAX_VAL(80)) DIFS_COUNTER  (.ct_clr(difs_rst), .clk(clk), .rst(rst), .ct_en(difs_enb),.br_en(br_en), .ct_max(difs_eq));

    err_counter #(.W(6)) RANDOM_COUNTER (.clk(clk), .rst(rst), .enb(br_en),.q(random_count)) ;
    dregre #(.W(6)) SLOT_REG (.clk(clk), .rst(rst), .enb(slotreg_enb), .d(random_count),.q(slotreg_out));
    slot_counter SLOT_COUNTER (.ct_clr(slot_clr),.clk(clk), .rst(rst), .ct_en(slot_enb),.br_en(br_en), .max_val(slotreg_out),.ct_max(slot_eq));

    counter #(.MAX_VAL(510*8)) FSAFE_COUNTER (.ct_clr(failsafe_rst), .clk(clk), .rst(rst), .ct_en(failsafe_enb),.br_en(br_en), .ct_max(fs_cteq));

    dreg FSAFE_REG(.clk(clk),.rst(rst), .clr(rst), .enb(fs_cteq), .q(sys_rst));

     transmitter #(.RATE_HZ(RATE_HZ)) XMIT( .clk(clk), .rst(rst | sys_rst), .xvalid(xvalid), .xsend(xsend), .cardet(cardet), .fs_cteq(fs_cteq), .difs_eq(difs_eq),.slot_eq(slot_eq),.xdata(xdata),
                    .xrdy(xrdy), .txd(txd), .xbusy(xbusy), .xerrcnt(xerrcnt), .txen(txen),.failsafe_enb(failsafe_enb), .failsafe_rst(failsafe_rst),.difs_rst(difs_rst),.difs_enb(difs_enb),.slot_clr(slot_clr),.slot_enb(slot_enb),.slotreg_enb(slotreg_enb),.pop_count(pop_count));



    endmodule

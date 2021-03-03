`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: lafayette College
// Engineer: Mithil Shah, Irwin Frimpong, Adam Tunnell
//
// Create Date: 02/25/2021 01:50:09 PM
// Design Name:Serial Data Transmitter
// Module Name: datapath
// Project Name: Serial Data Transmitter
// Target Devices:
// Tool Versions:
// Description: Datapath module which institates rate_en, shift_reg, and count10
//
// Dependencies:rate_en, shift_reg, and count10
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input logic sh_ld, sh_idle, sh_en, br_st, ct_clr, clk, rst, ct_en,
    input logic [7:0] data,
    output logic ct_eq9,txd,br_en
    );
    parameter BAUD_RATE = 9600;
    
    //logic br_en ;
    
    // Instantiating Rate Enable With Baud Rate of 9600
    rate_enb #(.RATE_HZ(BAUD_RATE)) RATE_EN(.clk(clk), .rst(rst), .clr(br_st), .enb_out(br_en));

    //Institating Shift Regsiter Used for Outputting TXP after every shift
    shift_reg SHIFT_REG(.clk(clk), .sh_ld(sh_ld),.sh_idle(sh_idle), .sh_en(sh_en), .rst(rst), .br_en(br_en), .data(data), .txd(txd));

    // Instantiating counter module used for counting the number of shifts
    count10 COUNT10(.ct_clr(ct_clr),.clk(clk), .rst(rst),.ct_en(ct_en), .br_en(br_en),.ct_eq9(ct_eq9));

endmodule

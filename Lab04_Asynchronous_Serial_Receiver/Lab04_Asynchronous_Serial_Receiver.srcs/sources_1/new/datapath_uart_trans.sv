`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/22/2021 06:05:27 PM
// Design Name:
// Module Name: datapath_uart_trans
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


module datapath_uart_trans(
    input logic sh_ld, sh_idle, sh_en, br_st, ct_clr, clk, rst, ct_en,
    input logic [7:0] data,
    output logic ct_eq9,txd,br_en
    );
    parameter BAUD_RATE = 9600;

    

    //logic br_en ;

    // Instantiating Rate Enable With Baud Rate of 9600
    rate_enb #(.RATE_HZ(BAUD_RATE)) RATE_EN_TRANS(.clk(clk), .rst(rst), .clr(br_st), .enb_out(br_en));

    //Institating Shift Regsiter Used for Outputting TXP after every shift
    shift_reg SHIFT_REG_TRANS(.clk(clk), .sh_ld(sh_ld),.sh_idle(sh_idle), .sh_en(sh_en), .rst(rst), .br_en(br_en), .data(data), .txd(txd));

    // Instantiating counter module used for counting the number of shifts
    count10 COUNT10_TRANS(.ct_clr(ct_clr),.clk(clk), .rst(rst),.ct_en(ct_en), .br_en(br_en),.ct_eq9(ct_eq9));

endmodule

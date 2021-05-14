`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2021 11:47:53 AM
// Design Name: 
// Module Name: uart_xmit
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


module uart_xmit(
    input logic clk , rst, valid,
    input logic [7:0] data,
    output logic txd, rdy

    );
      parameter BAUD_RATE = 9600;
      

    logic sh_ld, sh_idle, sh_en, br_st,ct_clr, ct_en, ct_eq9;

    controller_uart_trans CONTROLLER_UARTXMIT(.valid(valid), .clk(clk), .ct_eq9(ct_eq9), .rst(rst), .br_en(br_en), .rdy(rdy), .sh_ld(sh_ld), .sh_idle(sh_idle), .sh_en(sh_en), .br_st(br_st), .ct_clr(ct_clr), .ct_en(ct_en));
    datapath_uart_trans #(.BAUD_RATE(BAUD_RATE)) DATAPATH_UARTXMIT (.sh_ld(sh_ld), .sh_idle(sh_idle), .sh_en(sh_en), .br_st(br_st), .ct_clr(ct_clr), .clk(clk), .rst(rst), .ct_en(ct_en), .data(data),.ct_eq9(ct_eq9), .txd(txd), .br_en(br_en));
endmodule

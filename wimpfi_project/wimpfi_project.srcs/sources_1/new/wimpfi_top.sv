`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/12/2021 07:02:02 PM
// Design Name:
// Module Name: wimpfi_top
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


module wimpfi_top(
    input logic clk,rst,a_rxd,rxd,
    output logic txd, dp_n, a_txd,cfgclk,cfgdat,txen_led,xsend_led,cardet_led,cardet_sig,difs_led,
    output logic [7:0] an_n,
    output logic [6:0] segs_n
    );

    logic [7:0] data, xdata, rdata, xerrcnt,rerrcnt,pop_count;
    logic rdy, valid, rvalid, rrdy, ferr, oerr, xrdy, xvalid, xsend,cardet;
    logic[6:0] blank;
    logic[3:0] ones_trans, tens_trans, hundreds_trans;
    logic[3:0] ones_rec, tens_rec, hundreds_rec;
    logic[3:0] ones_pop, tens_pop, hundreds_pop;

    assign cfgdat = '1 ;
    assign cfgclk = ~txen;
    assign cardet_sig = cardet;
    //assign txd_led = ~txen;
    assign blank = '0;


    network_interface WIFI_XMIT_RCVR(.clk(clk),.rst(rst), .rxd(rxd), .xvalid(xvalid), .xsend(xsend), .rrdy(rrdy), .xdata(xdata), .txen(txen), .txd(txd), .xrdy(xrdy), .rvalid(rvalid), .rdata(rdata), .rerrcnt(rerrcnt), .xerrcnt(xerrcnt),.pop_count(pop_count), .cardet(cardet),.difs_eq(difs_eq));
    // Transmitter Side
    xmit_adapter XMIT_ADAPTER(.xrdy(xrdy),.valid(valid),.data(data),.xvalid(xvalid),.xsend(xsend),.rdy(rdy),.xdata(xdata));
    uart_rcvr SERIAL_RCVR(.clk(clk),.rst(rst),.rxd(a_rxd),.rdy(rdy),.valid(valid),.ferr(ferr),.oerr(oerr),.data(data));

    //Reciever Side
    uart_xmit #(.BAUD_RATE(9600)) SERIAL_TRANS (.clk(clk) , .rst(rst), .valid(rvalid), .data(rdata), .txd(a_txd), .rdy(rrdy));
    dreg XSEND_DEBUGGING_REG (.clk(clk),.rst(rst),.clr(rst),.enb(xsend), .q(xsend_led));
    dreg TXEN_DEBUGGING_REG (.clk(clk),.rst(rst),.clr(rst),.enb(txen), .q(txen_led));
    dreg CARDET_DEBUGGING_REG (.clk(clk),.rst(rst),.clr(rst),.enb(cardet), .q(cardet_led));
    dreg DIFFS_DEBUGGING_REG (.clk(clk),.rst(rst),.clr(rst),.enb(difs_eq), .q(difs_led));



    dbl_dabble BCD_TRANS(.b(xerrcnt), .hundreds(hundreds_trans), .tens(tens_trans), .ones(ones_trans));
    dbl_dabble BCD_RECIEVR(.b(rerrcnt), .hundreds(hundreds_rec), .tens(tens_rec), .ones(ones_rec));
    dbl_dabble POP_COUNT(.b(pop_count), .hundreds(hundreds_pop), .tens(tens_pop), .ones(ones_pop));

    sevenseg_ctl SEVENSEG_CTL (.clk(clk), .rst(rst), .d7(tens_pop), .d6(ones_pop), .d5({3'b000,hundreds_rec}), .d4({3'b000,tens_rec}), .d3({3'b000,ones_rec}), .d2({3'b000,hundreds_trans}), .d1({3'b000,tens_trans}),.d0({3'b000,ones_trans}), .segs_n(segs_n),.dp_n(dp_n), .an_n(an_n));


endmodule

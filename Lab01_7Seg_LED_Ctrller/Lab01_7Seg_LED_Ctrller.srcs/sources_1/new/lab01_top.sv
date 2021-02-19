`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/18/2021 01:40:06 PM
// Design Name:
// Module Name: lab01_top
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


module lab01_top(
    input logic clk100MHz, rst,
    output logic [7:0] an_n,
    output logic [6:0] segs_n,
    output logic dp_n,
    inout tmp_scl, // use inout only – no logic
    inout tmp_sda // use inout only – no logic
    );

    //WIRES!
    logic[3:0] ones, tens, hundreds;
    logic[6:0] blank,dash,celsius;

    logic tmp_rdy, tmp_err; // unused temp controller outputs
    // 13-bit two's complement result with 4-bit fractional part
    logic [12:0] temp;

    // instantiate the VHDL temperature sensor controller
    TempSensorCtl U_TSCTL (
    .TMP_SCL(tmp_scl), .TMP_SDA(tmp_sda), .TEMP_O(temp),
    .RDY_O(tmp_rdy), .ERR_O(tmp_err), .CLK_I(clk100MHz),
    .SRST_I(rst)
    );

    // add additional signals & instantiations here
    dbl_dabble BCD(.b(temp[11:4]), .hundreds(hundreds), .tens(tens), .ones(ones));

    // assign one = 7'b0000001;
    // assign two = 7'b0000010;
    // assign three = 7'b0000100;
    // assign four = 7'b0001000;
    // assign five = 7'b0010000;
    // assign six = 7'b0100000;
    // assign seven = 7'b1000000;
    // assign eight = 7'b0000000;

    assign dash = 7'b0110000; //segs_n = 7'b0111111;
    assign blank = 7'b1100000; //blank = 7'b1111111;
    // assign ones = ones & 7'b1011111; //turn on decimal point
    assign celsius = 7'b0101100;
    // sevenseg_ctl SEVENSEG_CTL (.clk(clk100MHz), .rst(rst), .d7(eight), .d6(seven), .d5(six), .d4(five), .d3(four), .d2(three), .d1(two), .d0(one), .segs_n(segs_n), .dp_n(dp_n), .an_n(an_n));
    sevenseg_ctl SEVENSEG_CTL (.clk(clk100MHz), .rst(rst), .d7(dash), .d6(dash), .d5(dash), .d4(blank), .d3({3'b010,hundreds}), .d2({3'b010,tens}), .d1({3'b000,ones}), .d0(celsius), .segs_n(segs_n), .dp_n(dp_n), .an_n(an_n));
endmodule: lab01_top

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/06/2021 01:20:50 PM
// Design Name:
// Module Name: wimpfitrans_sctb
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


module wimpfitrans_sctb(
    input logic clk,xrdy,txen, txd,
    input logic [7:0] xerrcnt,
    output logic [7:0] xdata,
    output logic rst,xvalid, xsend, cardet
    );

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;


    task check( xrdy, exp_xrdy, txen, exp_txen, txd, exp_txd, xerrcnt, exp_xerrcnt);
        if (xrdy != exp_xrdy) begin
            $display("%t error: expected xrdy=%b actual xrdy=%b",
            $time, exp_xrdy, xrdy);
            errcount++;
        end
        if (txen != exp_txen) begin
            $display("%t error: expected txen=%b actual txen=%b",
            $time, exp_txen, txen);
            errcount++;
        end
        if (txd != exp_txd) begin
            $display("%t error: expected txd=%b actual txd=%b",
            $time, exp_txd, txd);
            errcount++;
        end
        if (xerrcnt != exp_xerrcnt) begin
            $display("%t error: expected xerrcnt=%b actual xerrcnt=%b",
            $time, exp_xerrcnt, xerrcnt);
            errcount++;
        end
        // place additional tests here
    endtask: check

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    //transaction tasks
    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        check(xrdy,1,txen,0,txd,0,xerrcnt,0);
    endtask: reset_duv

    task senddata(logic [7:0] din);
        xvalid = 0;
        xdata = din;
        #(CLOCK_PD);
        xvalid= 1;
        #(CLOCK_PD)
        xvalid= 0;
    endtask: senddata



    initial begin
           $timeformat(-9, 0, "ns", 6);
           $monitor( /* add signals to monitor in console */ );
           reset_duv;
           repeat(1)
           begin
           xsend = 0;
           cardet = 0;
           #(CLOCK_PD*2);
           cardet = 1;
           senddata(8'b00000001); // DEST
           #(CLOCK_PD);
           senddata(8'b11001011); //SOURCE
           #(CLOCK_PD);
           senddata(8'h30);// TYPE
           #(CLOCK_PD);
           senddata(8'b11101010); // DATA
           #(CLOCK_PD);
           senddata(8'b11101011); // DATA
           #(CLOCK_PD);
           senddata(8'b11111010); // DATA
           #(CLOCK_PD)
           senddata(8'b11101011); // DATA
           #(CLOCK_PD);
           senddata(8'b11101010); // DATA
           #(CLOCK_PD);
           senddata(8'b11111011); // DATA
           #(CLOCK_PD*3);
           xsend = 1;
           #(CLOCK_PD);
           xsend = 0;
          // #(BITPD_NS*50);
           cardet = 0;
           #(BITPD_NS*110);
           end
          // 2nd Transmission
           senddata(8'b00000001); // SOURRCE
           #(CLOCK_PD);
           senddata(8'b11001001); //DEST
           #(CLOCK_PD);
           senddata(8'h30);// TYPE
           #(CLOCK_PD);
           senddata(8'b11101011); // DATA
           #(CLOCK_PD);
           senddata(8'b11101010); // DATA
           #(CLOCK_PD);
           senddata(8'b11111011); // DATA
           #(CLOCK_PD);
           senddata(8'b11101011); // DATA
           #(CLOCK_PD);
           senddata(8'b11101010); // DATA
           #(CLOCK_PD);
           xsend= 1 ;
           #(CLOCK_PD)
           xsend= 0;

           #(BITPD_NS*90);
           //senddata(8'b11001011);
           //senddata(8'b11111010);
           report_errors;
           $finish;  // suspend simulation (use $finish to exit)
           end
endmodule

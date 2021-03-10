`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/09/2021 08:49:05 PM
// Design Name:
// Module Name: manchester_sctb
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

module manchester_sctb (
    input logic clk, rdy, txen, txd,
    output logic valid, rst,
    output logic [7:0] data);

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;

    // tasks for common functions including checking

    task check( txd, exp_txd, rdy, exp_rdy, txen, exp_txen /* add expected values to test */ );
        if (txd != exp_txd) begin
            $display("%t error: expected txd=%h actual txd=%h",
            $time, exp_txd, txd);
            errcount++;
        end
        if (rdy != exp_rdy) begin
            $display("%t error: expected rdy=%h actual rdy=%h",
            $time, exp_rdy, rdy);
            errcount++;
        end
        if (txen != exp_txen) begin
            $display("%t error: expected txen=%h actual txen=%h",
            $time, exp_txen, txen);
            errcount++;
        end

        // place additional tests here
    endtask: check

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    // transaction tasks

    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        check(txd,1,rdy,1,txen,0);
    endtask: reset_duv

    task single_transmission( logic [7:0] d);
        valid = 1'b1;
        data = d;
        do begin
            @(posedge clk);
        end while (rdy == 0);
        #1 valid = 0;
        do begin
            @(posedge clk) #1;
        end while (rdy == 1);
        valid = 0;
        wait(txen == 1);
//        #(BITPD_NS/4);
        for (int i = 0; i <= 15; i++) begin
//            check(txd, ~txd, rdy, 0, txen, 1);
//            if(i % 2) $display("%t inverted d", $time);
//            else $display("%t regular d", $time);
            if(i % 2) check(txd, ~d[i/2], rdy, 0, txen, 1);
            else check(txd, d[i/2], rdy, 0, txen, 1);
            #(BITPD_NS/2);
        end
    endtask
    // place additional transaction tasks here

    initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor( /* add signals to monitor in console */ );
        reset_duv;

        // call transaction tasks here
        single_transmission(8'b01010101);
        #(BITPD_NS*2)
        check(txd,1,rdy,1,txen,0);
        report_errors;
        $finish;  // suspend simulation (use $finish to exit)
    end

endmodule
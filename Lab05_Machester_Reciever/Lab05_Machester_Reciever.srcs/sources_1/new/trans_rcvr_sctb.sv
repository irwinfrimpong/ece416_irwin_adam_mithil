`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/15/2021 03:33:34 PM
// Design Name:
// Module Name: trans_rcvr_sctb
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


module trans_rcvr_sctb(
    input logic clk, rst, cardet, error, txen,
    input logic [7:0] data_rec,
    output logic [7:0] data_trans
    );

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;
    logic [15:0] preamble, sfd, trans;
    parameter  rand_bits = 10;

    task check(data, exp_data, cardet, exp_cardet, error, exp_error, txen, exp_txen);
        if (data != exp_data) begin
            $display("%t error: expected data=%h actual data=%h",
            $time, exp_data, data);
            errcount++;
        end
        if (cardet != exp_cardet) begin
            $display("%t error: expected cardet=%h actual cardet=%h",
            $time, exp_cardet, cardet);
            errcount++;
        end
        if (error != exp_error) begin
            $display("%t error: expected error=%h actual error=%h",
            $time, exp_error, error);
            errcount++;
        end
        if (txen != exp_txen) begin
            $display("%t error: expected txen=%h actual txen=%h",
            $time, exp_txen, txen);
            errcount++;
        end
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
        //check(data_out,8'd0,oerr,0,ferr,0);
    endtask: reset_duv


    task transmit_preamble( logic [7:0] d);
        data_trans = d;


    endtask:

endmodule

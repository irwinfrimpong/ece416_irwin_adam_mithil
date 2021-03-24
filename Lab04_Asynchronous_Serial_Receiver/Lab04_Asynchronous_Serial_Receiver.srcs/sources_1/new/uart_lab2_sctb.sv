`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/22/2021 06:09:11 PM
// Design Name:
// Module Name: uart_lab2_sctb
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


module uart_lab2_sctb(
    input logic clk,ferr,oerr,
    input logic [7:0] data_out,
    output logic rst,
    output logic [7:0] data_in);


    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;
    logic [7:0] dat_trans;

    task check(data, exp_data, oerr, exp_oerr, ferr, exp_ferr);
        if (data != exp_data) begin
            $display("%t error: expected data=%h actual data=%h",
            $time, exp_data, data);
            errcount++;
        end
        if (oerr != exp_oerr) begin
            $display("%t error: expected oerr=%h actual oerr=%h",
            $time, exp_oerr, oerr);
            errcount++;
        end
        if (ferr != exp_ferr) begin
            $display("%t error: expected ferr=%h actual ferr=%h",
            $time, exp_ferr, ferr);
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
        check(data_out,8'd0,oerr,0,ferr,0);
    endtask: reset_duv

    // task single_transmission(logic [7:0] d);/* add expected values to test */
    //     data_in = d;
    //     #(BITPD_NS*10);
    //     // $display("d: %b d1: %b",d,d1);
    //     // for ( int i = 0; i <= 9; i++)
    //     // begin
    //     //     rxd = d1[i];
    //     //     rdy = 0;
    //     //
    //     //     // $display("Rxd: %d at: %t", rxd, $time);
    //     //     #(BITPD_NS);
    //     // end
    //     // rxd = 1;
    //     // rdy = 1 ;
    //     check(data_out,d,oerr,0,ferr,0);
    // endtask: single_transmission

    task transmit_bytes(int n);
        for (int i = 1; i <= n; i++)
        begin
            dat_trans[7:0] =  $urandom(n*i);
            data_in = dat_trans;
            if(i == 1) #(BITPD_NS*2);
            else
            begin
                #(BITPD_NS*8);
                check(data_out,data_in,oerr,0,ferr,0);
                #(BITPD_NS*2);
            end
        end
        #(BITPD_NS*15);

    endtask: transmit_bytes

        logic [7:0] dat;
            initial begin
            $timeformat(-9, 0, "ns", 6);
            $monitor(ferr, oerr, data_in, data_out);
            reset_duv;
            $display("Transmiting Bytes");
            transmit_bytes(2);
            #(BITPD_NS*2)

            report_errors;
            $finish;  // suspend simulation (use $finish to exit)
        end
endmodule

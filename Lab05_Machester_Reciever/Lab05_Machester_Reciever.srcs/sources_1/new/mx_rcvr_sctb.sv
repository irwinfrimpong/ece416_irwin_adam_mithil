`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/07/2021 08:07:10 PM
// Design Name:
// Module Name: mx_rcvr_sctb
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


module mx_rcvr_sctb(
    input logic clk, valid, cardet, error,
    input logic [7:0] data,
    output logic rst, rxd
    );

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;
    logic [7:0] dat_trans;
    logic [15:0] preamble, sfd , trans;
    parameter  rand_bits = 10;

    task check(data, exp_data, valid, exp_valid, caret, exp_cardet, error, exp_error);
        if (data != exp_data) begin
            $display("%t error: expected data=%h actual data=%h",
            $time, exp_data, data);
            errcount++;
        end
        if (valid != exp_valid) begin
            $display("%t error: expected valid=%h actual valid=%h",
            $time, exp_valid, valid);
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

    // Transmitting Random Bits
    task random_bits;
        logic [2*rand_bits-1:0] dat_trans;
        dat_trans =  {$random } % (4^rand_bits-1);
        for (int i = 0; i < (2*rand_bits); i++)
        begin
            rxd = dat_trans[i];
            #(BITPD_NS/2);
        end
    endtask: random_bits


    task preamble_bytes(n);
        preamble= 16'b10_01_10_01_10_01_10_01;
        for (int i = 0; i <= n; i++)
        begin
            for (int j = 15; j >=0;j--)
            begin
                rxd = preamble[j];
                #(BITPD_NS/2);
            end
        end
    endtask: preamble_bytes

    task sfd_bits;
        sfd= 16'b10_10_01_10_01_01_01_01;
        for (int i = 15; i >= 0; i--)
        begin
            rxd = sfd[i];
            #(BITPD_NS/2);
        end
    endtask: sfd_bits

    task transmit_bits;
        trans = 16'b01_10_01_10_01_01_01_10;
        for (int i = 0; i <= 15; i++)
        begin
            rxd = trans[i];
            #(BITPD_NS/2);
        end
    endtask: transmit_bits

    task transmit_eof;
        for (int i = 7; i >= 0; i--)
        begin
            rxd = 1;
            #(BITPD_NS/2);
        end
    endtask: transmit_eof

    initial begin
        $timeformat(-9, 0, "ns", 6);
        //$monitor(ferr, oerr, data_in, data_out);
        reset_duv;

        $display("Transmiting Random Bits at %t", $time);
        random_bits;
        $display("Transmitting Preamble at %t", $time);
        preamble_bytes(5);
        $display("Transmitting SFD at %t", $time);
        sfd_bits;
        $display("Transmitting data at %t", $time);
        transmit_bits;
        $display("Transmitting EOF at %t", $time);
        transmit_eof;

        #(BITPD_NS*5);
        rxd = 0;
        #(BITPD_NS*5);

        report_errors;
        $finish;
    end
endmodule
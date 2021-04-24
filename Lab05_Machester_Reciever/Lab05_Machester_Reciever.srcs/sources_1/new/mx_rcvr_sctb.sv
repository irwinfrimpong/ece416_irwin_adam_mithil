`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer:Adam Tunnell, Mithil Shah, Irwin Frimpong
//
// Create Date: 04/07/2021 08:07:10 PM
// Design Name: Manchester Reciever
// Module Name: mx_rcvr_sctb
// Project Name: Manchester Receiver Implementation
// Description: Self checking testbemch for Manchester Reciever
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
    logic [15:0] preamble, sfd, trans;
    parameter  rand_bits = 10;

    task check(data, exp_data, valid, exp_valid, cardet, exp_cardet, error, exp_error);
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

        for (int i = 0; i < 199; i++)
        begin
            rxd = {$random} % 2;
            #(BITPD_NS/2);
        end
    endtask: random_bits


    task preamble_bytes(input int n);
        preamble= 16'b10_01_10_01_10_01_10_01;
        for (int i = 0; i <= n; i++)
        begin
            for (int j = 15; j >=0;j--)
            begin
                rxd = preamble[j];
                #(BITPD_NS/2);
            end
            check(data, data, valid, 0, cardet, 1, error, 0);
        end
    endtask: preamble_bytes

    task sfd_bits;
        sfd= 16'b01_01_01_01_10_01_10_10;
        for (int i = 15; i >= 0; i--)
        begin
            rxd = sfd[i];
            #(BITPD_NS/2);
        end
        check(data, data, valid, 0, cardet, 1, error, 0);
    endtask: sfd_bits

    task transmit_bits(input logic [7:0] trans_bits);
        // trans_bits= trans;
        int no_valid = 1;
        for (int i = 0; i <= 7; i++)
        begin
            rxd = trans_bits[i];
            #(BITPD_NS/2);
            rxd = ~trans_bits[i];
            // (BITPD_NS/2);
            for(int a = 0; a < 100; a++)
            begin
                if(valid) no_valid = 0;
                #(BITPD_NS/200);
            end
        end
        for(int a = 0; a < 20; a++)
        begin
            if(valid) no_valid = 0;
            #(BITPD_NS/200);
        end
        check(data, trans, valid, valid, cardet, 1, error, 0);
        if(no_valid)
        begin
            errcount++;
            $display("%t error: no valid asserted at end of frame",
                $time);
        end
    endtask: transmit_bits

    task transmit_bytes(input int n);
        for (int i = 0; i < n; i++)
        begin
            transmit_bits(({$random } % 255));
        end

    endtask: transmit_bytes

    task transmit_errorbits;
        trans = 16'b11_11_11_01_10_10_01_10;
        for (int i = 0; i <= 15; i++)
        begin
            rxd = trans[i];
            #(BITPD_NS/2);
        end
        check(data, data, valid, 0, cardet, 0, error, 1);
    endtask: transmit_errorbits

    task transmit_eof;
        for (int i = 7; i >= 0; i--)
        begin
            rxd = 1;
            #(BITPD_NS/2);
        end
        check(data, data, valid, 0, cardet, 0, error, 0);
    endtask: transmit_eof

    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;

        // //Test 10a
        rxd = 1;
        #(BITPD_NS*5);
        $display("Transmitting Preamble at %t", $time);
        preamble_bytes(2);
        $display("Transmitting SFD at %t", $time);
        sfd_bits;
        $display("Transmitting data at %t", $time);
        transmit_bits(8'b10100110);
        $display("Transmitting EOF at %t", $time);
        transmit_eof;
        #(BITPD_NS*5);

        //Test 10b
        rxd = 1;
        #(BITPD_NS*5);
        $display("Transmitting Preamble at %t", $time);
        preamble_bytes(2);
        $display("Transmitting SFD at %t", $time);
        sfd_bits;
        $display("Transmitting data at %t", $time);
        transmit_bytes(24);
        $display("Transmitting EOF at %t", $time);
        transmit_eof;
        #(BITPD_NS*5);

        //Test 10c
        $display("Transmitting random values at %t", $time);
        random_bits;
        $display("Transmitting Preamble at %t", $time);
        preamble_bytes(2);
        $display("Transmitting SFD at %t", $time);
        sfd_bits;
        $display("Transmitting data at %t", $time);
        transmit_bytes(1);
        $display("Transmitting EOF at %t", $time);
        transmit_eof;
        $display("Transmitting random values at %t", $time);
        random_bits;
        #(BITPD_NS*5);

        // Test 10d
        $display("Transmitting Preamble at %t", $time);
        preamble_bytes(2);
        $display("Transmitting SFD at %t", $time);
        sfd_bits;
        $display("Transmitting ERROR data at %t", $time);
        transmit_errorbits;


        // Test 10e
        $display("Transmitting Preamble at %t", $time);
        preamble_bytes(2);
        $display("Transmitting SFD at %t", $time);
        sfd_bits;
        $display("Transmitting data at %t", $time);
        transmit_bytes(1);
        #(BITPD_NS*5);
        check(data,data,valid,0,cardet,0,error,1);

        report_errors;
        $finish;
    end
endmodule

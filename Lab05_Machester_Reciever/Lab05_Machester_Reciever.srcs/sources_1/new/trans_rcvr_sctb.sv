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
    input logic clk, cardet, error, txen,
    input logic [7:0] data_rec,
    output logic [7:0] data_trans,
    output logic [5:0] length,
    output logic rst, send,btnd
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


    task transmit_preamble;
        data_trans = 8'b10101010;
        #(BITPD_NS*7);
        //valid = 1;
        #(BITPD_NS);
        //valid = 0;
    endtask:transmit_preamble

    task transmit_preamble_bytes(input int n);
        for (int i=0; i<n; i++)
        begin
            transmit_preamble;
        end
    endtask: transmit_preamble_bytes

    task transmit_sfd;
        data_trans = 8'b11010000;
        #(BITPD_NS*7);
        //valid = 1;
        #(BITPD_NS);
        //valid = 0;
    endtask: transmit_sfd

    task transmit_first_bit(input logic [7:0] trans_bits);
        data_trans= trans_bits;
        #(BITPD_NS*7);
        //valid = 1;
        #(BITPD_NS);
        //valid = 0;
    endtask: transmit_first_bit

    task transmit_bits(input logic [7:0] trans_bits);
        data_trans= trans_bits;
        #(BITPD_NS*8);
    endtask: transmit_bits


    task transmit_bytes(input int n);
        transmit_first_bit(({$random } % 255));
        for (int i = 1; i < n; i++)
        begin
            transmit_bits(({$random } % 255));
        end

    endtask: transmit_bytes


    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        // data_trans = 8'b10100111;
        //valid = 1;
        //#(CLOCK_PD*2);
        //valid = 0;
        //#(BITPD_NS * 7);
        //valid = 1;
        //#(BITPD_NS);
        //valid = 0;

//MIN LENGTH TEST
        //$display("Transmitting Preamble at %t", $time);
        //transmit_preamble_bytes(1);
        //$display("Transmitting SFD at %t", $time);
        //transmit_sfd;
        // #(BITPD_NS*10);
        $display("Transmitting DATA at %t", $time);
        send = 1 ;
        btnd = 0;
        length= 'd32;
        #(CLOCK_PD)
        send = 0;
        $display("Transmitting EOF at %t", $time);
        // #(BITPD_NS*10);
        while(data_rec != "u") #(CLOCK_PD);
        #(BITPD_NS)
        btnd = 1;
        #(BITPD_NS*15)
//MAX LENGTH TEST
        // $display("Transmitting Preamble at %t", $time);
        // transmit_preamble_bytes(1);
        // $display("Transmitting SFD at %t", $time);
        // transmit_sfd;
        // $display("Transmitting DATA at %t", $time);
        // transmit_bytes(256);
        //$display("Transmitting EOF at %t", $time);
        //=transmit_eof;

//10 RANDOM BYTES TEST
        // $display("Transmitting Preamble at %t", $time);
        // transmit_preamble_bytes(1);
        // $display("Transmitting SFD at %t", $time);
        // transmit_sfd;
        // $display("Transmitting DATA at %t", $time);
        //for(int i = 0; i < 9; i++)
            //begin
                // transmit_bytes({$random } % 2^256-1);
            //end
        //$display("Transmitting EOF at %t", $time);
        //=transmit_eof;


        report_errors;
        $finish;
    end
endmodule

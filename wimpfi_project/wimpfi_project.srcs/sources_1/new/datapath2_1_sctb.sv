`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/16/2021 10:45:05 PM
// Design Name:
// Module Name: datapath2_1_sctb
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


module datapath2_1_sctb(
    input logic clk,
    output logic rst, valid,
    output logic [7:0] data_trans
    );


    logic [7:0] data_trans; // 1% error 4/22
    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 50_000;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    //int errcount = 0;
    logic [15:0] preamble, sfd, trans;
    parameter  rand_bits = 10;
    byte unsigned message[20] = {"L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i"};

    //transaction tasks
    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        valid = 0;
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
        // valid = 1;
        #(BITPD_NS);
        // valid = 0;
    endtask: transmit_sfd

    task transmit_first_byte(input logic [7:0] trans_bits);
        data_trans= trans_bits;
        #(BITPD_NS*7);
        // valid = 1;
        #(BITPD_NS);
        // valid = 0;
    endtask: transmit_first_byte

    task transmit_bits(input logic [7:0] trans_bits);
        data_trans= trans_bits;
        #(BITPD_NS*8);
    endtask: transmit_bits


    task transmit_bytes(input int n);
        transmit_first_byte("$");
        transmit_bits("N");
        transmit_bits("0");
        for (int i = 0; i < n; i++)
        begin
            transmit_bits(message[i]);
        end

    endtask: transmit_bytes


    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        valid = 1;
        transmit_preamble;
        transmit_sfd;
        transmit_bytes(20);
        valid = 0;
        #(BITPD_NS*1050);


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
        // $display("Transmitting DATA at %t", $time);
        // send = 1 ;
        // //btnd = 0;
        // length= 'd32;
        // #(CLOCK_PD)
        // send = 0;
        //$display("Transmitting EOF at %t", $time);
        // #(BITPD_NS*10);
        // while(data_rec != "E") #(CLOCK_PD);
        // #(BITPD_NS*30);
//MAX LENGTH TEST
        // $display("Transmitting Preamble at %t", $time);
        // transmit_preamble_bytes(1);
        // $display("Transmitting SFD at %t", $time);
        // transmit_sfd;
        // $display("Transmitting DATA at %t", $time);
        // transmit_bytes(256);
        // $display("Transmitting EOF at %t", $time);
        // transmit_eof;

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


        $finish;
    end
endmodule

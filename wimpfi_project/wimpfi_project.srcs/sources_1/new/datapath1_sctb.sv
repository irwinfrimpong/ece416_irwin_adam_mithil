`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 05/17/2021 06:37:12 PM
// Module Name: datapath1_sctb
// Project Name: WimpFi Project
// Description: Self-Checking Testbench for testing transmissions of serially
// received data. Tests transmissions as well as random backoff.
//
// Dependencies: None
/////////////////////////////////////////////////////////////////////////////////////

// Testbench to Test Transmitting Message

module datapath1_sctb(
    input logic clk,txd,txen,rdy,xsend,
    input logic [7:0] data,
    output logic rst, rxd, cardet
    );

   parameter CLOCK_PD = 10;  // clock period in nanoseconds
   parameter BAUD_RATE = 9600;
   parameter RATE_HZ = 50_000;
   localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
   localparam BITTRANS_NS = 1_000_000_000/ RATE_HZ ;
   int errcount = 0;
   logic [7:0] dat_trans;
   parameter MESSAGE_LEN = 24;
   byte unsigned message[MESSAGE_LEN] = {"*","$","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i", 8'h04};
   byte unsigned data_uart[26]= {8'b10101010,8'b11010000,"*","$","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i", 8'h04};

     task check(txd,exp_txd);
         if (txd != exp_txd) begin
             $display("%t error: expected txd=%h actual txd=%h",
             $time, exp_txd, txd);
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
   endtask: reset_duv

   task single_transmission(logic [7:0] d);/* add expected values to test */
       logic [9:0] d1;
        d1 = {1'b1, d, 1'b0};
        for ( int i = 0; i <= 9; i++)
        begin
            rxd = d1[i];
            #(BITPD_NS);
        end
        rxd = 1;
        #(CLOCK_PD);
    endtask: single_transmission

    task sendmessage;
        cardet = 0;
        for(int i = 0; i < MESSAGE_LEN; i++)
        begin
            single_transmission(message[i]);
        end
            do begin
                @(posedge clk);
            end while(rdy == 1);
            $display("Check Defference");
             check(txd,1);
            #(BITTRANS_NS/4);
        for(int j = 0; j < 26 ; j++)
        begin
        dat_trans = data_uart[j];
            for (int l=0;l<8;l++)
            begin
                #(BITTRANS_NS/2);
                check(txd, ~dat_trans[l]);
                #(BITTRANS_NS/2);
            end
        end
    endtask: sendmessage

    task sendmessage_withrandombackoff;
        cardet = 1;
        for(int i = 0; i < MESSAGE_LEN; i++)
        begin
            single_transmission(message[i]);
        end
        do begin
            @(posedge clk);
        end while(xsend==0);
        #(BITTRANS_NS*80) cardet = 0;

        do begin
            @(posedge clk);
        end while(rdy == 1);
        $display("Check Random Backoff Check");

         check(txd,1);
        #(BITTRANS_NS/4);
        for(int j = 0; j < 26 ; j++)
        begin
        dat_trans = data_uart[j];
        for (int l=0;l<8;l++)
        begin
            #(BITTRANS_NS/2);
            check(txd, ~dat_trans[l]);
            #(BITTRANS_NS/2);
        end
        end
    endtask: sendmessage_withrandombackoff



    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;

        $display("Sending Message %t", $time);
        sendmessage;
        $display("Sending Message W/ Random Backoff %t", $time);
        sendmessage_withrandombackoff;

        report_errors;
        $finish;
    end



endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 05/16/2021 04:05:10 PM
// Module Name: datapath2_sctb
// Project Name: WimpFi Project
// Description: Self-Checking Testbench for the WimpFi Receiver. Sends manchester
// coded data to the Receiver module and tests for accurate receival of type 0
// transmissions with the broadcast address, matching MAC address, and wrong
// destination address
//
// Dependencies: manchester_xmit
//
//////////////////////////////////////////////////////////////////////////////////


module datapath2_sctb(
    input logic clk, a_txd,
    output logic rst, rxd
    );

    logic [7:0] data;
    logic valid, rdy, txen,txd;

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 50_000;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    parameter UART_RATE = 9600;
    localparam UART_BITPD_NS = 1_000_000_000/ UART_RATE;
    int errcount = 0;
    parameter MESSAGE_LEN = 24;
    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) MANCHESTER_TRANSMITTER(.clk(clk), .rst(rst), .valid(valid), .data(data),.rdy(rdy), .txen(txen),.txd(rxd));
    logic  [7:0] preamble,sfd;
    assign preamble =  8'b10101010;
    assign sfd = 8'b11010000;

    task check(a_txd, exp_a_txd);
       if (a_txd != exp_a_txd) begin
           $display("%t error: expected a_txd=%h actual a_txd=%h",
           $time, exp_a_txd, a_txd);
           errcount++;
       end
    endtask: check

      task reset_duv;
          rst = 1;
          @(posedge clk) #1;
          rst = 0;
      endtask: reset_duv

      task report_errors;
          if (errcount == 0) $display("Testbench PASSED");
          else $display("Testbench FAILED with %d errors", errcount);
      endtask: report_errors

      task send_preamble;
          valid = 1'b1;
          data = preamble;
          do begin
              @(posedge clk);
          end while (rdy == 0);
          #1 valid = 0;
          do begin
              @(posedge clk);
          end while (rdy == 1);
      endtask

      task send_sfd;
          valid = 1'b1;
          data = sfd;
          do begin
              @(posedge clk);
          end while (rdy == 0);
          #1 valid = 0;
          do begin
              @(posedge clk);
          end while (rdy == 1);
      endtask

      task broadcast_transmission;
          byte unsigned message[MESSAGE_LEN] = {"*","N","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i", 8'h04};
          send_preamble;
          send_sfd;
          for(int j = 0; j < MESSAGE_LEN; j++)
          begin
              valid = 1'b1;
              data = message[j];
              do begin
                  @(posedge clk);
              end while (rdy == 0);
              #1 valid = 0;
              do begin
                  @(posedge clk);
              end while (rdy == 1);
          end
          do begin
              @(posedge clk);
          end while (rdy == 0);
          #(UART_BITPD_NS/2);
          for (int a = 0; a < MESSAGE_LEN; a++)
          begin
              check(a_txd,0);
              #(UART_BITPD_NS);
              for (int i = 0; i < 8; i++)
              begin
                  check(a_txd, message[a][i]);
                  #(UART_BITPD_NS);

              end
              check(a_txd, 1);
              #(UART_BITPD_NS);
          end
      endtask: broadcast_transmission

      task right_dest_transmission;
          byte unsigned message[MESSAGE_LEN] = {"$","N","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i", 8'h04};
          send_preamble;
          send_sfd;
          for(int j = 0; j < MESSAGE_LEN; j++)
          begin
              valid = 1'b1;
              data = message[j];
              do begin
                  @(posedge clk);
              end while (rdy == 0);
              #1 valid = 0;
              do begin
                  @(posedge clk);
              end while (rdy == 1);
          end
          do begin
              @(posedge clk);
          end while (rdy == 0);
          #(UART_BITPD_NS/2);
          for (int a = 0; a < MESSAGE_LEN; a++)
          begin
              check(a_txd,0);
              #(UART_BITPD_NS);
              for (int i = 0; i < 8; i++)
              begin
                  check(a_txd, message[a][i]);
                  #(UART_BITPD_NS);

              end
              check(a_txd, 1);
              #(UART_BITPD_NS);
          end
      endtask: right_dest_transmission

      task wrong_dest_transmission;
          byte unsigned message[MESSAGE_LEN] = {"A","N","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i", 8'h04};
          send_preamble;
          send_sfd;
          for(int j = 0; j < MESSAGE_LEN; j++)
          begin
              valid = 1'b1;
              data = message[j];
              do begin
                  @(posedge clk);
              end while (rdy == 0);
              #1 valid = 0;
              do begin
                  @(posedge clk);
              end while (rdy == 1);
          end
          do begin
              @(posedge clk);
          end while (rdy == 0);
          #(UART_BITPD_NS/2);
          for (int a = 0; a < MESSAGE_LEN; a++)
          begin
              check(a_txd, 1);
              #(UART_BITPD_NS);
              for (int i = 0; i < 8; i++)
              begin
                  check(a_txd, 1);
                  #(UART_BITPD_NS);

              end
              check(a_txd, 1);
              #(UART_BITPD_NS);
          end
      endtask: wrong_dest_transmission

      initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        $display("Testing Broadcast Transmission at %t", $time);
        broadcast_transmission;
        $display("Testing Correct Address Transmission at %t", $time);
        right_dest_transmission;
        $display("Testing Incorrect Address Transmission at %t", $time);
        wrong_dest_transmission;
        report_errors;
        $finish;
    end


endmodule

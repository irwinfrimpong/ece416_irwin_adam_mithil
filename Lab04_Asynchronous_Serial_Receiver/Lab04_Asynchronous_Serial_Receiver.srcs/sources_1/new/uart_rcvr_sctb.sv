`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/20/2021 03:53:43 PM
// Design Name:
// Module Name: uart_rcvr_sctb
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


module uart_rcvr_sctb(
    input logic clk, valid, ferr, oerr,
    input logic [7:0] data,
    output logic rxd, rst, rdy
    );

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;
    logic [9:0] d1;

    task check( data, exp_data, oerr, exp_oerr, ferr, exp_ferr, valid, exp_valid);
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
      if (valid != exp_valid) begin
          $display("%t error: expected valid=%h actual valid=%h",
          $time, exp_valid, valid);
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
        rdy = 1;
        @(posedge clk) #1;
        rst = 0;
        check(data,8'd0,oerr,0,ferr,0,valid,0);
    endtask: reset_duv

    task single_transmission(logic [7:0] d);/* add expected values to test */
      d1 = {1'b1, d, 1'b0};
      $display("d: %b d1: %b",d,d1);
      for ( int i = 0; i <= 9; i++)
      begin
          rxd = d1[i];
          rdy = 0;

          $display("Rxd: %d at: %t", rxd, $time);
         #(BITPD_NS);
      end
      rxd = 1;
      rdy = 1 ;
      check(data,d,oerr,0,ferr,0,valid,1);
    endtask: single_transmission

    task ferr_test(logic [7:0] d);/* add expected values to test */
      d1 = {1'b0, d, 1'b0};
      $display("d: %b d1: %b",d,d1);
      for ( int i = 0; i <= 9; i++)
      begin
          rxd = d1[i];
          rdy = 0;

          $display("Rxd: %d at: %t", rxd, $time);
         #(BITPD_NS);
      end
      rxd = 1;
      rdy = 1 ;
      check(data,d,oerr,0,ferr,1,valid,0);
  endtask: ferr_test


    // Self checking

    initial begin
           $timeformat(-9, 0, "ns", 6);
           $monitor( /* add signals to monitor in console */ );
           reset_duv;

           $display("Single Transmission");
           single_transmission(8'b10110000);
           #(BITPD_NS*2)

           $display("Ferr Error");
           ferr_test(8'b10110000);
           #(BITPD_NS*2)
           report_errors;
           $finish;  // suspend simulation (use $finish to exit)
       end




endmodule

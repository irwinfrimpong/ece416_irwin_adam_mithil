`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Mithil Shah, Adam Tunnell, Irwin Frimpong
//
// Create Date: 03/20/2021 03:53:43 PM
// Design Name: UART Receiver
// Module Name: uart_rcvr_sctb
// Project Name: UART Receiver
// Description: Self-checking testbench for uart receiver
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
    logic [9:0] d2;
    logic oerr_store;

    task check( data, exp_data, oerr, exp_oerr, ferr, exp_ferr, valid, exp_valid);
        if (data != exp_data) begin
            $display("%t error: expected data=%b actual data=%b",
            $time, exp_data, data);
            errcount++;
        end
        if (oerr != exp_oerr) begin
            $display("%t error: expected oerr=%b actual oerr=%b",
            $time, exp_oerr, oerr);
            errcount++;
        end
        if (ferr != exp_ferr) begin
            $display("%t error: expected ferr=%b actual ferr=%b",
            $time, exp_ferr, ferr);
            errcount++;
        end
        if (valid != exp_valid) begin
            $display("%t error: expected valid=%b actual valid=%b",
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

            #(BITPD_NS);
        end
        rxd = 1;
        rdy = 1 ;
        check(data,d,oerr,0,ferr,0,valid,1);
    endtask: single_transmission

    task ferr_test(logic [7:0] d);
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

    task oerr_test(logic [7:0] d,d3);/* add expected values to test */

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
        rdy = 0 ;

        d2 = {1'b1, d3, 1'b0};
        $display("d3: %b d2: %b",d3,d2);
        for ( int j = 0; j <= 9; j++)
        begin
            rxd = d2[j];
            rdy = 0;

            $display("Rxd: %d at: %t", rxd, $time);
            if(j != 9 ) #(BITPD_NS);
        end
        rxd = 1;
        rdy = 1 ;
        oerr_store = oerr;
        #(BITPD_NS/2);
         $display("data: %b d3: %b",data,d3);
        check(data,d3,oerr_store,1,ferr,0,valid,0);


    endtask: oerr_test

    // Self checking

    initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor( /* add signals to monitor in console */ );
        reset_duv;

        $display("Single Transmission 1");
        single_transmission(8'b01010101);
        #(BITPD_NS)

        $display("Single Transmission 2");
        single_transmission(8'b00110011);
        #(BITPD_NS)

        $display("Single Transmission 3");
        single_transmission(8'b00001111);
        #(BITPD_NS)

        $display("Ferr Error");
        ferr_test(8'b10110000);
        #(BITPD_NS*2)

        $display("Oerr Error");
        oerr_test(8'b10110000,8'b01010101);
         #(BITPD_NS/2)
         single_transmission(8'b00001111);

        report_errors;
        $finish;  // suspend simulation (use $finish to exit)
    end




endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/17/2021 06:37:12 PM
// Design Name:
// Module Name: datapath1_sctb
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


module datapath1_sctb(
    input logic clk,
    output logic rst, rxd
    );

   parameter CLOCK_PD = 10;  // clock period in nanoseconds
   parameter BAUD_RATE = 9600;
   localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
   int errcount = 0;
   logic [7:0] dat_trans;
   parameter MESSAGE_LEN = 24;
   byte unsigned message[MESSAGE_LEN] = {"*","$","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i", 8'h04};

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
            //rdy = 0;

            #(BITPD_NS);
        end
        rxd = 1;
        //rdy = 1 ;
        #(CLOCK_PD);
    endtask: single_transmission


    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;

        for(int i = 0; i < MESSAGE_LEN; i++)
        begin
            $display("Sending byte %i",i);
            single_transmission(message[i]);
        end
        #(BITPD_NS *800)
        $finish;
    end



endmodule

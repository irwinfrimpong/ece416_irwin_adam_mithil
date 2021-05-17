`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/16/2021 04:05:10 PM
// Design Name:
// Module Name: datapath2_sctb
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


module datapath2_sctb(
    input logic clk,
    output logic rst, rxd
    );

    logic [7:0] data;
    logic valid, rdy, txen,txd;

    parameter CLOCK_PD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 50_000;
    localparam BITPD_NS= 1_000_000_000/ BAUD_RATE; // bit period in ns
    int errcount = 0;

    manchester_xmit #(.BAUD_RATE(BAUD_RATE)) MANCHESTER_TRANSMITTER(.clk(clk), .rst(rst), .valid(valid), .data(data),.rdy(rdy), .txen(txen),.txd(rxd));

      task reset_duv;
          rst = 1;
          @(posedge clk) #1;
          rst = 0;
          // check(txd,1,rdy,1,txen,0);
      endtask: reset_duv

      task single_transmission( logic [7:0] d);
          valid = 1'b1;
          data = d;
          do begin
              @(posedge clk);
          end while (rdy == 0);
          #1 valid = 0;
          do begin
              @(posedge clk) #1;
          end while (rdy == 1);
          valid = 0;
          wait(txen == 1);
          for (int i = 0; i <= 15; i++) begin
              // $display("Checking i:%d at t:%t",i,$time);
              // if(i % 2) check(txd, ~d[i/2], rdy, 0, txen, 1);
              // else check(txd, d[i/2], rdy, 0, txen, 1);
              #(BITPD_NS/2);
          end
      endtask: single_transmission

      task multi_transmission( logic [7:0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25);
      valid = 1'b1;
      data = d1;
      do begin
          @(posedge clk);
      end while (rdy == 0);
      #1 valid = 0;
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      valid = 0;
      wait(txen == 1);
      $display("1st Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d1[i/2], rdy, 0, txen, 1);
          // else check(txd, d1[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d2;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("2nd Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d2[i/2], rdy, 0, txen, 1);
          // else check(txd, d2[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d3;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("3rd Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d3[i/2], rdy, 0, txen, 1);
          // else check(txd, d3[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d4;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("4th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d5;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("5th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d6;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("6th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d7;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("7th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d8;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("8th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d9;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("9th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d10;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("10 Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d11;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("11th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d12;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("12th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d13;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("13th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d14;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("14th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d15;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("15th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d16;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("16th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d17;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("17th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d18;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("18th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d19;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("19th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d20;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("20th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d21;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("21st Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d22;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("22nd Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d23;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("23rd Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d24;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("24th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
          else
          begin
              data= d25;
              #1 valid = 1'b1;
          end
      end
      do begin
          @(posedge clk) #1;
      end while (rdy == 1);
      #1 valid = 0;
      $display("25th Transmission");
      for (int i = 0; i <= 16; i++) begin
          // if(i % 2) check(txd, ~d4[i/2], rdy, 0, txen, 1);
          // else check(txd, d4[i/2], rdy, 0, txen, 1);
          if(i !=15) #(BITPD_NS/2);
      end

  endtask


      initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor( /* add signals to monitor in console */ );
        reset_duv;

        // $display("Single Transmission");
        // single_transmission(8'b01010101);
        // #(BITPD_NS*2)
        // check(txd,1,rdy,1,txen,0);

         $display("Multi Transmission");
         multi_transmission(8'b01010101,8'b11010000,"$","N","0","L","a","f","a","y","e","t","t","e"," ","E","C","E"," ","W","i","m","p","F","i");
         #(BITPD_NS*2000)
        // check(txd,1,rdy,1,txen,0);

        $finish;  // suspend simulation (use $finish to exit)
    end


endmodule

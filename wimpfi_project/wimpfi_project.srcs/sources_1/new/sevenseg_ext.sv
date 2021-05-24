`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Irwin Frimpong , Adam Tunnell, Mithil Shah
//
// Create Date: 02/11/2021 01:53:18 PM
// Design Name: 7-Segment LED Controller
// Module Name: sevenseg_ext
// Project Name: 7-Segment LED Controller
// Target Devices:
// Tool Versions:
// Description: Extended Seven-segment decoder module with active high d input and acitve low segs_n and dp_n output

//////////////////////////////////////////////////////////////////////////////////


module sevenseg_ext(
    input logic [6:0]data,
    output logic [6:0] segs_n,  // ordered g(6) - a(0)
    output logic dp_n // decimal point
    );

    always_comb
    begin
        // Decimal Point for when dp is asserted
        dp_n = data[5];
        //blanks when data[6] is asserted
        if(data[6])
            begin
                segs_n = 7'b1111111;
                dp_n = 1'b1;
            end
        //display dash/minus sign
        else if(data[4])
        segs_n = 7'b0111111;
        else
        begin
            //converts 4-digit binary to 1-digit hex
            case (data[3:0])     //  gfedcba
                4'd0: segs_n = 7'b1000000;
                4'd1: segs_n = 7'b1111001;
                4'd2: segs_n = 7'b0100100;
                4'd3: segs_n = 7'b0110000;
                4'd4: segs_n = 7'b0011001;
                4'd5: segs_n = 7'b0010010;
                4'd6: segs_n = 7'b0000010;
                4'd7: segs_n = 7'b1111000;
                4'd8: segs_n = 7'b0000000;
                4'd9: segs_n = 7'b0010000;
                4'd10: segs_n = 7'b0001000;
                4'd11: segs_n = 7'b0000011;
                4'd12: segs_n = 7'b1000110;
                4'd13: segs_n = 7'b0100001;
                4'd14: segs_n = 7'b0000110;
                4'd15: segs_n = 7'b0001110;
                default: segs_n = 7'b1111111;
            endcase
        end
    end

endmodule

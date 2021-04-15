//-----------------------------------------------------------------------------
// Module Name   : sh_reg
// Project       : Manchester Transmitter
//-----------------------------------------------------------------------------
// Author        : Adam Tunnell, Irwin Frimpong, Mithil Shah
// Created       : 3/04/2020
//-----------------------------------------------------------------------------
// Description   : Shift register with parallel load parameterized by bitwidth
//                 built to be used with a manchester transmitter
//-----------------------------------------------------------------------------

module shreg_trans (
    input logic clk, sh_ld, sh_idle, sh_en, rst, br_en,
    input logic [7:0] data,
    output logic txd);

    logic [7:0] d;

    always_ff @(posedge clk)
    begin
        if(rst)
        begin
            txd <= 1'b1;
            d <= 8'd0;
        end
        else if(sh_en && br_en)
        begin
            d <= d >> 1;
            txd <= d[1];
        end
        else if(sh_ld)
        begin
            d <= data;
            txd <= data[0];
        end
        else if(sh_idle)
        begin
            txd <= 1'b1;
            d <= d;
        end
        else
        begin
            txd <= txd;
            d <= d;
        end
    end

endmodule: shreg_trans
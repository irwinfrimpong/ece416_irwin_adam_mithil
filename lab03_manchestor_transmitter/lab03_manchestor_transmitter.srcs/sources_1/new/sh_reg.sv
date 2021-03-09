//-----------------------------------------------------------------------------
// Module Name   : sh_reg
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Shift register with parallel load parameterized by bitwidth
//-----------------------------------------------------------------------------

module sh_reg (
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

endmodule: sh_reg

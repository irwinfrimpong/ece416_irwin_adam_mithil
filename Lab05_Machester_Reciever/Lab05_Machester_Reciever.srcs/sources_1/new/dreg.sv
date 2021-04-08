//-----------------------------------------------------------------------------
// Module Name   : dregr
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d register
//-----------------------------------------------------------------------------

module dreg (input logic clk,rst, clr, enb,
             output logic q);

    always_ff @(posedge clk) begin
        if (rst || clr) q <= 0;
        else if (enb) q <= 1'b1;
        else q <= q;
    end

endmodule

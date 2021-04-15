//-----------------------------------------------------------------------------
// Module Name   : dregr
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d register
//-----------------------------------------------------------------------------

module dreg_trans #(parameter W=4)
            (input logic clk, rst, enb,
             input logic [W-1:0] 	d,
             output logic [W-1:0] q);

    always_ff @(posedge clk)
        if(rst) q <= '0;
        else if(enb) q <= d;
        else q <= q;
endmodule: dreg_trans

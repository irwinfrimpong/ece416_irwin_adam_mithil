//-----------------------------------------------------------------------------
// Module Name   : counter
// Project       : Manchester Transmitter
//-----------------------------------------------------------------------------
// Author        : Adam Tunnell, Mithil Shah, Irwin Frimpong
// Created       : 03/04/2021
//-----------------------------------------------------------------------------
// Description   : Counter with enable, clr, reset, that outputs ct_max when it
// reaches its max value
//-----------------------------------------------------------------------------

module  counter #(parameter MAX_VAL = 2) (
    input logic ct_clr, clk, rst, ct_en,br_en,
    output logic ct_max
    );
    localparam W = $clog2(MAX_VAL);
    logic[W-1:0] Q ;  // Variable used for countiing

    always_ff @(posedge clk)
    begin
        if (ct_clr || rst)
        begin
            ct_max <= 1'b0;
            Q <= 4'b0;
        end
        else if (ct_en && br_en)
        begin
            Q <= Q + 1;
            ct_max <= (Q == MAX_VAL - 1);
        end
        else Q <= Q ;

    end
endmodule

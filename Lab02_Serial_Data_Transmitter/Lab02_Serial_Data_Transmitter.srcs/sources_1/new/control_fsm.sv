`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/25/2021 01:15:26 PM
// Design Name:
// Module Name: control_fsm
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


module control_fsm(
    input logic valid, clk, ct_eq9, rst,
    output logic rdy,sh_ld, sh_idle, sh_en, br_st, ct_clr, ct_en);

    typedef enum logic{
    IDLE = 1'b0,
    SHIFT = 1'b1
    } state_t ;

    state_t state, next;

    always_ff @(posedge clk)
    begin
        if(rst) state <= IDLE;
        else state <= next;
    end

    always_comb
    begin
        case(state)
            IDLE:
            begin
                rdy = 1'b1;
                sh_idle = 1'b1;
                ct_en = 1'b0;
                sh_en = 1'b0;
                sh_ld = 1'b0;

                if(valid)
                begin
                    next = SHIFT;
                    sh_ld = 1'b1;
                    sh_idle = 1'b0;
                    rdy = 1'b0;
                    ct_clr = 1'b1;
                end
                else next = IDLE;
            end

            SHIFT:
            begin
                // ct_en = 1'b1;
                // sh_en = 1'b1;
                sh_ld = 1'b0;
                ct_clr = 1'b0;

                if(ct_eq9) next= IDLE;
                else
                begin
                    next = SHIFT;
                    ct_en = 1'b1;
                    sh_en = 1'b1;
                end


            end
            default:
            next= IDLE ;

        endcase

    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 05/13/2021 11:47:53 AM
// Module Name: controller_uart_trans
// Project Name: Serial Transmitter
// Description: State machine for UART Transmitter
// Dependencies: None
//////////////////////////////////////////////////////////////////////////////////


module controller_uart_trans(
    input logic valid, clk, ct_eq9, rst, br_en,
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
        ct_clr = 1'b0;
        ct_en = 1'b0 ;
        sh_ld = 1'b0 ;
        sh_idle= 1'b0 ;
        rdy= 1'b1;
        br_st= 1'b0 ;
        sh_en= 1'b0 ;
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
                    ct_clr = 1'b1;
                    br_st = 1'b1 ;
                end
                else
                begin
                    next = IDLE;
                end
            end

            SHIFT:
            begin
                ct_en = 1'b1;
                sh_en = 1'b1;
                sh_ld = 1'b0;
                ct_clr = 1'b0;
                br_st = 1'b0;
                rdy = 1'b0;
                if(ct_eq9 && br_en)
                begin
                    next= IDLE;
                    sh_en= 1'b0;
                    ct_clr = 1'b1;
                end
                else
                begin
                    next = SHIFT;
                end


            end
            default:
            next= IDLE ;

        endcase

    end
endmodule

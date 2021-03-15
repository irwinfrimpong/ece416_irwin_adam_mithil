`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Irwin Frimpong, Adam Tunnell , Mithil Shah
//
// Create Date: 03/04/2021 01:04:32 PM
// Design Name: Manchester Transmiter
// Module Name: control_fsm
// Project Name: Manchester Transmitter
// Target Devices:
// Tool Versions:
// Description: Finite State Machine for Manchester Transmiter
//////////////////////////////////////////////////////////////////////////////////


module control_fsm(
    input logic valid, clk, ct_eq15, rst, br_en,enb_2x, idle_biteq,
    output logic rdy,sh_ld, sh_idle, sh_en, br_st, ct_clr, ct_en, br_2st, idle_clr, idle_en, txen,txd_idle_en,sq_clr);

    typedef enum logic [1:0]{
    IDLE = 2'b00,
    SHIFT = 2'b01,
    IDLEBITS = 2'b10
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
        idle_clr = 1'b0;
        ct_en = 1'b0 ;
        sh_ld = 1'b0 ;
        sh_idle= 1'b0 ;
        rdy= 1'b1;
        br_st= 1'b0 ;
        br_2st = 1'b0;
        sh_en= 1'b0 ;
        txen = 1'b0;
        idle_en = 1'b0;
        sq_clr= 1'b0;
        case(state)
            IDLE:
            begin
                rdy = 1'b1;
                sh_idle = 1'b1;
                ct_en = 1'b0;
                sh_en = 1'b0;
                sh_ld = 1'b0;
                txen = 1'b0;
                idle_en = 1'b0;
                txd_idle_en = 1'b1;
                if(valid)
                begin
                    next = SHIFT;
                    sq_clr= 1'b1;
                    sh_ld = 1'b1;
                    sh_idle = 1'b0;
                    ct_clr = 1'b1;
                    br_st = 1'b1 ;
                    br_2st= 1'b1 ;
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
                br_2st= 1'b0;
                rdy = 1'b0;
                txen = 1'b1;
                txd_idle_en = 1'b0;
                if(ct_eq15 && enb_2x)
                begin
                    next= IDLEBITS;
                    txd_idle_en = 1'b1;
                    rdy= 1'b1; // Ready should be 1 one clock cycle before
                    sh_en= 1'b0;
                    ct_clr = 1'b1;
                    idle_clr = 1'b1;
                end
                else if (ct_eq15 && valid )
                begin
                    next = SHIFT;
                    rdy= 1'b1; // Ready should be 1 one clock cycle before
                    sh_ld = 1'b1;
                    sh_idle = 1'b0;
                    ct_clr = 1'b1;
                    sq_clr= 1'b1;
                end
                else next = SHIFT;

            end

            IDLEBITS:
            begin
                txen = 1'b1;
                idle_clr = 1'b0;
                idle_en = 1'b1;
                rdy = 1'b0;
                txd_idle_en = 1'b1;
                if(idle_biteq) next = IDLE;
                else next = IDLEBITS;
            end

            default:
            next= IDLE ;

        endcase

    end
endmodule

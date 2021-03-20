`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/15/2021 10:40:42 AM
// Design Name:
// Module Name: controller
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


module controller(
    input logic clk,rst,rdy,rxd,br_en,ct_initeq, br_2en, ct_eq,valid,
    output logic set_oerr, clr_oerr, set_ferr, clr_ferr, br_st, ct_initclr, ct_initenb, br_2st, sh_en, sh_ld,sh_rst, ct_clr, ct_en, clr_valid, set_valid
    );

    typedef enum logic [2:0] {
        START = 3'd0,
        IDLE = 3'd1,
        CHECKSTART = 3'd2,
        LOAD = 3'd3,
        STOPBIT = 3'd4
    } states_t;

    states_t state, next;

    always_ff @(posedge clk)
        if (rst) state <= START;
        else     state <= next;

    always_comb
    begin
        br_st= 1'b0;
        br_2st= 1'b0;
        ct_initclr= 1'b0;
        ct_initenb= 1'b0;
        ct_en= 1'b0;
        ct_clr= 1'b0;
        sh_en= 1'b0;
        sh_ld= 1'b0;
        set_ferr= 1'b0;
        clr_ferr= 1'b0;
        set_valid= 1'b0;
        clr_valid= 1'b0;
        set_oerr= 1'b0;
        clr_oerr= 1'b0;
        sh_rst = 1'd0;

        unique case (state)
            START:
            begin
                if(!rxd)
                begin
                    next = CHECKSTART;
                    ct_initclr = 1'd1;
                    br_2st = 1'd1;
                    clr_valid = 1'd1;
                end
                else next <= START;
            end
            IDLE:
            begin
                clr_valid = rdy;
                clr_oerr = rdy;
                if(!rxd)
                begin
                    next = CHECKSTART;
                    ct_initclr = 1'd1;
                    br_2st = 1'd1;
                end
                else next = IDLE;
            end
            CHECKSTART:
            begin
            ct_initenb = 1'd1;
                if(ct_initeq)
                begin
                    if(!rxd)
                    begin
                        next = LOAD;
                        set_valid = 1'd1;
                        br_st = 1'd1;
                        ct_clr = 1'd1;
                        clr_ferr = 1'd1;
                        sh_rst = 1'd1;
                        set_oerr = valid && !rdy;
                    end
                    else
                    begin
                        next = IDLE;
                    end
                end
                else next = CHECKSTART;
            end
            LOAD:
            begin
                sh_ld = 1'd1;
                ct_en = 1'd1;
                clr_valid = 1'd1;
                if(ct_eq)
                begin
                    ct_initclr = 1'd1;
                    br_2st = 1'd1;
                    br_st = 1'd1; // NEW HERE
                    next = STOPBIT;
                end
                else next = LOAD;
            end
            STOPBIT:
            begin
                ct_initenb = 1'd1;
                if(ct_initeq)
                begin
                    //next = IDLE;
                    sh_en = rxd;
                    set_valid = rxd;
                    set_ferr = !rxd;
                end
                else if(br_en) next = IDLE; //NEW HERE
                else next = STOPBIT;
            end
        endcase
    end
endmodule

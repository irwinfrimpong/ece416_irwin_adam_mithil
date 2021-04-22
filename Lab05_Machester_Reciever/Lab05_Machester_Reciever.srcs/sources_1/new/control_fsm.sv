`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Mithil Shah, Irwin Frimpong
// Create Date: 04/04/2021 04:08:19 PM
// Design Name: Manchester Reciever
// Module Name: control_fsm
// Project Name: Manchester Receiver Implementation
// Description: Control FSM for Manchester Reciever 
//////////////////////////////////////////////////////////////////////////////////

module control_fsm(
    input logic clk, rst, sfd_cnt_eq, wait_eq, pre_det, sfd_det, eof_det, edgerise_det, edgefall_det, err_det,br_en, br_4en, br_8en, errct_eq, ct_eq, timeout_eq, sh_ct_max, errwaitct_eq,
    output logic sfd_cnt_rst, sfd_cnt_enb,t_enb, enb_wait, rst_wait, rst_pre, rst_sfd, rst_eof, rst_edg, rst_err,br_st, br_4st, br_8st, errct_rst, ct_rst, ct_enb, sh_en, sh_ld, clr_cardet, set_cardet, clr_err_reg, set_err_reg, clr_valid, set_valid, clr_tout, set_sh_max, clr_sh_max, errwait_enb, errwaitct_rst);

    typedef enum logic [2:0]{
    PREAMBLE = 3'd0,
    SFD = 3'd1,
    WAIT_LOAD = 3'd2,
    LOAD = 3'd3,
    EDGEWAIT = 3'd4,
    ERRWAIT = 3'd5,
    EOF = 3'd6
    } state_t ;

    state_t state, next;

    always_ff @(posedge clk)
    begin
        if(rst) state <= PREAMBLE;
        else state <= next;
    end

    always_comb
    begin
        br_4st = 0;
        sfd_cnt_rst = 0;
        sfd_cnt_enb = 0;
        enb_wait = 0;
        rst_wait = 0;
        rst_pre = 0;
        rst_sfd = 0;
        rst_eof = 0;
        rst_edg = 0;
        rst_err = 0;
        br_4st = 0;
        br_8st = 0;
        br_st= 0;
        errct_rst = 0;
        ct_rst = 0;
        ct_enb = 0;
        sh_en = 0;
        sh_ld = 0;
        clr_cardet = 0;
        set_cardet = 0;
        clr_err_reg = 0;
        set_err_reg = 0;
        clr_valid = 0;
        set_valid = 0;
        clr_tout = 0;
        clr_sh_max = 0;
        t_enb = 0 ;
        set_sh_max= 0;
        errwait_enb = 0;
        errwaitct_rst= 0;


        unique case(state)
        PREAMBLE:
        begin
            clr_sh_max = 1;
            if(pre_det)
            begin
                next = SFD;
                set_cardet = 1;
                sfd_cnt_rst = 1;
            end
            else next = PREAMBLE;
        end
        SFD:
        begin
            sfd_cnt_rst = pre_det;
            sfd_cnt_enb = br_4en;
            if(sfd_det)
            begin
                next  = WAIT_LOAD;
                br_4st = 1;
                br_st = 1;
                rst_wait = 1;
            end
            else if(sfd_cnt_eq)
            begin
                next = PREAMBLE;
                clr_cardet = 1;
                sfd_cnt_rst = 1;
                set_err_reg = 1;
            end
            else next = SFD;
        end

        WAIT_LOAD:
        begin
            enb_wait = 1;
            if(wait_eq)
            begin
                next = LOAD;
                clr_err_reg = 1;
                ct_rst = 1;
            end
            else next = WAIT_LOAD;
        end

        LOAD:
        begin
            t_enb = br_8en;
            set_err_reg = err_det;
            clr_cardet = err_det;

            if(edgerise_det || edgefall_det)
            begin
                rst_wait = 1'b1;
                sh_ld = 1'b1;
                ct_enb = 1'b1 ;
                clr_tout= 1'b1;
                errwaitct_rst = 1'b1;
                br_8st = 1'b1;
                next= EDGEWAIT;
            end
            else if(eof_det) next= EOF;
            else if(timeout_eq)
            begin
                next = PREAMBLE;
                clr_cardet = 1;
                set_err_reg = 1;
            end
            else next =  LOAD;

        end

        EDGEWAIT:
        begin
            sh_en = ct_eq ;
            set_valid= ct_eq;
            errct_rst= ct_eq;
            set_sh_max = ct_eq;
            errwait_enb = 1'b1;
            ct_rst = ct_eq ;
            if(br_8en) next = ERRWAIT;
            else next = EDGEWAIT;
        end

        ERRWAIT:
        begin
            errwait_enb= 1'b1;
            clr_valid = 1;
            rst_err = 1;
            if(errwaitct_eq)
            begin
                errwaitct_rst = 1'b1;
                next = LOAD;
            end
            else next = ERRWAIT;
        end

        EOF:
        begin
            clr_valid = 1;
            clr_cardet = 1;
            set_err_reg = !sh_ct_max;
            if(!eof_det) next = PREAMBLE;
            else next = EOF;
        end
        default:
        next = PREAMBLE;
    endcase
end
endmodule

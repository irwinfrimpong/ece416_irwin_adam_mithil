`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/04/2021 04:08:19 PM
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
    input logic clk, rst, sfd_cnt_eq, wait_eq, pre_det, sfd_det, eof_det, edge_h, edge_l, err_det, br_4en, br_8en, errct_eq, ct_eq, timeout_eq,
   output logic sfd_cnt_rst, sfd_cnt_enb, enb_wait, rst_wait, rst_pre, rst_sfd, rst_eof, rst_edg, rst_err, br_4st, br_8st, errct_rst, ct_rst, ct_enb, sh_en, sh_ld, clr_cardet, set_cardet, clr_err_reg, set_err_reg, clr_valid, set_valid);

  typedef enum logic [1:0]{
  PREAMBLE = 2'b00,
  SFD = 2'b01,
  WAIT_LOAD = 2'b10
  } state_t ;

  state_t state, next;

  always_ff @(posedge clk)
  begin
      if(rst) state <= PREAMBLE;
      else state <= next;
  end

  always_comb
  begin
      unique case(state)
          PREAMBLE:
          begin
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
              if(br_4en)
              begin
                  next = PREAMBLE;
                  clr_err_reg = 1;
                  ct_rst = 1;
              end
              else next = WAIT_LOAD;
          end

         // LOAD:
        //  begin



      endcase
  end
endmodule

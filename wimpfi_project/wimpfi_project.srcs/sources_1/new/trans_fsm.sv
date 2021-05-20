`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/29/2021 02:30:51 PM
// Design Name:
// Module Name: trans_fsm
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


module trans_fsm(
    input logic clk, rst, rdy, difs_eq, xsend, cardet, slot_eq,buffdata_empty,
    input logic [7:0] trans_buffdata,
    output logic [7:0] data,
    output logic xbusy, failsafe_enb, failsafe_rst, difs_rst, slot_clr,slot_enb,buffer_pop, valid,difs_enb,slotreg_enb,buffer_clr,xrdy_assert,xrdy_clear
    );

    typedef enum logic [3:0]{
    IDLE = 4'd0,
    DIFS = 4'd1,
    BUSY = 4'd2,
    PREAMBLE = 4'd3,
    SFD = 4'd4,
    DEST_ADD = 4'd5,
    SOURCE_ADD = 4'd6,
    TYPE_T = 4'd7,
    DATA_T = 4'd8
    } state_t ;

    state_t state , next ;

    always_ff @(posedge clk)
    begin
        if(rst)
        begin
            state <= IDLE;
        end
        else state <= next;
    end



    always_comb begin
        xbusy = 1;
        failsafe_enb = 1;
        failsafe_rst = 0;
        difs_rst = 0;
        slot_clr = 0;
        buffer_pop = 0;
        valid = 0;
        slot_enb = 0;
        slotreg_enb = 0;
        difs_enb = 0;
        buffer_clr = 0;
        xrdy_assert = 0;
        data = 8'd0; // ADDED AT 5/18
        xrdy_clear = '0;

        unique case(state)
            IDLE:
            begin
                xbusy = 0;
                failsafe_enb = 0;
                failsafe_rst = 1;
                difs_rst = 1;
                xrdy_assert = 1;
                //buffer_clr =1;
                if(xsend) next = DIFS;
                else next = IDLE;
            end

            DIFS:
            begin
                slot_clr = 1;
                difs_enb = 1;
                if(!difs_eq) next = DIFS;
                else if (cardet)
                begin
                    next = BUSY;
                    slotreg_enb = 1;
                    slot_clr = 0;
                    slot_enb = 1;
                end
                else
                begin
                    next = PREAMBLE;
                    xrdy_clear = 1;
                    data = 8'b10101010;
                    valid = 1;
                end
            end

            BUSY:
            begin
                slot_enb = 1;
                if(slot_eq)
                begin
                    next = DIFS;
                    slot_clr = 1;
                    difs_rst = 1;
                end
                else next = BUSY;
            end

            PREAMBLE:
            begin
            valid = 1;
                if(rdy)
                begin
                    next = SFD;
                    data = 8'b11010000;
                 end
                else next = PREAMBLE;
            end

            SFD:
            begin
                valid= 1;
                if(rdy)
                begin
                    next = DEST_ADD;
                    buffer_pop = 1;
                    data = trans_buffdata;

                    //trans_count = trans_count_c;
                end
                else next = SFD;
            end

            DEST_ADD:
            begin
                valid= 1;
                if(rdy)
                begin
                    next = SOURCE_ADD;
                    buffer_pop = 1;
                    data = trans_buffdata;

                end
                else next = DEST_ADD;
            end

            SOURCE_ADD:
            begin
                valid = 1;
                if(rdy)
                begin
                    next = TYPE_T;
                    buffer_pop = 1;
                    data = trans_buffdata;

                end
                else next = SOURCE_ADD;
            end

            TYPE_T:
            begin
                valid= 1;
                if(rdy)
                begin
                    next = DATA_T;
                    buffer_pop = 1;
                    data = trans_buffdata;

                end
                else next = TYPE_T;
            end

            DATA_T:
            begin
                valid= 1;
                if(rdy && !buffdata_empty)
                begin
                    buffer_pop = 1;
                    data = trans_buffdata;

                    next = DATA_T; // added 5/19
                end
                else if(buffdata_empty && rdy)
                begin
                    next = IDLE;
                    buffer_clr = 1;
                    //xrdy_assert = 1;
                end
                else next = DATA_T;

            end
            default: next = IDLE; // Added 5/18
        endcase
    end

endmodule

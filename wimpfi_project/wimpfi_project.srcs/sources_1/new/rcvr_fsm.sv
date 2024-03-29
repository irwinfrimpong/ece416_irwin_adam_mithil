`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Adam Tunnell, Irwin Frimpong, Mithil Shah
//
// Create Date: 04/29/2021 02:30:21 PM
// Module Name: rcvr_fsm
// Project Name: WimpFi Project
// Description: Controller for the receiver module. Manages data coming from the
// Serial Receiver and going to the Manchester Transmitter
//////////////////////////////////////////////////////////////////////////////////


module rcvr_fsm(
    input logic clk, rst,rcvr_empty,rvalid_c,rrdy,
    input logic [7:0] rcvr_buffdata,
    output logic rcvr_bufferpop,rec_buffer_clr, rvalid,
    output logic [7:0] rcvr_dataout
    );

    typedef enum logic [2:0]{
    IDLE = 3'd0,
    DEST_ADDY = 3'd1,
    SOURCE_ADDY = 3'd2,
    TYPE = 3'd3,
    DATA = 3'd4
    } state_t ;

    state_t state, next;
    always_ff @(posedge clk)
    begin
        if(rst)
        begin
            state <= IDLE;
        end
        else state <= next;
    end

    logic [7:0] rtype, source_addy;


    always_comb begin
        rcvr_bufferpop = 0;
        rec_buffer_clr = 0;
        rvalid = 0;
        rcvr_dataout= 8'd0; 
        next = IDLE;
        case (state)
            IDLE:
            begin
                if(rvalid_c && rrdy)
                begin
                    next = DEST_ADDY;
                    rvalid = 1;
                    rcvr_bufferpop = 1;
                    rec_buffer_clr = 1;
                    rcvr_dataout = rcvr_buffdata;
                end
                else next = IDLE;
            end

            DEST_ADDY:
            begin
                rvalid = 1;
                if(rrdy)
                begin
                    next = SOURCE_ADDY;
                    rcvr_bufferpop = 1;
                    source_addy = rcvr_buffdata;
                    rcvr_dataout = rcvr_buffdata;
                end
                else next = DEST_ADDY;
            end

            SOURCE_ADDY:
                begin
                    rvalid = 1;
                    if(rrdy)
                    begin
                    rcvr_bufferpop = 1;
                    rtype = rcvr_buffdata;
                    rcvr_dataout = rcvr_buffdata;
                    next = TYPE;
                    end
                    else next = SOURCE_ADDY;
                end

            TYPE:
            begin
                rvalid = 1;
                if(rrdy)
                begin
                    next = DATA;
                    rcvr_bufferpop = 1;
                    rcvr_dataout = rcvr_buffdata;
                end

                else next = TYPE;

            end

            DATA:
            begin
                if(rcvr_empty)
                begin
                    next = IDLE;

                end
                else if(rrdy)
                begin
                    next = DATA;
                    rvalid = 1;
                    rcvr_bufferpop = 1;
                    rcvr_dataout = rcvr_buffdata;
                end
                else next = DATA ;
            end

        endcase
    end
endmodule

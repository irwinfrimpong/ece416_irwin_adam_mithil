module uart_xmit (
    input logic clk, rst, valid,
    input logic [7:0] data,
    output logic txd, rdy
    );

    parameter BAUD_RATE = 9600;

    // Control Signals
    logic br_st, br_en; // Rate enable
    rate_enb #(.RATE_HZ(BAUD_RATE)) U_RATENB (.clk,.rst, .clr(br_st), .enb_out(br_en));

    // Controller FSM

    typedef enum logic { WTVALID= 1'b0, TXBIT= 1'b1} states_t;
    states_t state, next;

    logic [3:0] count, count_next;
    logic [9:0] uart_reg;
    logic out, out_next;

    assign txd = out;

    always_ff @(posedge clk)
    begin
        if(rst)
        begin
            state <= WTVALID;
            count <= 0;
            out <= 1'b1;
            uart_reg <= 10'd0 ;
        end
        else
        begin
            state <= next;
            count <= count_next;
            uart_reg <= {1'b1,data,1'b0};
            out <= out_next;
        end
    end

    always_comb
    begin
        br_st = 0;
        out_next = out;
        count_next = count;
        rdy= 0;
        next = WTVALID;

        case(state)
            WTVALID:
            begin
                rdy = 1;
                if(valid)
                begin
                    count_next = 0;
                    br_st = 1;
                    next = TXBIT;
                end
                else next = WTVALID;
            end

            TXBIT:
            begin
                if (br_en)
                begin
                    if (count == 9) next = WTVALID;
                    else
                    begin
                        out_next = uart_reg[count];
                        count_next = count + 1;
                        next = TXBIT;
                    end
                end
                else next = TXBIT;
            end
        endcase
        end 


    endmodule //

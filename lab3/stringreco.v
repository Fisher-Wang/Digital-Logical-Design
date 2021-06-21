`timescale 1ns / 1ps

module stringreco_wfs (
    input clk,
    input clr,
    input en,
    input [15:0] sw,
    output [15:0] count
);

    reg [15:0] cnt;
    reg [15:0] num;
    reg [2:0] state;
    reg running;
    reg add;
    wire b;
    assign b = num[0:0];
    always @(posedge clk) begin
        /* running state change */
        if (en) begin
            num = sw;
            running = 1;
        end
        else if (clr) begin
            num = 0;
            cnt = 0;
            state = 0;
            running = 0;
        end
        /* running */
        if (running) begin
            num = num >> 1;
            /* FSM, Mealy Machine */
            case (state)
                0: begin state = ~b ? 1 : 4; add = ~b ? 0 : 0; end
                1: begin state = ~b ? 1 : 2; add = ~b ? 0 : 0; end
                2: begin state = ~b ? 3 : 5; add = ~b ? 0 : 0; end
                3: begin state = ~b ? 1 : 2; add = ~b ? 1 : 0; end
                4: begin state = ~b ? 1 : 5; add = ~b ? 0 : 0; end
                5: begin state = ~b ? 6 : 5; add = ~b ? 0 : 0; end
                6: begin state = ~b ? 1 : 2; add = ~b ? 0 : 1; end
                default: begin state = 0; add = 0; end
            endcase
            if (add)
                cnt = cnt + 1;
        end
    end
    assign count = cnt;
endmodule
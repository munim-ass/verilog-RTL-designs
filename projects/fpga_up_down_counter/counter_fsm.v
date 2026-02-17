`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 23:49:07
// Design Name: 
// Module Name: counter_fsm
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


module counter_fsm (
    input clk,
    input reset,
    input start_stop_btn,
    input up_down_sw,
    output reg enable_cnt,
    output reg dir
);

    // State encoding
    parameter IDLE       = 2'b00;
    parameter COUNT_UP   = 2'b01;
    parameter COUNT_DOWN = 2'b10;
    parameter PAUSED     = 2'b11;

    reg [1:0] state, next_state;
    reg start_stop_btn_prev;
    reg start_stop_pulse;

    // Edge detection for start/stop button
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start_stop_btn_prev <= 0;
            start_stop_pulse <= 0;
        end else begin
            start_stop_pulse <= start_stop_btn & ~start_stop_btn_prev;
            start_stop_btn_prev <= start_stop_btn;
        end
    end

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        enable_cnt = 0;
        dir = up_down_sw;

        case (state)
            IDLE: begin
                if (start_stop_pulse)
                    next_state = up_down_sw ? COUNT_UP : COUNT_DOWN;
            end
            COUNT_UP: begin
                enable_cnt = 1;
                dir = 1;
                if (start_stop_pulse)
                    next_state = PAUSED;
                else if (!up_down_sw)
                    next_state = COUNT_DOWN;
            end
            COUNT_DOWN: begin
                enable_cnt = 1;
                dir = 0;
                if (start_stop_pulse)
                    next_state = PAUSED;
                else if (up_down_sw)
                    next_state = COUNT_UP;
            end
            PAUSED: begin
                if (start_stop_pulse)
                    next_state = up_down_sw ? COUNT_UP : COUNT_DOWN;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule



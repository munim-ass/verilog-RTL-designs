`timescale 1ns / 1ps

module clock_divider #(
    parameter DIVIDER = 100000000  // For Zedboard: 1 Hz from 100 MHz input clock
)(
    input wire clk_in,
    input wire reset,
    output reg clk_out
);

    localparam COUNTER_WIDTH = $clog2(DIVIDER);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIVIDER-1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

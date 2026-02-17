`timescale 1ns / 1ps

module up_down_counter (
    input wire clk,          // Should be your divided clock
    input wire reset,        // Active high reset
    input wire enable,       // When high, counter runs
    input wire dir,          // 1 = up, 0 = down
    output reg [3:0] count   // 4-bit output (0-15)
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset to zero
        end
        else if (enable) begin
            if (dir) begin // Up count
                if (count == 4'b1111)
                    count <= 4'b0000;
                else
                    count <= count + 1;
            end
            else begin // Down count
                if (count == 4'b0000)
                    count <= 4'b1111;
                else
                    count <= count - 1;
            end
        end
        // If enable is low, hold current value (no change)
    end

endmodule


`timescale 1ns / 1ps

module debounce #(
    parameter N = 50 // Use N=2 for simulation, N=20 for hardware!
)(
    input wire clk,
    input wire reset,
    input wire button_in,
    output reg button_out
);
    reg [N-1:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= {N{1'b0}};
            button_out <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[N-2:0], button_in};
            // Output is high only if button input has been high for N clocks (stable press)
            if (&shift_reg)
                button_out <= 1'b1;
            else
                button_out <= 1'b0;
        end
    end

endmodule


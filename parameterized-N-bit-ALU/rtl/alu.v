`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 16:39:36
// Design Name: 
// Module Name: alu
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


module alu #(
    parameter WIDTH = 3
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire [3:0]       ALU_CTRL,

    output reg  [WIDTH-1:0] RESULT,
    output wire             ZERO,
    output reg              CARRY,
    output reg              OVERFLOW,
    output wire             SIGN
);

    // Internal signals
    reg [WIDTH:0] sum;
    reg [WIDTH:0] diff;

    wire [2*WIDTH-1:0] mult_result;
    assign mult_result = A * B;   // Vivado-safe multiply

    always @(*) begin
        // Default values (avoid latches)
        RESULT   = {WIDTH{1'b0}};
        CARRY    = 1'b0;
        OVERFLOW = 1'b0;
        sum      = { (WIDTH+1){1'b0} };
        diff     = { (WIDTH+1){1'b0} };

        case (ALU_CTRL)

            4'b0000: begin // ADD
                sum    = {1'b0, A} + {1'b0, B};
                RESULT = sum[WIDTH-1:0];
                CARRY  = sum[WIDTH];
                OVERFLOW = (A[WIDTH-1] == B[WIDTH-1]) &&
                           (RESULT[WIDTH-1] != A[WIDTH-1]);
            end

            4'b0001: begin // SUB
                diff   = {1'b0, A} - {1'b0, B};
                RESULT = diff[WIDTH-1:0];
                CARRY  = diff[WIDTH];
                OVERFLOW = (A[WIDTH-1] != B[WIDTH-1]) &&
                           (RESULT[WIDTH-1] != A[WIDTH-1]);
            end

            4'b0010: RESULT = A & B;  // AND
            4'b0011: RESULT = A | B;  // OR
            4'b0100: RESULT = A ^ B;  // XOR

            4'b0101: RESULT = A << B[$clog2(WIDTH)-1:0];  // SLL
            4'b0110: RESULT = A >> B[$clog2(WIDTH)-1:0];  // SRL

            4'b0111: begin  // SLT (signed)
                RESULT = ($signed(A) < $signed(B)) ? 1 : 0;
            end

            4'b1000: begin  // MUL (lower WIDTH bits)
                RESULT = mult_result[WIDTH-1:0];
            end

            default: RESULT = {WIDTH{1'b0}};

        endcase
    end

    assign ZERO = (RESULT == {WIDTH{1'b0}});
    assign SIGN = RESULT[WIDTH-1];

endmodule


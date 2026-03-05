`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 16:47:56
// Design Name: 
// Module Name: alu_tb
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


module alu_tb;

    parameter WIDTH = 3;

    reg  [WIDTH-1:0] A, B;
    reg  [3:0] ALU_CTRL;
    wire [WIDTH-1:0] RESULT;
    wire ZERO, CARRY, OVERFLOW, SIGN;

    alu #(WIDTH) dut (
        .A(A), .B(B),
        .ALU_CTRL(ALU_CTRL),
        .RESULT(RESULT),
        .ZERO(ZERO),
        .CARRY(CARRY),
        .OVERFLOW(OVERFLOW),
        .SIGN(SIGN)
    );

    initial begin
        A = 1; B = 2;

        ALU_CTRL = 4'b0000; #10; // ADD
        ALU_CTRL = 4'b0001; #10; // SUB
        ALU_CTRL = 4'b0010; #10; // AND
        ALU_CTRL = 4'b0011; #10; // OR
        ALU_CTRL = 4'b0101; #10; // SHIFT LEFT
        ALU_CTRL = 4'b0111; #10; // SLT

        $finish;
    end

endmodule


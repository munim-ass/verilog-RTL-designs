`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2026 20:13:12
// Design Name: 
// Module Name: 2_stage_pipelined_ALU
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


module twostage_pipelined_ALU(
input wire clk,
input wire rst_n,
input wire [31:0]in_a,
input wire [31:0]in_b,
input wire [2:0]op,
output reg [31:0]alu_out );
    // ==========================================
    // STAGE 1: Combinational Logic
    // ==========================================
reg[31:0] stage1_result;
always @(*) begin
    case (op)
            3'b000:  stage1_result = in_a + in_b;          // ADD
            3'b001:  stage1_result = in_a - in_b;          // SUB
            3'b010:  stage1_result = in_a & in_b;          // AND
            3'b011:  stage1_result = in_a | in_b;          // OR
            3'b100:  stage1_result = in_a ^ in_b;          // XOR
            3'b101:  stage1_result = in_a << (in_b & 5'h1F); // SLL (Shift Left Logical)
            default: stage1_result = 32'h0;
        endcase
    end
    // ==========================================
    // STAGE 2: Pipeline Staging Registers
    // ==========================================
    reg [31:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= 32'h0;
            alu_out    <= 32'h0;
        end else begin
            // First clock cycle captures the combinational logic into stage2_reg
            stage2_reg <= stage1_result;
            
            // Second clock cycle pushes the staged register out to the top-level port
            alu_out    <= stage2_reg;
        end
    end
endmodule

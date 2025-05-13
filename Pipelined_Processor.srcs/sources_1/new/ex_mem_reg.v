`timescale 1ns / 1ps

module ex_mem_reg (
    input         clk,
    input         reset,
    input  [31:0] ALUResult,
    input         Zero,
    input  [31:0] branch_addr,
    input  [31:0] pc_next_out2,
    input  [27:0] jump_shifted_out,
    input  [4:0]  write_reg,
    input         Jump_out,
    input         Branch_out,
    input         MemRead_out,
    input         MemtoReg_out,
    input  [1:0]  ALUOp_out,
    input         MemWrite_out,
    input         ALUSrc_out,
    input         RegWrite_out,
    input         Jal_out,
    input  [1:0]  mem_mode_out,
    input         Bne_out,
    input         valid_out,
    output reg [31:0] ALUResult_out,
    output reg        Zero_out,
    output reg [31:0] branch_addr_out,
    output reg [31:0] jump_target_out,
    output reg [31:0] pc_next_out2_out,
    output reg [4:0]  write_reg_dst_out,
    output reg        Jump_MEM,
    output reg        Branch_MEM,
    output reg        MemRead_MEM,
    output reg        MemtoReg_MEM,
    output reg [1:0]  ALUOp_MEM,
    output reg        MemWrite_MEM,
    output reg        ALUSrc_MEM,
    output reg        RegWrite_MEM,
    output reg        Jal_MEM,
    output reg [1:0]  mem_mode_MEM,
    output reg        Bne_MEM,
    output reg        valid_MEM
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ALUResult_out      <= 32'b0;
            Zero_out           <= 1'b0;
            branch_addr_out    <= 32'b0;
            jump_target_out    <= 32'b0;
            pc_next_out2_out   <= 32'b0;
            write_reg_dst_out  <= 5'b0;
            Jump_MEM           <= 0;
            Branch_MEM         <= 0;
            MemRead_MEM        <= 0;
            MemtoReg_MEM       <= 0;
            ALUOp_MEM          <= 2'b00;
            MemWrite_MEM       <= 0;
            ALUSrc_MEM         <= 0;
            RegWrite_MEM       <= 0;
            Jal_MEM            <= 0;
            mem_mode_MEM       <= 2'b00;
            Bne_MEM            <= 0;
            valid_MEM          <= 0;
        end else begin
            ALUResult_out      <= ALUResult;
            Zero_out           <= Zero;
            branch_addr_out    <= branch_addr;
            jump_target_out    <= { pc_next_out2[31:28], jump_shifted_out };
            pc_next_out2_out   <= pc_next_out2;
            write_reg_dst_out  <= write_reg;
            Jump_MEM           <= Jump_out;
            Branch_MEM         <= Branch_out;
            MemRead_MEM        <= MemRead_out;
            MemtoReg_MEM       <= MemtoReg_out;
            ALUOp_MEM          <= ALUOp_out;
            MemWrite_MEM       <= MemWrite_out;
            ALUSrc_MEM         <= ALUSrc_out;
            RegWrite_MEM       <= RegWrite_out;
            Jal_MEM            <= Jal_out;
            mem_mode_MEM       <= mem_mode_out;
            Bne_MEM            <= Bne_out;
            valid_MEM          <= valid_out;
        end
    end

endmodule

`timescale 1ns / 1ps

module mem_wb_reg (
    input         clk,
    input         reset,
    input  [31:0] read_data_mem,
    input  [31:0] ALUResult_out,
    input  [4:0]  write_reg_dst_out,
    input         RegWrite_MEM,
    input         MemtoReg_MEM,
    input         Jal_MEM,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  write_reg_wb,
    output reg        RegWrite_final,
    output reg        MemtoReg_final,
    output reg        Jal_WB
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_data_out    <= 32'b0;
            alu_result_out  <= 32'b0;
            write_reg_wb    <= 5'b0;
            RegWrite_final  <= 0;
            MemtoReg_final  <= 0;
            Jal_WB          <= 0;
        end else begin
            mem_data_out    <= read_data_mem;
            alu_result_out  <= ALUResult_out;
            write_reg_wb    <= write_reg_dst_out;
            RegWrite_final  <= RegWrite_MEM;
            MemtoReg_final  <= MemtoReg_MEM;
            Jal_WB          <= Jal_MEM;
        end
    end
endmodule

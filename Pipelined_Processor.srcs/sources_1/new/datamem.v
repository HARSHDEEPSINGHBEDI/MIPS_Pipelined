`timescale 1ns / 1ps

module datamem (
    input         clk,
    input         MemWrite_out,
    input         MemRead_out,
    input  [1:0]  mem_mode_out,
    input  [31:0] ALUResult_out,
    input  [31:0] read_data2_out,
    input         valid_MEM,
    output reg [31:0] read_data_mem
);

    reg [31:0] memory [0:255];

    always @(*) begin
        read_data_mem = 32'b0;
        if (valid_MEM && MemRead_out) begin
            case (mem_mode_out)
                2'b00: read_data_mem = memory[ALUResult_out >> 2];
                2'b01: begin
                    if (ALUResult_out[1] == 1'b0)
                        read_data_mem = {16'b0, memory[ALUResult_out >> 2][15:0]};
                    else
                        read_data_mem = {16'b0, memory[ALUResult_out >> 2][31:16]};
                end
                default: read_data_mem = 32'b0;
            endcase
        end
    end

    always @(posedge clk) begin
        if (valid_MEM && MemWrite_out && mem_mode_out == 2'b00) begin
            memory[ALUResult_out >> 2] <= read_data2_out;
        end
    end

endmodule

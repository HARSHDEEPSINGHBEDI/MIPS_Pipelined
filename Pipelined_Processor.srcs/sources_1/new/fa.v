`timescale 1ns / 1ps

module forwardA_mux (
    input  [1:0] ForwardA,
    input  [31:0] read_data1_out,
    input  [31:0] ex_mem_alu_out,
    input  [31:0] mem_wb_data,
    output reg [31:0] forwardA_out
);
    always @(*) begin
        case (ForwardA)
            2'b00: forwardA_out = read_data1_out;
            2'b10: forwardA_out = ex_mem_alu_out;
            2'b01: forwardA_out = mem_wb_data;
            default: forwardA_out = 0;
        endcase
    end
endmodule

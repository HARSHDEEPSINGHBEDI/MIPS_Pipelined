`timescale 1ns / 1ps

module forwardB_mux (
    input  [1:0]  ForwardB,
    input  [31:0] read_data2_out,
    input  [31:0] ex_mem_alu_out,
    input  [31:0] mem_wb_data,
    output reg [31:0] forwardB_out
);

    always @(*) begin
        case (ForwardB)
            2'b00: forwardB_out = read_data2_out;
            2'b10: forwardB_out = ex_mem_alu_out;
            2'b01: forwardB_out = mem_wb_data;
            default: forwardB_out = 32'b0;
        endcase
    end

endmodule

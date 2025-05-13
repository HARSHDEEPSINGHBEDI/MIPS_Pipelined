`timescale 1ns / 1ps

module mux_alu_src (
    input  [31:0] forwardB_out,
    input  [31:0] imm_ext_out,
    input         ALUSrc_out,
    output reg [31:0] alu_src_out
);

    always @(*) begin
        if (ALUSrc_out)
            alu_src_out = imm_ext_out;
        else
            alu_src_out = forwardB_out;
    end

endmodule

`timescale 1ns / 1ps

module shift_left_2_jump (
    input  [31:0] instr_out,
    output reg [27:0] jump_shifted
);
    always @(*) begin
        jump_shifted = instr_out[25:0] << 2;
    end
endmodule

`timescale 1ns / 1ps

module shift_left_2 (
    input  [31:0] imm_ext_out2,
    output reg [31:0] shift_left
);

    always @(*) begin
        shift_left = imm_ext_out2 << 2;
    end

endmodule

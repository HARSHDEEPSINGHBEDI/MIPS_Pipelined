`timescale 1ns / 1ps

module branch_target_adder (
    input [31:0] pc_next,
    input [31:0] shift_left,
    output [31:0] branch_target
);
    assign branch_target = pc_next + shift_left;
endmodule
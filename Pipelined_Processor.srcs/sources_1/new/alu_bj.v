
`timescale 1ns / 1ps
module alu_bj (
    input [31:0] pc_next_out2,
    input [31:0] shift_left,
    output [31:0] branch_addr
);
    assign branch_addr = pc_next_out2 + shift_left;
endmodule
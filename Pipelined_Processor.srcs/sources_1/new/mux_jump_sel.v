
`timescale 1ns / 1ps
module mux_jump_sel (
    input [31:0] pc_branch_out,
    input [31:0] jump_target_out,
    input [31:0] pc_next,
    input        Jump_out,
    input        Branch_out,
    input        valid_MEM,
    output [31:0] pc_in
);
    assign pc_in = (valid_MEM && Jump_out)   ? jump_target_out :
                   (valid_MEM && Branch_out) ? pc_branch_out    :
                                                pc_next;
endmodule
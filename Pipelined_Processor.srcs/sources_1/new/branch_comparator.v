`timescale 1ns / 1ps

module branch_comparator (
    input  [31:0] reg_data1,
    input  [31:0] reg_data2,
    input         Branch,
    input         Bne,
    output        take_branch
);
    assign take_branch = Branch && (
        (Bne  && (reg_data1 != reg_data2)) ||
        (!Bne && (reg_data1 == reg_data2))
    );
endmodule

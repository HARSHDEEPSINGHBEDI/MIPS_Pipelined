`timescale 1ns / 1ps

module adder (
    input  [31:0] pc_out,
    output [31:0] pc_next
);

    assign pc_next = pc_out + 32'd4;

endmodule

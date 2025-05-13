`timescale 1ns / 1ps

module if_id_reg (
    input        clk,
    input        reset,
    input        if_id_write,
    input        flush,
    input  [31:0] instruction,
    input  [31:0] pc_next,
    output reg [31:0] instr_out,
    output reg [31:0] pc_next_out
);

    always @(posedge clk) begin
        if (reset || flush) begin
            instr_out   <= 32'b0;
            pc_next_out <= 32'b0;
        end else if (if_id_write) begin
            instr_out   <= instruction;
            pc_next_out <= pc_next;
        end
    end

endmodule

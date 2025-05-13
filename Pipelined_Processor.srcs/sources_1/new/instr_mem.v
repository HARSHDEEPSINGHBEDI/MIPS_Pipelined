`timescale 1ns / 1ps

module instr_mem (
    input  [31:0] pc_out,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:255];

    initial
        $readmemh("program1.mem", memory);

    always @(*) begin
        instruction = memory[pc_out >> 2];
    end

endmodule

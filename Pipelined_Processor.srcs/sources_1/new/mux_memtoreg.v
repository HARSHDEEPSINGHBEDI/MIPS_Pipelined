`timescale 1ns / 1ps

module mux_memtoreg (
    input  [31:0] alu_result_out,
    input  [31:0] mem_data,
    input  [31:0] pc_next,
    input         MemtoReg_final,
    input         Jal_WB,
    output [31:0] write_data
);
    assign write_data = (Jal_WB       ? pc_next :
                        (MemtoReg_final ? mem_data :
                                          alu_result_out));
endmodule

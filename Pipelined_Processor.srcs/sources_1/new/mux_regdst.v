`timescale 1ns / 1ps

module regdst_mux (
    input  [4:0] rt_out,
    input  [4:0] rd_out,
    input        RegDst_EX,
    input        Jal_out,
    output [4:0] write_reg
);

    assign write_reg = (Jal_out    ? 5'd31 :
                       (RegDst_EX  ? rd_out :
                                    rt_out));

endmodule

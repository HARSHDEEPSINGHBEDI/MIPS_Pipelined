`timescale 1ns / 1ps

module hazard_detection_unit (
    input        ID_EX_MemRead,
    input        valid_ID_EX,
    input  [4:0] ID_EX_RegisterRt,
    input  [4:0] IF_ID_RegisterRs,
    input  [4:0] IF_ID_RegisterRt,
    input        RegWrite_EX_MEM,
    input  [4:0] EX_MEM_rd,
    input        RegWrite_MEM_WB,
    input  [4:0] MEM_WB_rd,
    input        take_branch,
    output reg        pc_write,
    output reg        IF_ID_Write,
    output reg        ControlHazard,
    output reg [1:0]  ForwardA,
    output reg [1:0]  ForwardB
);
    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        if (RegWrite_EX_MEM && (EX_MEM_rd != 0)) begin
            if (EX_MEM_rd == IF_ID_RegisterRs) ForwardA = 2'b10;
            if (EX_MEM_rd == IF_ID_RegisterRt) ForwardB = 2'b10;
        end
        if (RegWrite_MEM_WB && (MEM_WB_rd != 0)) begin
            if ((MEM_WB_rd == IF_ID_RegisterRs) && (ForwardA == 2'b00)) ForwardA = 2'b01;
            if ((MEM_WB_rd == IF_ID_RegisterRt) && (ForwardB == 2'b00)) ForwardB = 2'b01;
        end
    end

    always @(*) begin
        if (valid_ID_EX && ID_EX_MemRead &&
           ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt))) begin
            pc_write      = 0;
            IF_ID_Write   = 0;
            ControlHazard = 1;
        end else if (take_branch) begin
            pc_write      = 1;
            IF_ID_Write   = 1;
            ControlHazard = 1;
        end else begin
            pc_write      = 1;
            IF_ID_Write   = 1;
            ControlHazard = 0;
        end
    end
endmodule

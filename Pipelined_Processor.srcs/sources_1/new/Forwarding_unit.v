
// Now gates every forwards on the pipeline "valid" bit, so flushed or bubbled
// instructions cannot supply bogus data.

`timescale 1ns / 1ps

module forwarding_unit (
    input  [4:0] rs_out,              
    input  [4:0] rt_out,               
    input  [4:0] write_reg_dst_out,    
    input        RegWrite_MEM,         
    input        valid_MEM,            
    input  [4:0] write_reg_wb,        
    input        RegWrite_WB,         
    input        valid_WB,            

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // EX→EX hazard (highest priority) only if EX/MEM holds a real instr  
        if (RegWrite_MEM && valid_MEM && (write_reg_dst_out != 0)) begin
            if (write_reg_dst_out == rs_out) ForwardA = 2'b10;
            if (write_reg_dst_out == rt_out) ForwardB = 2'b10;
        end

        // MEM→EX hazard (lower priority) only if MEM/WB holds a real instr  
        if (RegWrite_WB && valid_WB && (write_reg_wb != 0)) begin
            if (write_reg_wb == rs_out && ForwardA==2'b00) ForwardA = 2'b01;
            if (write_reg_wb == rt_out && ForwardB==2'b00) ForwardB = 2'b01;
        end
    end

endmodule

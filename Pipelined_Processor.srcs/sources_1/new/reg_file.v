`timescale 1ns / 1ps

module reg_file (
    input              clk,
    input              RegWrite_final,   
    input      [31:0]  instr_out,      
    input      [4:0]   write_reg_wb,      
    input      [31:0]  write_data,      
    output reg [31:0]  read_data1,        
    output reg [31:0]  read_data2        
);

    
    reg [31:0] reg_array [0:31];

   
    wire [4:0] rs = instr_out[25:21];
    wire [4:0] rt = instr_out[20:16];

  
    always @(posedge clk) begin
        if (RegWrite_final && write_reg_wb != 5'd0) begin
            reg_array[write_reg_wb] <= write_data;
        end
    end

   
    always @(negedge clk) begin
        read_data1 <= reg_array[rs];
        read_data2 <= reg_array[rt];
    end

endmodule

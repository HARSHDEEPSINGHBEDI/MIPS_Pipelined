`timescale 1ns / 1ps

module main_alu (
    input  [31:0] forwardA_out,
    input  [31:0] alu_input_b,
    input  [3:0]  ALUControl,
    output reg [31:0] ALUResult,
    output       Zero
);

    assign Zero = (ALUResult == 0);

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = forwardA_out & alu_input_b;
            4'b0001: ALUResult = forwardA_out | alu_input_b;
            4'b0010: ALUResult = forwardA_out + alu_input_b;
            4'b0011: ALUResult = alu_input_b >> forwardA_out[4:0];
            4'b0110: ALUResult = forwardA_out - alu_input_b;
            4'b0111: ALUResult = ($signed(forwardA_out) < $signed(alu_input_b)) ? 32'd1 : 32'd0;
            4'b1000: ALUResult = ($unsigned(forwardA_out) < $unsigned(alu_input_b)) ? 32'd1 : 32'd0;
            default: ALUResult = 32'hDEADBEEF;
        endcase
    end

endmodule

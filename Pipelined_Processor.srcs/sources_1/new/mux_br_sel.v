
// Make sure we only take a branch when EX/MEM is actually valid.

`timescale 1ns / 1ps

module mux_br_sel (
    input  [31:0] pc_next_out2_out,   // EX/MEM.pc+4
    input  [31:0] branch_addr_out,    // EX/MEM.branch_addr
    input         Zero_out,           // EX/MEM.Zero
    input         Branch_out,         // EX/MEM.Branch
    input         Bne_out,            // EX/MEM.Bne
    input         valid_MEM,          // EX/MEM.valid
    output [31:0] pc_branch_out
);

    wire take = valid_MEM && (
                     (Branch_out &&  Zero_out) ||
                     (Bne_out    && ~Zero_out)
                   );

    assign pc_branch_out = take ? branch_addr_out
                                : pc_next_out2_out;

endmodule

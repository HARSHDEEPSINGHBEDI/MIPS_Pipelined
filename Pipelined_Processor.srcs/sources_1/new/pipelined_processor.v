`timescale 1ns / 1ps

module pipelined_processor (
    input         clk,
    input         reset,
    input         start
);

    // IF stage
    wire [31:0] pc_out, pc_in, pc_next;
    wire [31:0] instruction;
    wire        PCWrite, IF_ID_Write, Flush;

    pc PC (
        .clk(clk),
        .reset(reset),
        .pc_write(PCWrite),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    adder PC_ADDER (
        .pc_out(pc_out),
        .pc_next(pc_next)
    );

    instr_mem IMEM (
        .pc_out(pc_out),
        .instruction(instruction)
    );

    // IF/ID pipeline register
    wire [31:0] if_id_instr, if_id_pc_next;
    if_id_reg IF_ID (
        .clk(clk),
        .reset(reset),
        .if_id_write(IF_ID_Write),
        .flush(Flush),
        .instruction(instruction),
        .pc_next(pc_next),
        .instr_out(if_id_instr),
        .pc_next_out(if_id_pc_next)
    );

    // ID stage
    wire [4:0]  rs_id     = if_id_instr[25:21];
    wire [4:0]  rt_id     = if_id_instr[20:16];
    wire [4:0]  rd_id     = if_id_instr[15:11];
    wire [5:0]  opcode    = if_id_instr[31:26];
    wire [5:0]  funct     = if_id_instr[5:0];
    wire [31:0] read_data1, read_data2, imm_ext;

    wire        RegDst, Jump, Branch, Bne, MemRead, MemtoReg,
                MemWrite, ALUSrc, RegWrite, Jal;
    wire [1:0]  ALUOp, mem_mode;
    wire        ExtSel;

    control_unit CU (
        .opcode(opcode),
        .RegDst(RegDst),
        .Jump(Jump),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .mem_mode(mem_mode),
        .Branch(Branch),
        .Bne(Bne),
        .ExtSel(ExtSel)
    );

    regdst_mux REGDST (
        .rt_out(rt_id),
        .rd_out(rd_id),
        .RegDst_EX(RegDst),
        .Jal_out(Jal),
        .write_reg(write_reg)
    );

    wire [4:0]  write_reg;
    wire [4:0]  wb_rd;
    wire [31:0] write_data;
    wire        RegWrite_WB;

    reg_file REGFILE (
        .clk(clk),
        .RegWrite_final(RegWrite_WB),
        .instr_out(if_id_instr),
        .write_reg_wb(wb_rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    sign_ext SIGN_EXT (
        .instr_out(if_id_instr),
        .ExtSel(ExtSel),
        .imm_ext(imm_ext)
    );

    shift_left_2 SHIFT_BRANCH (
        .imm_ext_out2(imm_ext),
        .shift_left(id_branch_target)
    );

    wire [31:0] id_branch_target;

    shift_left_2_jump SLJ (
        .instr_out(if_id_instr),
        .jump_shifted(jump_shifted)
    );

    wire [27:0] jump_shifted;
    wire [31:0] jump_target = {if_id_pc_next[31:28], jump_shifted};

    branch_comparator BR_CMP (
        .reg_data1(read_data1),
        .reg_data2(read_data2),
        .Branch(Branch),
        .Bne(Bne),
        .take_branch(take_branch)
    );

    wire take_branch;

    branch_target_adder BRANCH_ADDER (
        .pc_next(if_id_pc_next),
        .shift_left(id_branch_target),
        .branch_target(branch_pc_out)
    );

    wire [31:0] branch_pc_out;

    // EX/MEM selectors for PC
    wire [31:0] mem_pc_next, mem_branch_addr;
    wire        mem_zero, Branch_MEM, Bne_MEM, valid_MEM;

    mux_br_sel BR_SEL (
        .pc_next_out2_out(mem_pc_next),
        .branch_addr_out(mem_branch_addr),
        .Zero_out(mem_zero),
        .Branch_out(Branch_MEM),
        .Bne_out(Bne_MEM),
        .valid_MEM(valid_MEM),
        .pc_branch_out(pc_branch_out)
    );

    wire [31:0] pc_branch_out;

    mux_jump_sel JMP_SEL (
        .pc_branch_out(pc_branch_out),
        .jump_target_out(mem_jump_target),
        .pc_next(pc_next),
        .Jump_out(Jump_MEM),
        .Branch_out(Branch_MEM),
        .valid_MEM(valid_MEM),
        .pc_in(pc_in)
    );

    wire [31:0] mem_jump_target;

    // ID/EX pipeline register
    wire [31:0] ex_pc, ex_rd1, ex_rd2, ex_imm;
    wire [4:0]  ex_rs, ex_rt, ex_rd;
    wire [5:0]  funct_out;
    wire [27:0] ex_jump_shifted;
    wire [1:0]  ALUOp_EX, mem_mode_EX;
    wire        RegDst_EX, Branch_EX, MemRead_EX, MemtoReg_EX, MemWrite_EX,
                ALUSrc_EX, RegWrite_EX, Jump_EX, Jal_EX, Bne_EX, valid_ID_EX;

    id_ex_reg ID_EX (
        .clk(clk),
        .reset(reset),
        .ControlHazard(Flush),
        .pc_next_out(if_id_pc_next),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .imm_ext(imm_ext),
        .rs(rs_id),
        .rt(rt_id),
        .rd(rd_id),
        .funct(funct),
        .jump_shifted(jump_shifted),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .mem_mode(mem_mode),
        .Bne(Bne),
        .pc_next_out2(ex_pc),
        .read_data1_out(ex_rd1),
        .read_data2_out(ex_rd2),
        .imm_ext_out(ex_imm),
        .rs_out(ex_rs),
        .rt_out(ex_rt),
        .rd_out(ex_rd),
        .funct_out(funct_out),
        .jump_shifted_out(ex_jump_shifted),
        .Jump_out(Jump_EX),
        .Branch_out(Branch_EX),
        .MemRead_out(MemRead_EX),
        .MemtoReg_out(MemtoReg_EX),
        .ALUOp_out(ALUOp_EX),
        .MemWrite_out(MemWrite_EX),
        .ALUSrc_out(ALUSrc_EX),
        .RegWrite_out(RegWrite_EX),
        .Jal_out(Jal_EX),
        .mem_mode_out(mem_mode_EX),
        .Bne_out(Bne_EX),
        .valid_out(valid_ID_EX)
    );

    // Forwarding and ALU inputs
    wire [1:0]  ForwardA, ForwardB;
    wire [31:0] alu_in_a, forwardB_out, alu_input2;

    forwarding_unit FU (
        .rs_out(ex_rs),
        .rt_out(ex_rt),
        .write_reg_dst_out(mem_reg_dst),
        .RegWrite_MEM(RegWrite_MEM),
        .write_reg_wb(wb_rd),
        .RegWrite_WB(RegWrite_WB),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    forwardA_mux FAMUX (
        .ForwardA(ForwardA),
        .read_data1_out(ex_rd1),
        .ex_mem_alu_out(mem_alu_result),
        .mem_wb_data(write_data),
        .forwardA_out(alu_in_a)
    );

    forwardB_mux FBMUX (
        .ForwardB(ForwardB),
        .read_data2_out(ex_rd2),
        .ex_mem_alu_out(mem_alu_result),
        .mem_wb_data(write_data),
        .forwardB_out(forwardB_out)
    );

    mux_alu_src ALUSRC_MUX (
        .forwardB_out(forwardB_out),
        .imm_ext_out(ex_imm),
        .ALUSrc_out(ALUSrc_EX),
        .alu_src_out(alu_input2)
    );

    wire [3:0] alu_ctrl;
    alu_control ALU_CTRL (
        .ALUOp(ALUOp_EX),
        .funct(funct_out),
        .ALUControl(alu_ctrl)
    );

    wire [31:0] alu_result;
    wire        zero_flag_EX;

    main_alu ALU (
        .forwardA_out(alu_in_a),
        .alu_input_b(alu_input2),
        .ALUControl(alu_ctrl),
        .ALUResult(alu_result),
        .Zero(zero_flag_EX)
    );

    alu_bj BRANCH_ALU (
        .pc_next_out2(ex_pc),
        .shift_left(id_branch_target),
        .branch_addr(branch_target)
    );

    wire [31:0] branch_target;

    // EX/MEM pipeline register
    wire [31:0] mem_alu_result;
    wire [4:0]  mem_reg_dst;

    ex_mem_reg EX_MEM (
        .clk(clk),
        .reset(reset),
        .ALUResult(alu_result),
        .Zero(zero_flag_EX),
        .branch_addr(branch_target),
        .pc_next_out2(ex_pc),
        .jump_shifted_out(ex_jump_shifted),
        .write_reg(write_reg),
        .Jump_out(Jump_EX),
        .Branch_out(Branch_EX),
        .MemRead_out(MemRead_EX),
        .MemtoReg_out(MemtoReg_EX),
        .ALUOp_out(ALUOp_EX),
        .MemWrite_out(MemWrite_EX),
        .ALUSrc_out(ALUSrc_EX),
        .RegWrite_out(RegWrite_EX),
        .Jal_out(Jal_EX),
        .mem_mode_out(mem_mode_EX),
        .Bne_out(Bne_EX),
        .valid_out(valid_ID_EX),
        .ALUResult_out(mem_alu_result),
        .Zero_out(mem_zero),
        .branch_addr_out(mem_branch_addr),
        .jump_target_out(mem_jump_target),
        .pc_next_out2_out(mem_pc_next),
        .write_reg_dst_out(mem_reg_dst),
        .Jump_MEM(Jump_MEM),
        .Branch_MEM(Branch_MEM),
        .MemRead_MEM(MemRead_MEM),
        .MemtoReg_MEM(MemtoReg_MEM),
        .ALUOp_MEM(ALUOp_MEM),
        .MemWrite_MEM(MemWrite_MEM),
        .ALUSrc_MEM(ALUSrc_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .Jal_MEM(Jal_MEM),
        .mem_mode_MEM(mem_mode_MEM),
        .Bne_MEM(Bne_MEM),
        .valid_MEM(valid_MEM)
    );

    // MEM stage
    wire [31:0] mem_data;

    datamem MEM (
        .clk(clk),
        .MemWrite_out(MemWrite_MEM),
        .MemRead_out(MemRead_MEM),
        .mem_mode_out(mem_mode_MEM),
        .ALUResult_out(mem_alu_result),
        .read_data2_out(forwardB_out),
        .valid_MEM(valid_MEM),
        .read_data_mem(mem_data)
    );

    // MEM/WB pipeline register
    wire [31:0] wb_mem_data, wb_alu_result;
    wire        MemtoReg_WB, Jal_WB;

    mem_wb_reg MEM_WB (
        .clk(clk),
        .reset(reset),
        .read_data_mem(mem_data),
        .ALUResult_out(mem_alu_result),
        .write_reg_dst_out(mem_reg_dst),
        .RegWrite_MEM(RegWrite_MEM),
        .MemtoReg_MEM(MemtoReg_MEM),
        .Jal_MEM(Jal_MEM),
        .mem_data_out(wb_mem_data),
        .alu_result_out(wb_alu_result),
        .write_reg_wb(wb_rd),
        .RegWrite_final(RegWrite_WB),
        .MemtoReg_final(MemtoReg_WB),
        .Jal_WB(Jal_WB)
    );

    // WB stage
    mux_memtoreg WB_MUX (
        .alu_result_out(wb_alu_result),
        .mem_data(wb_mem_data),
        .pc_next(mem_pc_next),
        .MemtoReg_final(MemtoReg_WB),
        .Jal_WB(Jal_WB),
        .write_data(write_data)
    );

    // Hazard detection
    hazard_detection_unit HAZARD_UNIT (
        .ID_EX_MemRead(MemRead_EX),
        .valid_ID_EX(valid_ID_EX),
        .ID_EX_RegisterRt(ex_rt),
        .IF_ID_RegisterRs(rs_id),
        .IF_ID_RegisterRt(rt_id),
        .RegWrite_EX_MEM(RegWrite_MEM),
        .EX_MEM_rd(mem_reg_dst),
        .RegWrite_MEM_WB(RegWrite_WB),
        .MEM_WB_rd(wb_rd),
        .take_branch(take_branch),
        .pc_write(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ControlHazard(Flush),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

endmodule
 
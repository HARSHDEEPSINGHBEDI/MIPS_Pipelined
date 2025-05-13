# MIPS Pipelined Processor – Hazard-Resolved – Harshdeep Singh

This repository implements a **5-stage pipelined 32-bit MIPS CPU** in Verilog, complete with hardware to automatically detect and resolve data and control hazards (forwarding & stalling).

Supported instructions (17 total):
1. `add`  
2. `sub`  
3. `and`  
4. `or`  
5. `lw`  
6. `sw`  
7. `slt`  
8. `sltiu`  
9. `srl`  
10. `lhu`  
11. `beq`  
12. `bne`  
13. `j`  
14. `jal`  
15. *(repeat)* `add`  
16. *(repeat)* `sub`  
17. *(repeat)* `and`  

---

## 📁 Repository Layout

```text
MIPS_Pipelined_WithHazards/
├── src/
│   ├── pipelined_processor.v     # Top-level 5-stage pipeline + hazard logic
│   ├── pc.v                      # Program Counter (with stall enable)
│   ├── adder.v                   # PC+4 adder
│   ├── instr_mem.v               # Instruction memory (256×32)
│   ├── if_id_reg.v               # IF/ID pipeline register (stall & flush)
│   ├── control_unit.v            # Opcode → core control signals
│   ├── hazard_detection_unit.v   # Detects load-use & branch hazards, generates stalls
│   ├── forwarding_unit.v         # ALU-ALU & MEM→EX forwarding control
│   ├── reg_file.v                # 32×32 register file (sync write, async read)
│   ├── sign_ext.v                # Sign/zero-extender
│   ├── shift_left_2.v            # Branch offset shifter
│   ├── shift_left_2_jump.v       # Jump target shifter
│   ├── if_id_reg.v               # IF/ID register
│   ├── id_ex_reg.v               # ID/EX register (flushable)
│   ├── ex_mem_reg.v              # EX/MEM register
│   ├── mem_wb_reg.v              # MEM/WB register
│   ├── alu_control.v             # ALUOp+funct → ALU control code
│   ├── mux_alu_src.v             # ALU B-operand mux
│   ├── main_alu.v                # ALU core (AND, OR, ADD, SUB, SLT, SRL, SLTIU)
│   ├── alu_bj.v                  # Branch-target adder (PC+4 + offset)
│   ├── regdst_mux.v              # RegDst mux (rt/rd/$ra)
│   ├── datamem.v                 # Data memory (word & half-word)
│   ├── mux_memtoreg.v            # MemtoReg mux (ALU/MEM/PC+4)
│   ├── mux_br_sel.v              # Branch decision mux
│   └── mux_jump_sel.v            # Final PC mux (branch/jump/default)
├── img/
│   ├── Screenshot 2025-05-13 182929.png   # 🖼️ Pipelined Datapath
│   ├── Screenshot 2025-05-13 182935.png   # 🖼️ Forwarding Unit Hardware
│   ├── Screenshot 2025-05-13 182945.png   # 🖼️ Hazard Detection Unit
│   └── Screenshot 2025-05-13 183018.png   # 🖼️ Summary: Hazards & Solutions
├── tb/
│   ├── pipelined_processor_tb.v  # Testbench & waveform logger
│   └── program1.mem              # 17 instruction hex words
└── README.md

## 🖼️ Datapath & Hazard-Resolution Units

*Blue = data paths* | *Orange = control & stall/forward signals*

### Pipelined Datapath  
![Datapath](img/Screenshot%202025-05-13%20182929.png)

### Forwarding Unit Hardware  
![Forwarding Unit](img/Screenshot%202025-05-13%20182935.png)

### Hazard Detection Unit  
![Hazard Unit](img/Screenshot%202025-05-13%20182945.png)

### Hazards & Solutions Summary  
![Summary](img/Screenshot%202025-05-13%20183018.png)

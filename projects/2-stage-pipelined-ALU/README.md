# Pipelined ALU with C++/Python Co-Verification Framework

A 32-bit, 2-stage pipelined ALU designed in Verilog, verified using a hybrid hardware/software co-simulation environment. Instead of relying purely on monolithic HDL testbenches, this architecture offloads test vector generation and post-sim log analytics to Python, while leveraging a cycle-accurate C++ reference model bound via SystemVerilog DPI-C.

## Key Features
* **Pipelined Execution:** Dual-stage registers optimizing critical path delay for target frequency mapping.
* **Zero-Disk-I/O Reference Checking:** The C++ model runs natively within the simulator's memory space via DPI-C, evaluating arithmetic correctness cycle-by-cycle without slow text-log polling.
* **Automated Regression Pipeline:** High-level Python architecture handling edge-case injection (signed overflows, bitwise limits) and final simulation log assertions.

---

## Verification Pipeline

| Phase | Component | Responsibility | Interface Layer |
| :--- | :--- | :--- | :--- |
| **1. Stimulus Generation** | `sim/generate_stimulus.py` | Exports targeted mathematical distributions and boundary conditions into raw hex blocks. | File I/O (`stimulus.txt`) |
| **2. Pipeline Driving** | `tb/tb_pipelined_alu.sv` | Ingests test vectors on clock edges, driving the RTL pipeline while tracking the 2-cycle latency offset. | Native SystemVerilog |
| **3. Golden Reference** | `tb/c_alu_reference.cpp` | Computes the golden structural reference value instantaneously in memory. | SystemVerilog DPI-C |
| **4. Log Analytics** | `sim/parse_results.py` | Sanitizes the simulator console stream, performing cycle-to-cycle bitfield assertions and identifying logic bugs. | Regex Log Analysis |

---

## Directory Structure

```text
├── rtl/
│   └── twostage_pipelined_ALU.v   # RTL Design
├── tb/
│   ├── tb_pipelined_alu.sv        # SystemVerilog Testbench Scoreboard
│   └── c_alu_reference.cpp        # C++ DPI-C Reference Engine
├── sim/
│   ├── generate_stimulus.py       # Test vector generator
│   └── parse_results.py           # Verification log parser
└── .gitignore                     # Excludes temporary Vivado compiler junk 
```
## Example Verification Output
```
==================================================
        ALU PIPELINE POST-SIMULATION REPORT       
==================================================
--------------------------------------------------
Total Cycles Simulated : 96
Successful Matches     : 96
Detected Mismatches    : 0
==================================================
✔ VERIFICATION PASSED: Hardware perfectly matches C++ Reference Model!

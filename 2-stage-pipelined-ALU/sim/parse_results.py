import re
import sys

def parse_vivado_log(log_path="simulate.log"):
    mismatches = 0
    matches = 0
    total_cycles = 0

    print("\n" + "="*50)
    print("        ALU PIPELINE POST-SIMULATION REPORT       ")
    print("="*50)

    try:
        with open(log_path, "r") as file:
            for line in file:
                clean_line = line.strip()
                
                # Track total execution cycles based on log prints
                if "CHECKING RTL" in clean_line.upper():
                    total_cycles += 1
                
                # Check for critical errors or mismatches (case-insensitive search)
                if "CRITICAL ERROR" in clean_line.upper() or "MISMATCH" in clean_line.upper():
                    mismatches += 1
                    print(f"\033[91m[HAZARD/ERROR]\033[0m {clean_line}")
                
                # Check for successful matches (case-insensitive search)
                elif "MATCH!" in clean_line.upper() or "SUCCESSFULLY VERIFIED" in clean_line.upper():
                    # If it's a cycle match line, count it toward successful matches
                    if "CHECKING RTL" in clean_line.upper():
                        matches += 1

        print("-"*50)
        print(f"Total Cycles Simulated : {total_cycles}")
        print(f"Successful Matches     : \033[92m{matches}\033[0m")
        print(f"Detected Mismatches    : \033[91m{mismatches}\033[0m")
        print("="*50)

        if mismatches == 0 and total_cycles > 0:
            print("\033[92m✔ VERIFICATION PASSED: Hardware perfectly matches C++ Reference Model!\033[0m\n")
        elif total_cycles == 0:
            print("\033[93m⚠ WARNING: No simulation cycles were logged. Check if your testbench actually ran.\033[0m\n")
        else:
            print("\033[91m✘ VERIFICATION FAILED: Fix pipeline registers/timing mismatches.\033[0m\n")

    except FileNotFoundError:
        print(f"Error: Could not find Vivado log file at '{log_path}'")
        print("Please double check your simulation path folder structure.")

if __name__ == "__main__":
    # If a custom log path is provided as an argument from the terminal, use it
    path = sys.argv[1] if len(sys.argv) > 1 else "simulate.log"
    parse_vivado_log(path)

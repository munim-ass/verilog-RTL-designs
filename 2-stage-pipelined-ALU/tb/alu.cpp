#include <iostream>
#include <cstdint>

extern "C" {
    // Bit-accurate C++ function matching your Verilog operations
    int32_t c_alu_reference(int32_t a, int32_t b, uint8_t op) {
        switch(op) {
            case 0: return a + b;                       // ADD
            case 1: return a - b;                       // SUB
            case 2: return a & b;                       // AND
            case 3: return a | b;                       // OR
            case 4: return a ^ b;                       // XOR
            case 5: return a << (b & 0x1F);             // SLL (Shift Left Logical)
            default: return 0;
        }
    }
}

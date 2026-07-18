import random

def generate_test_vectors(filename="stimulus.txt", num_tests=100):
    # Opcode mappings: 0=ADD, 1=SUB, 2=AND, 3=OR, 4=XOR, etc.
    opcodes = [0, 1, 2, 3, 4] 
    
    with open(filename, "w") as f:
        # Generate some specific edge-case tests first
        edge_cases = [
            (0, 0, 0),                       # Zeroes
            (0xFFFFFFFF, 1, 0),              # Overflow ADD
            (0x00000000, 1, 1),              # Underflow SUB
            (0xAAAAAAAA, 0x55555555, 2),     # Alternating bitwise AND
            (0xFFFFFFFF, 0x00000000, 4),     # XOR maximums
        ]
        
        for a, b, op in edge_cases:
            f.write(f"{a:08x} {b:08x} {op:02x}\n")
            
        # Generate remaining random tests
        for _ in range(num_tests - len(edge_cases)):
            a = random.randint(0, 0xFFFFFFFF)
            b = random.randint(0, 0xFFFFFFFF)
            op = random.choice(opcodes)
            f.write(f"{a:08x} {b:08x} {op:02x}\n")

    print(f"Successfully generated {num_tests} test vectors in '{filename}'!")

if __name__ == "__main__":
    generate_test_vectors()

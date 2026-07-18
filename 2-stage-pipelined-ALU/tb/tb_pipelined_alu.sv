`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_pipelined_alu
// Description: Updated to read stimulus from python generated file (stimulus.txt)
//              while maintaining the C++ DPI-C verification model.
//////////////////////////////////////////////////////////////////////////////////

module tb_pipelined_alu;

    // Inputs
    reg clk;
    reg rst_n;
    reg [31:0] in_a;
    reg [31:0] in_b;
    reg [2:0]  op;

    // Outputs
    wire [31:0] alu_out;

    // Import the C++ reference model via DPI-C
    import "DPI-C" function int c_alu_reference(input int a, input int b, input byte op);

    // Queue to hold expected results across the 2-cycle latency
    int expected_queue[$];
    int match_count = 0;

    // File I/O Variables
    int file_handler;
    reg [31:0] temp_a;
    reg [31:0] temp_b;
    reg [7:0]  temp_op;

    // Instantiate the Unit Under Test (UUT)
    twostage_pipelined_ALU uut (
        .clk(clk),
        .rst_n(rst_n),
        .in_a(in_a),
        .in_b(in_b),
        .op(op),
        .alu_out(alu_out)
    );

    // Clock generator (100MHz)
    always #5 clk = ~clk;

    // Main Stimulus Loop (File Reading)
    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;
        in_a = 0;
        in_b = 0;
        op = 0;

        // Open the generated stimulus file
        file_handler = $fopen("C:/Verilog/2_stage_pipelined_ALU/stimulus.txt", "r");
        if (file_handler == 0) begin
            $display("[FATAL ERROR] Failed to open stimulus.txt! Did you run generate_stimulus.py first?");
            $finish;
        end

        // Apply Reset
        #15;
        rst_n = 1;
        @(posedge clk);

        // Read vectors from stimulus.txt line-by-line on every clock cycle
        while (!$feof(file_handler)) begin
            @(negedge clk); // Drive inputs cleanly on negative edge to satisfy setup time
            if ($fscanf(file_handler, "%h %h %h\n", temp_a, temp_b, temp_op) == 3) begin
                in_a = temp_a;
                in_b = temp_b;
                op   = temp_op[2:0]; // Match the 3-bit port size of RTL

                // Calculate the expected value immediately and store it in our tracking queue
                expected_queue.push_back(c_alu_reference(in_a, in_b, op));
            end
        end

        // Close the file handle
        $fclose(file_handler);

        // Wait for final computations to clear out of the pipeline stages
        repeat (5) @(posedge clk);
        
        $display("--- SIMULATION PASSED ---");
        $display("Successfully verified %0d operations with 0 mismatches.", match_count);
        $finish;
    end

    // Scoreboard: Check output on every rising edge of the clock
    int pipeline_cycles = 0;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            pipeline_cycles <= 0;
        end else begin
            pipeline_cycles <= pipeline_cycles + 1;

            // The ALU takes exactly 2 cycles to populate the final output ports
            if (pipeline_cycles >= 3) begin
                int golden_value;
                
                if (expected_queue.size() > 0) begin
                    golden_value = expected_queue.pop_front();
                    
                    // Display current comparison details
                    $display("[Cycle %0d] Checking RTL Out: 32'h%h | C++ Model: 32'h%h", 
                               pipeline_cycles, alu_out, 32'(golden_value));
                    
                    // To this (forces both sides to be unsigned 32-bit values):
                     if (alu_out !== 32'(golden_value)) begin
                        $display("[Cycle %0d] Checking RTL Out: 32'h%h | C++ Model: 32'h%h", 
                                pipeline_cycles, alu_out, 32'(golden_value));
                        $finish;
                    end
                    match_count++;
                end
            end
        end
    end

endmodule

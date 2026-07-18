`timescale 1ns / 1ps

module up_down_counter_tb;

reg clk;
reg reset;
reg enable;
reg dir;
wire [3:0] count;

// Instantiate your counter
up_down_counter uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .dir(dir),
    .count(count)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    reset = 1;
    enable = 0;
    dir = 1;

    // Release reset
    #20;
    reset = 0;

    // Enable UP counting
    enable = 1;
    dir = 1;
    #160;

    // Switch to DOWN counting
    dir = 0;
    #160;

    // Disable counting
    enable = 0;
    #50;

    // Apply reset again
    reset = 1;
    #20;
    reset = 0;

    #50;
    $stop;
end

// Monitor values
initial begin
    $monitor("Time=%0t | reset=%b enable=%b dir=%b count=%b",
              $time, reset, enable, dir, count);
end

endmodule

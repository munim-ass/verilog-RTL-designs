`timescale 1ns / 1ps

module counter_top(
    input  wire clk,           // 100MHz clock from Zedboard
    input  wire reset_btn,     // pushbutton for reset (raw input)
    input  wire start_stop_btn,// pushbutton for start/stop (raw input)
    input  wire up_down_sw,    // up/down control (raw input)

//    output wire [6:0] seg    // Segment outputs for 7-segment 
   output wire [3:0] led
);

// ================= CLOCK DI VIDER ==================
wire clk_div;
clock_divider #(.DIVIDER(100000000)) clkdiv_inst (
    .clk_in(clk),
    .reset(reset_btn),
    .clk_out(clk_div)
);

// ================= DEBOUNCE MODULES ==============
wire reset_clean, start_stop_clean, up_down_clean;
debounce #(.N(50)) db_reset (
    .clk(clk),
    .reset(1'b0),
    .button_in(reset_btn),
    .button_out(reset_clean)
);
debounce #(.N(50)) db_startstop (
    .clk(clk),
    .reset(1'b0),
    .button_in(start_stop_btn),
    .button_out(start_stop_clean)
);
debounce #(.N(50)) db_updown (
    .clk(clk),
    .reset(1'b0),
    .button_in(up_down_sw),
    .button_out(up_down_clean)
);

// ================= FSM CONTROLLER ================
wire enable_cnt, dir;
counter_fsm fsm_inst (
    .clk(clk),
    .reset(reset_clean),
    .start_stop_btn(start_stop_clean),
    .up_down_sw(up_down_clean),
    .enable_cnt(enable_cnt),
    .dir(dir)
);

// ================= COUNTER MODULE ================
wire [3:0] count;
up_down_counter cnt_inst (
    .clk(clk_div),        // Use divided clock so count is visible
    .reset(reset_clean),
    .enable(enable_cnt),
    .dir(dir),
    .count(count)
);

//// ============= 7-SEGMENT DECODER MODULE ==========
//seven_seg_decoder seg7_inst (
//    .bin_in(count),
//    .seg(seg)
//);

assign led = count;

endmodule


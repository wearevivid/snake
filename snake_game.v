//==============================================================
// Snake Game for Nandland Go Board (Lattice iCE40HX1K)
// Full VGA 640x480 @ 60 Hz | 3 Colors | Speed Increases | Score Display
//==============================================================

module snake_game(
    input clk_12mhz,          // 12 MHz system clock
    input btnU, btnD, btnL, btnR, // directional buttons
    input rst,                // reset button
    output hsync, vsync,      // VGA sync outputs
    output [2:0] rgb,         // VGA color output (3-bit)
    output [6:0] seg,         // seven-segment segments
    output [3:0] an           // seven-segment digit enable
);

    //==========================================================
    // CLOCK DIVIDERS
    //==========================================================
    wire pix_clk;
    wire game_tick;
    clock_divider #(.DIVISOR(2)) pixclk_div (.clk_in(clk_12mhz), .clk_out(pix_clk)); // ~6 MHz pixel clock
    clock_divider #(.DIVISOR(10_000_000)) gameclk_div (.clk_in(clk_12mhz), .clk_out(game_tick)); // ~1.2Hz start, variable speed later

    //==========================================================
    // VGA SIGNAL GENERATOR
    //==========================================================
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_on;
    vga_sync vga_gen(
        .clk(pix_clk),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    //==========================================================
    // SNAKE LOGIC
    //==========================================================
    wire [7:0] score;
    wire [2:0] pixel_color;

    snake_logic snake_core(
        .clk(clk_12mhz),
        .tick(game_tick),
        .reset(rst),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .x(pixel_x),
        .y(pixel_y),
        .active(video_on),
        .color(pixel_color),
        .score(score)
    );

    //==========================================================
    // SEVEN SEGMENT SCORE DISPLAY
    //==========================================================
    seven_seg seg_disp(
        .clk(clk_12mhz),
        .score(score),
        .seg(seg),
        .an(an)
    );

    //==========================================================
    // VGA COLOR OUTPUT
    //==========================================================
    assign rgb = video_on ? pixel_color : 3'b000;

endmodule

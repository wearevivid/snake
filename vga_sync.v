//==============================================================
// vga_sync.v
// 640x480 @ 60Hz VGA timing generator for Nandland Go Board
//==============================================================

module vga_sync(
    input clk,
    output reg hsync,
    output reg vsync,
    output reg video_on,
    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y
);

    // VGA 640x480 @60Hz timing constants
    localparam HD = 640;  // horizontal display area
    localparam HF = 16;   // horizontal front porch
    localparam HS = 96;   // horizontal sync pulse
    localparam HB = 48;   // horizontal back porch
    localparam HT = HD + HF + HS + HB; // total = 800

    localparam VD = 480;  // vertical display area
    localparam VF = 10;   // vertical front porch
    localparam VS = 2;    // vertical sync pulse
    localparam VB = 33;   // vertical back porch
    localparam VT = VD + VF + VS + VB; // total = 525

    // Counters
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Horizontal counter
    always @(posedge clk) begin
        if (h_count == HT - 1) begin
            h_count <= 0;
            if (v_count == VT - 1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end else begin
            h_count <= h_count + 1;
        end
    end

    // Generate sync pulses
    always @(*) begin
        hsync = ~(h_count >= (HD + HF) && h_count < (HD + HF + HS));
        vsync = ~(v_count >= (VD + VF) && v_count < (VD + VF + VS));
    end

    // Visible region
    always @(*) begin
        video_on = (h_count < HD && v_count < VD);
        pixel_x  = h_count;
        pixel_y  = v_count;
    end

endmodule

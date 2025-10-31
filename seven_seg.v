//==============================================================
// seven_seg.v
// Dual 7-segment score display for Nandland Go Board
//==============================================================

module seven_seg(
    input clk,
    input [7:0] score,
    output reg [6:0] seg,
    output reg [3:0] an
);

    //==========================================================
    // SPLIT SCORE INTO DIGITS
    //==========================================================
    wire [3:0] tens = (score / 10) % 10;
    wire [3:0] ones = score % 10;

    //==========================================================
    // SCAN COUNTER FOR MULTIPLEXING
    //==========================================================
    reg [15:0] refresh_counter = 0;
    always @(posedge clk)
        refresh_counter <= refresh_counter + 1;

    wire [1:0] scan_sel = refresh_counter[15:14];

    //==========================================================
    // DECODER FUNCTION
    //==========================================================
    function [6:0] decode7seg;
        input [3:0] digit;
        case (digit)
            4'd0: decode7seg = 7'b1000000;
            4'd1: decode7seg = 7'b1111001;
            4'd2: decode7seg = 7'b0100100;
            4'd3: decode7seg = 7'b0110000;
            4'd4: decode7seg = 7'b0011001;
            4'd5: decode7seg = 7'b0010010;
            4'd6: decode7seg = 7'b0000010;
            4'd7: decode7seg = 7'b1111000;
            4'd8: decode7seg = 7'b0000000;
            4'd9: decode7seg = 7'b0010000;
            default: decode7seg = 7'b1111111; // blank
        endcase
    endfunction

    //==========================================================
    // DISPLAY MULTIPLEXER
    //==========================================================
    always @(*) begin
        case (scan_sel)
            2'b00: begin
                seg = decode7seg(ones);
                an = 4'b1110; // enable rightmost digit
            end
            2'b01: begin
                seg = decode7seg(tens);
                an = 4'b1101; // enable left digit
            end
            default: begin
                seg = 7'b1111111;
                an = 4'b1111;
            end
        endcase
    end

endmodule

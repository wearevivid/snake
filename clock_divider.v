//==============================================================
// clock_divider.v
// Generic clock divider for Nandland Go Board projects
//==============================================================

module clock_divider #(
    parameter DIVISOR = 2        // divide-by value (must be >1)
)(
    input clk_in,
    output reg clk_out
);

    // Counter size automatically scales with DIVISOR
    localparam WIDTH = $clog2(DIVISOR);
    reg [WIDTH-1:0] counter = 0;

    always @(posedge clk_in) begin
        if (counter == DIVISOR-1) begin
            counter <= 0;
            clk_out <= ~clk_out;  // toggle output every DIVISOR cycles
        end else begin
            counter <= counter + 1;
        end
    end

endmodule

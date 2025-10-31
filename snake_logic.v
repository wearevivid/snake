//==============================================================
// snake_logic.v
// Core game logic for Snake (VGA Version, 3-color, Nandland Go Board)
//==============================================================

module snake_logic(
    input clk,
    input tick,
    input reset,
    input btnU, btnD, btnL, btnR,
    input [9:0] x,
    input [9:0] y,
    input active,
    output reg [2:0] color,
    output reg [7:0] score
);

    //==========================================================
    // GAME PARAMETERS
    //==========================================================
    localparam GRID_W = 32;   // 32 horizontal cells
    localparam GRID_H = 24;   // 24 vertical cells
    localparam CELL_W = 20;   // pixels per cell horizontally
    localparam CELL_H = 20;   // pixels per cell vertically

    // Colors (3-bit RGB)
    localparam COLOR_BG    = 3'b001; // deep blue background
    localparam COLOR_SNAKE = 3'b010; // lime green snake
    localparam COLOR_FOOD  = 3'b101; // hot pink food

    //==========================================================
    // STATE REGISTERS
    //==========================================================
    reg [5:0] snake_x [0:63];
    reg [5:0] snake_y [0:63];
    reg [5:0] length;
    reg [1:0] dir;  // 0=up,1=right,2=down,3=left
    reg [5:0] food_x;
    reg [5:0] food_y;
    reg [31:0] speed_div;
    reg [31:0] speed_counter;

    integer i;

    //==========================================================
    // INITIALIZATION
    //==========================================================
    initial begin
        length <= 4;
        dir <= 1;
        score <= 0;
        food_x <= 10;
        food_y <= 10;
        speed_div <= 10_000_000; // starting slow
    end

    //==========================================================
    // INPUT HANDLING (change direction)
    //==========================================================
    always @(posedge clk) begin
        if (btnU && dir != 2) dir <= 0;
        else if (btnR && dir != 3) dir <= 1;
        else if (btnD && dir != 0) dir <= 2;
        else if (btnL && dir != 1) dir <= 3;
    end

    //==========================================================
    // MAIN GAME TICK
    //==========================================================
    always @(posedge tick or posedge reset) begin
        if (reset) begin
            length <= 4;
            dir <= 1;
            score <= 0;
            food_x <= 10;
            food_y <= 10;
            speed_div <= 10_000_000;
        end else begin
            // move body
            for (i = length; i > 0; i = i - 1) begin
                snake_x[i] <= snake_x[i-1];
                snake_y[i] <= snake_y[i-1];
            end

            // move head
            case (dir)
                0: snake_y[0] <= (snake_y[0] == 0) ? GRID_H-1 : snake_y[0] - 1;
                1: snake_x[0] <= (snake_x[0] == GRID_W-1) ? 0 : snake_x[0] + 1;
                2: snake_y[0] <= (snake_y[0] == GRID_H-1) ? 0 : snake_y[0] + 1;
                3: snake_x[0] <= (snake_x[0] == 0) ? GRID_W-1 : snake_x[0] - 1;
            endcase

            // check for food collision
            if (snake_x[0] == food_x && snake_y[0] == food_y) begin
                length <= length + 1;
                score <= score + 1;
                food_x <= (food_x + 7) % GRID_W;
                food_y <= (food_y + 5) % GRID_H;

                // speed up slightly
                if (speed_div > 1_000_000)
                    speed_div <= speed_div - 500_000;
            end
        end
    end

    //==========================================================
    // RENDERING LOGIC
    //==========================================================
    reg hit_snake;
    always @(*) begin
        hit_snake = 0;
        for (i = 0; i < length; i = i + 1)
            if ((x / CELL_W) == snake_x[i] && (y / CELL_H) == snake_y[i])
                hit_snake = 1;
    end

    wire hit_food = ((x / CELL_W) == food_x) && ((y / CELL_H) == food_y);

    always @(*) begin
        if (!active)
            color = 3'b000;
        else if (hit_snake)
            color = COLOR_SNAKE;
        else if (hit_food)
            color = COLOR_FOOD;
        else
            color = COLOR_BG;
    end

endmodule

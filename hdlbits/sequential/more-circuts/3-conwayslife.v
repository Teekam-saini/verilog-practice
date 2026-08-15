module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Map 1D vector to a 2D grid for easier indexing: [row][col]
    reg [15:0][15:0] grid;
    reg [15:0][15:0] next_grid;
    
    integer r, c;
    integer i, j;
    integer neighbors;

    // Unpack q into 2D grid or handle synchronous load/update
    always @(posedge clk) begin
        if (load) begin
            for (r = 0; r < 16; r = r + 1)
                for (c = 0; c < 16; c = c + 1)
                    grid[r][c] <= data[r * 16 + c];
        end else begin
            grid <= next_grid;
        end
    end

    // Compute next state for every cell with toroidal wrapping
    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                neighbors = 0;
                
                // Sum up the 8 neighbors using modulo 16 arithmetic for toroidal wrap
                for (i = -1; i <= 1; i = i + 1) begin
                    for (j = -1; j <= 1; j = j + 1) begin
                        if (!(i == 0 && j == 0)) begin
                            neighbors = neighbors + grid[(r + i + 16) % 16][(c + j + 16) % 16];
                        end
                    end
                end
                
                // Apply Conway's rules
                if (neighbors == 3)
                    next_grid[r][c] = 1'b1;
                else if (neighbors == 2)
                    next_grid[r][c] = grid[r][c];
                else
                    next_grid[r][c] = 1'b0;
            end
        end
    end

    // Pack 2D grid back into the 1D output vector q
    always @* begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                q[r * 16 + c] = grid[r][c];
            end
        end
    end

endmodule
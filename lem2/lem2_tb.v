`timescale 1ns/1ps

module tb_top_module();

    // Inputs
    reg clk;
    reg areset;
    reg bump_left;
    reg bump_right;
	reg ground;

    // Outputs
    wire walk_left;
    wire walk_right;
    wire fall;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .areset(areset),
        .bump_left(bump_left),
        .bump_right(bump_right),
        .ground(ground),
        .walk_left(walk_left),
        .walk_right(walk_right),
        .aaah(fall) 
    );
 

    // Clock generation: toggle every 5 ns -> 10 ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        areset = 0;
        bump_left = 0;
        bump_right = 0;
        ground = 1;

        // Apply asynchronous reset
        #2 areset = 1;
        #5 areset = 0;

        // Initial state after reset: walk left
        #10;

        // Case 1: walking left, no bump
        $display("Time=%0t: walk_left=%b, walk_right=%b", $time, walk_left, walk_right);
        #10;

        // Case 2: bump on left -> should turn right
        bump_left = 1;
        #10 bump_left = 0;
        #10;

        $display("Time=%0t: walk_left=%b, walk_right=%b", $time, walk_left, walk_right);

        // Case 3: walking right, ground disappears -> should fall (aaah=1)
        ground = 0; #10;

        // Case 4: while falling, bump signals shouldn't matter
        bump_right = 1; bump_left = 1;
        #10;
        bump_right = 0; bump_left = 0;
        #10;

        // Case 5: ground reappears -> resume walking right (same as before fall)
        ground = 1; #10;

        // Case 6: bump on right -> should now walk left
        bump_right = 1; #10; bump_right = 0;
        #10;

        // Case 7: ground disappears again -> should fall (aaah=1)
        ground = 0; #10;

        // Case 8: while falling, apply reset -> should resume walking left
        areset = 1; #5; areset = 0;
        ground = 1; #10;

        // End simulation
        #20;
        $finish;
    end

    // Monitor all signals continuously
    initial begin
        $monitor("T=%0t | areset=%b bumpL=%b bumpR=%b | walk_left=%b walk_right=%b", 
                 $time, areset, bump_left, bump_right, walk_left, walk_right);
       $dumpfile("lem1_tb");
      $dumpvars(0,clk,areset,bump_left,walk_left,bump_right,walk_right,ground,fall);
    end

endmodule

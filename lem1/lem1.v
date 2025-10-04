module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    parameter L=0, R=1;
    reg state, next_state;

    always @(*) begin
        case(state)
            L:next_state = bump_left?R:L;
            R:next_state = bump_right?L:R;
        endcase// State transition logic
    end

    always @(posedge clk, posedge areset) begin
        state = areset?L:next_state;// State flip-flops with asynchronous reset
    end

    // Output logic
    assign walk_left = (state == L);
    assign walk_right = (state == R);

endmodule

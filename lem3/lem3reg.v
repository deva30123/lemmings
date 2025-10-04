module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    parameter L=0, R=1,LF=2,RF=3,DL=4,DR=5;
    reg [2:0]state, next_state;
    always @(*) begin       
            case(state)
                L:next_state = ground?(dig?DL:(bump_left?R:L)):LF;
                R:next_state = ground?(dig?DR:(bump_right?L:R)):RF;
                LF:next_state = ground?L:LF;
                RF:next_state = ground?R:RF;
                DL:next_state = ground?DL:LF;
                DR:next_state = ground?DR:RF;
            endcase// State transition logic 
    end

    always @(posedge clk, posedge areset) begin
        state = areset?L:next_state;// State flip-flops with asynchronous reset
    end
    // Output logic
    assign walk_left = (state==L);
    assign walk_right = (state==R);
    assign aaah = (state[1]==1'b1);
    assign digging = state[2];

endmodule

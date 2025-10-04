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
    parameter L=0, R=1;
    reg [2:0]state, next_state;
    always @(*) begin
         if(next_state[1]==0)begin
            next_state[2]<=state[1]?0:(dig?1:state[2]);
            if(next_state[2]==0)begin
                case(state)
                    L:next_state[0] <= (bump_left?R:L);
                    R:next_state[0] <= (bump_right?L:R);           
                endcase// State transition logic
            end
            else  next_state[0] <= state[0];
        end
        else begin
            next_state[0] <= state[0];
            next_state[2] <= 0 ;  
        end
        next_state[1]<=~ground;
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

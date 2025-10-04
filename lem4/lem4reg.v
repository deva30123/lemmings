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
    reg [7:0] count;
     parameter L=0, R=1,LF=2,RF=3,DL=4,DR=5,X=6;
    reg [3:0]state, next_state;//{death,dig,fall,direction}
    always @(*) begin       
            case(state)
                L:next_state = ground?(dig?DL:(bump_left?R:L)):LF;
                R:next_state = ground?(dig?DR:(bump_right?L:R)):RF;
                LF:next_state = (ground?((count>20)?X:L):LF);
                RF:next_state = (ground?((count>20)?X:R):RF);
                DL:next_state = ground?DL:LF;
                DR:next_state = ground?DR:RF;
                X:next_state = X;
            endcase// State transition logic 
    end
    always @(posedge clk, posedge areset) begin
        count = areset?0:(ground?0:count+1);
        state = areset?L:next_state;// State flip-flops with asynchronous reset
    end
    // Output logic
     assign walk_left = (state==L);
    assign walk_right = (state==R);
    assign aaah = (state[1]==1'b1)&(~state[3]);
    assign digging = state[2]&(~state[3]);

endmodule

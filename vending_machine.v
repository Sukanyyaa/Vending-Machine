module vending_machine(can_despatch,clk,coin,rst);
output can_despatch;               // Output: Indicates if an item can be dispensed
input [1:0] coin;                  // Input: 2-bit coin value (00=0 rupees, 01=5 rupees, 10=10 rupees)
input clk, rst;                    // Input: Clock and reset signals
reg [1:0] state;                   // Register to hold the current state
reg [1:0] next_state;              // Register to hold the next state
parameter s0=0;                    // Parameter for state 0 (0 rupees)
parameter s5=1;                    // Parameter for state 5 (5 rupees)
parameter s10=2;                   // Parameter for state 10 (10 rupees)
parameter s15=3;                   // Parameter for state 15 (15 rupees)

always @(posedge clk)              // On every clock's positive edge
begin
    if (rst)                       // If reset is high
        state = s0;                // Initialize state to s0
    else
        state = next_state;        // Update state to next_state
end

always @(state,coin)               // Combinational block for next state logic
begin
    case (state)
        s0: begin                  // State s0 (0 rupees)
            if (coin == 2'b00)     // If coin is 0 rupees
                next_state = s0;   // Stay in s0
            else if (coin == 2'b01) // If coin is 5 rupees
                next_state = s5;   // Move to state s5
            else if (coin == 2'b10) // If coin is 10 rupees
                next_state = s10;  // Move to state s10
        end
        s5: begin                  // State s5 (5 rupees)
            if (coin == 2'b00)     // If coin is 0 rupees
                next_state = s5;   // Stay in s5
            else if (coin == 2'b01) // If coin is 5 rupees
                next_state = s10;  // Move to state s10
            else if (coin == 2'b10) // If coin is 10 rupees
                next_state = s15;  // Move to state s15
        end
        s10: begin                 // State s10 (10 rupees)
            if (coin == 2'b00)     // If coin is 0 rupees
                next_state = s10;  // Stay in s10
            else if (coin == 2'b01) // If coin is 5 rupees
                next_state = s15;  // Move to state s15
            else if (coin == 2'b10) // If coin is 10 rupees
                next_state = s15;  // Move to state s15
        end
        s15: begin                 // State s15 (15 rupees, ready to dispatch)
            if (coin == 2'b00)     // If coin is 0 rupees
                next_state = s0;   // Return to state s0 after dispatch
            else if (coin == 2'b01) // If coin is 5 rupees
                next_state = s5;   // Move to state s5
            else if (coin == 2'b10) // If coin is 10 rupees
                next_state = s10;  // Move to state s10
        end
        default: next_state = s0;  // Default state to s0 for undefined cases
    endcase
end

assign can_despatch = (state == s15) ? 1 : 0; // Set can_despatch to 1 if in state s15 (ready to dispatch)
endmodule

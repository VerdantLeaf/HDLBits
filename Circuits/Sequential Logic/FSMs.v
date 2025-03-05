// fsm1:
module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        // State transition logic
        case (state)
            A : begin 
                next_state = in ? A : B;
            end
            B: begin
                next_state = in ? B : A;
            end
        endcase
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if(areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic
    // assign out = (state == ...);
    assign out = (state ? B :A); 

endmodule

//fsm1s:
// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
     parameter A=0, B=1; 
    reg present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin  
            // Fill in reset logic
            present_state <= B;
            out <= 1;
        end else begin
            case (present_state)
                // Fill in state transition logic
                A : next_state = in ? A : B;
                B : next_state = in ? B : A;
            endcase

            // State flip-flops
            present_state = next_state;   

            case (present_state)
                // Fill in output logic
                A : out = 1'b0;
                B : out = 1'b1;
            endcase
        end
    end

endmodule

// fsm2:
module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        // State transition logic
        if(state == OFF)
        	next_state = j ? ON : OFF;
        else if(state == ON)
            next_state = k ? OFF : ON;
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin
            state <= OFF;
        end
        else
            state = next_state;
    end
    

    // Output logic
    assign out = (state == ON) ? ON : OFF;

endmodule

// fsm2s:
module top_module(
    input clk,
    input reset,    // Synchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        // State transition logic
        if(state == OFF)
        	next_state = j ? ON : OFF;
        else if(state == ON)
            next_state = k ? OFF : ON;
    end

    always @(posedge clk) begin // the only difference...
        // State flip-flops with synchronous reset
        if(reset) begin
            state <= OFF;
        end
        else
            state = next_state;
            
    end

    // Output logic
    assign out = (state == ON) ? ON : OFF;

endmodule

// fsm3comb:
module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: next_state = f(state, in)
    always @(*) begin
        if(in)
            next_state = (state == C) ? D : B;
        else
            next_state = (state == A || state == C) ? A : C;
    end

    // Output logic:  out = f(state) for a Moore state machine
    assign out = (state == D) ? 1 : 0;
    
endmodule

//
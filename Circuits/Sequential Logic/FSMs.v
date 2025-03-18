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

// fsm3onehot
module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
  );

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: Derive an equation for each state flip-flop.
    assign next_state[A] = (state[A] & ~in) | (state[C] & ~in);  
    assign next_state[B] = (state[A] & in) | (state[B] & in) | (state[D] & in);
    assign next_state[C] = (state[B] & ~in) | (state[D] & ~in);
    assign next_state[D] = state[C] & in;

    // Output logic: 
    assign out = (state[D]);

endmodule

// fsm3
module top_module(
    input clk,
    input in,
    input areset,
    output out
  );
	
    reg [2:0] state, next_state;
    parameter A = 1, B = 2, C = 3, D = 4;
    
    // State transition logic
    always @(*) begin
        case(state)
            A : next_state = (in == 1) ? B : A;
            B : next_state = (in == 1) ? B : C;
            C : next_state = (in == 1) ? D : A;
            D : next_state = (in == 1) ? B : C;
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if(areset) state <= A;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule

// fsm3s
module top_module(
    input clk,
    input in,
    input reset,
    output out
  );
	
    reg [2:0] state, next_state;
    parameter A = 1, B = 2, C = 3, D = 4;
    
    // State transition logic
    always @(*) begin
        case(state)
            A : next_state = (in == 1) ? B : A;
            B : next_state = (in == 1) ? B : C;
            C : next_state = (in == 1) ? D : A;
            D : next_state = (in == 1) ? B : C;
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk) begin
        if(reset) state <= A;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule

// Design a moore FSM
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 

	localparam [2:0] A  = 3'd0,	//water level:below s1    
					 B0 = 3'd1,	//s1~s2, and previous level is higher
					 B1 = 3'd2,	//s1~s2, and previous level is lower
					 C0 = 3'd3,	//s2~s3, and previous level is higher
					 C1 = 3'd4,	//s2~s3, and previous level is lower
					 D  = 3'd5;	//above s3

	reg [2:0] state, next_state;

	always @(posedge clk) begin
		if(reset) state <= A;
		else state <= next_state;
	end

	always @(*) begin
		case(state)
			A 	:	next_state = (s[1]) ? B1 : A;
			B0 	: 	next_state = (s[2]) ? C1 : ((s[1]) ? B0 : A);
			B1	:	next_state = (s[2]) ? C1 : ((s[1]) ? B1 : A);
			C0	:	next_state = (s[3]) ? D  : ((s[2]) ? C0 : B0);
			C1	:	next_state = (s[3]) ? D  : ((s[2]) ? C1 : B0);
			D 	:	next_state = (s[3]) ? D  : C0;
			default : next_state = 3'bxxx;
		endcase
	end

	always @(*) begin
		case(state)
			A  : {fr3, fr2, fr1, dfr} = 4'b1111;
			B0 : {fr3, fr2, fr1, dfr} = 4'b0111;
			B1 : {fr3, fr2, fr1, dfr} = 4'b0110;
			C0 : {fr3, fr2, fr1, dfr} = 4'b0011;
			C1 : {fr3, fr2, fr1, dfr} = 4'b0010;
			D  : {fr3, fr2, fr1, dfr} = 4'b0000;
			default : {fr3, fr2, fr1, dfr} = 4'bxxxx;
		endcase
	end


endmodule
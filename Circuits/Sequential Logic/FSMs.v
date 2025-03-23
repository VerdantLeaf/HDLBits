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

// Lemmings1:
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    parameter LEFT = 0, RIGHT = 1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case(state)
            LEFT : next_state = (bump_left) ? RIGHT : LEFT;
            RIGHT : next_state = (bump_right) ? LEFT : RIGHT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) state <= LEFT;
        else state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule

// Lemmings2:
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    
    parameter [1:0] L_WALK = 2'b00, R_WALK = 2'b01, L_FALL = 2'b10, R_FALL = 2'b11;
    reg [1:0] state, next;
    
    always @(*) begin
        // State transition logic
        case(state)
            L_WALK : next = (ground == 0) ? L_FALL : ((bump_left == 1) ? R_WALK : L_WALK); 
            L_FALL : next = (ground == 1) ? L_WALK : L_FALL;
            R_WALK : next = (ground == 0) ? R_FALL : ((bump_right == 1) ? L_WALK : R_WALK);
            R_FALL : next = (ground == 1) ? R_WALK : R_FALL;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) state <= L_WALK;
        else state <= next;
    end
    // Output logic
    assign walk_left = (state == L_WALK);
    assign walk_right = (state == R_WALK);
    assign aaah = ((state == R_FALL) || (state == L_FALL));
    
endmodule

// Lemmings3:
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
    
    // 6 states so we need 3 bits for all of the states
    parameter [2:0] L_WALK = 3'b000,
     				R_WALK = 3'b001,
    				L_FALL = 3'b010,
     				R_FALL = 3'b011,
    				L_DIG  = 3'b100,
     				R_DIG  = 3'b101;
    
    reg [2:0] state, next;
    
    always @(posedge clk or posedge areset) begin
        if(areset) state <= L_WALK;
        else state <= next;
    end
            
    always @(*) begin
        case(state)
            L_WALK : begin
                if(!ground) next = L_FALL;
                else begin
                    if(dig) next = L_DIG;
                    else begin
                        if(bump_left) next = R_WALK;
                        else next = L_WALK;
                    end
                end
            end
            R_WALK : begin
                 if(!ground) next = R_FALL;
                else begin
                    if(dig) next = R_DIG;
                    else begin
                        if(bump_right) next = L_WALK;
                        else next = R_WALK;
                    end
                end
            end
            L_FALL : next = (ground) ? L_WALK : L_FALL;
            R_FALL : next = (ground) ? R_WALK : R_FALL;
            L_DIG  : next = (ground) ? L_DIG : L_FALL;
            R_DIG  : next = (ground) ? R_DIG : R_FALL;
        endcase        
    end
    
    assign walk_left = (state == L_WALK);
    assign walk_right = (state == R_WALK);
    assign aaah = ((state == L_FALL) || (state == R_FALL));
    assign digging = ((state == L_DIG) || (state == R_DIG));
            
endmodule

// Lemmings4:
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
    
    // 7 states so we need 3 bits for all of the states
    parameter [2:0] L_WALK = 3'b000,
     				R_WALK = 3'b001,
    				L_FALL = 3'b010,
     				R_FALL = 3'b011,
    				L_DIG  = 3'b100,
     				R_DIG  = 3'b101,
    				SPLATTER = 3'b110;
    
    reg [2:0] state, next;
    reg [6:0] count;
    
    always @(posedge clk or posedge areset) begin
        if(areset) state <= L_WALK;
        else if(state == R_FALL || state == L_FALL) begin
            count <= count + 1;
            state <= next;
        end
        else begin
            state <= next;
            count <= 0;
        end
    end
            
    always @(*) begin
        case(state)
            L_WALK : begin
                if(!ground) next = L_FALL;
                else begin
                    if(dig) next = L_DIG;
                    else begin
                        if(bump_left) next = R_WALK;
                        else next = L_WALK;
                    end
                end
            end
            R_WALK : begin
                 if(!ground) next = R_FALL;
                else begin
                    if(dig) next = R_DIG;
                    else begin
                        if(bump_right) next = L_WALK;
                        else next = R_WALK;
                    end
                end
            end
            L_FALL : begin
                if(ground) begin
                    if(count > 19) next = SPLATTER;
                    else next = L_WALK;
                end
                else next = L_FALL;
            end
            R_FALL : begin
                if(ground) begin
                    if(count > 19) next = SPLATTER;
                    else next = R_WALK;
                end
                else next = R_FALL;
            end
            L_DIG  : next = (ground) ? L_DIG : L_FALL;
            R_DIG  : next = (ground) ? R_DIG : R_FALL;
            SPLATTER : next = SPLATTER;
        endcase        
    end
    
    assign walk_left = (state == L_WALK);
    assign walk_right = (state == R_WALK);
    assign aaah = ((state == L_FALL) || (state == R_FALL));
    assign digging = ((state == L_DIG) || (state == R_DIG));
            
endmodule

// OneHotFSM:
module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);

    localparam  S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4,
				S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

	//states
	assign next_state[S0] = (state[S0] & !in) | (state[S1] & !in) | (state[S2] & !in) | (state[S3] & !in) | 
							(state[S4] & !in) | (state[S7] & !in) | (state[S8] & !in) | (state[S9] & !in);
	assign next_state[S1] = (state[S0] & in) | (state[S8] & in) | (state[S9] & in);
	assign next_state[S2] = state[S1] & in;
	assign next_state[S3] = state[S2] & in;
	assign next_state[S4] = state[S3] & in;
	assign next_state[S5] = state[S4] & in;
	assign next_state[S6] = state[S5] & in;
	assign next_state[S7] = (state[S6] & in) | (state[7] & in);
	assign next_state[S8] = state[S5] & !in;
	assign next_state[S9] = state[S6] & !in;

	//output
	assign out1 = state[8] | state[9];
	assign out2 = state[7] | state[9];
    
endmodule

// FSM ps2:
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    parameter  [1:0] BYTE1 = 2'b00,
    				 BYTE2 = 2'b01,
    				 BYTE3 = 2'b10,
    				 DONE  = 2'b11;

    reg [1:0] state, next;

    // State transition logic (combinational)
    always @(*) begin
    	case(state)
    		BYTE1 : next = (in[3]) ? BYTE2 : BYTE1;
    		BYTE2 : next = BYTE3;
    		BYTE3 : next = DONE;
    		DONE  : next = (in[3]) ? BYTE2 : BYTE1;
    	endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
    	if(reset) state <= BYTE1;
    	else state <= next;
    end
 
    // Output logic
    assign done = (state == DONE);


endmodule

// Fsm ps2data:
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    parameter [1:0]  BYTE1 = 2'b00,
    				 BYTE2 = 2'b01,
    				 BYTE3 = 2'b10,
    				 DONE  = 2'b11;

    reg [1:0] state, next;
    reg [23:0] data;

    // State transition logic (combinational)
    always @(*) begin
    	case(state)
    		BYTE1 : next = (in[3]) ? BYTE2 : BYTE1;
    		BYTE2 : next = BYTE3;
    		BYTE3 : next = DONE;
    		DONE  : next = (in[3]) ? BYTE2 : BYTE1;
    	endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
    	if(reset) state <= BYTE1;
    	else state <= next;
    end
 
    // New: Datapath to store incoming bytes.
    always @(posedge clk) begin
    	if (reset) data <= 24'b0;
    	else data <= {data[15:8], data[7:0], in};
    end
    
    // Output logic
    assign done = (state == DONE);
    assign out_bytes = (done) ? data : 23'b0;

endmodule

// fsm_serial:
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter [2:0]  IDLE 	 = 3'b000,
					 START 	 = 3'b001,
					 RECEIVE = 3'b010,
					 WAIT	 = 3'b011,
					 STOP    = 3'b100;
    
	reg [2:0] state, next;
	reg [3:0] i;

	always @(*) begin
		case(state)
			IDLE  : next = (in) ? IDLE : START;
			START : next = RECEIVE;
			RECEIVE : begin
				if (i == 8) begin
					if (in) next = STOP;
					else next = WAIT;
				end 
				else next = RECEIVE;			
			end
			WAIT : next = (in) ? IDLE : WAIT;
			STOP : next = (in) ? IDLE : START;
		endcase
	end

	always @(posedge clk) begin
		if(reset) state <= IDLE;
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			i <= 0;
		end
		else begin
			case(next) 
				RECEIVE : begin
					done <= 0;
					i = i + 1;
				end
				STOP : begin
					done <= 1;
					i <= 0;
				end
				default : begin
					done <= 0;
					i <= 0;
				end
			endcase
		end
	end

    

endmodule

// fsm_serialdata:
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

     // Use FSM from Fsm_serial
    parameter [2:0]  IDLE 	 = 3'b000,
					 START 	 = 3'b001,
					 RECEIVE = 3'b010,
					 WAIT	 = 3'b011,
					 STOP    = 3'b100;

	reg [2:0] state, next;
	reg [3:0] i;
	reg [7:0] out;

	always @(*) begin
		case(state)
			IDLE  : next = (in) ? IDLE : START;
			START : next = RECEIVE;
			RECEIVE : begin
				if (i == 8) begin
					if (in) next = STOP;
					else next = WAIT;
				end 
				else next = RECEIVE;			
			end
			WAIT : next = (in) ? IDLE : WAIT;
			STOP : next = (in) ? IDLE : START;
		endcase
	end

	always @(posedge clk) begin
		if(reset) state <= IDLE;
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			i <= 0;
		end
		else begin
			case(next) 
				RECEIVE : begin
					done <= 0;
					i = i + 4'h1;
				end
				STOP : begin
					done <= 1;
					i <= 0;
				end
				default : begin
					done <= 0;
					i <= 0;
				end
			endcase
		end
	end

    // New: Datapath to latch input bits.
    always @(posedge clk) begin
    	if (reset) out <= 0;
    	else if (next == RECEIVE)
    		out[i] <= in;
    end

    assign out_byte = (done) ? out : 8'b0;

endmodule

// fsm_serialdp - ty to github folks for these. They were a bit challenging
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
    parameter [2:0]  IDLE 	 = 3'b000,
					 START 	 = 3'b001,
					 RECEIVE = 3'b010,
					 WAIT	 = 3'b011,
					 STOP    = 3'b100,
					 CHECK   = 3'b101;

	reg [2:0] state, next;
	reg [3:0] i;
	reg [7:0] out;
	reg odd_reset;
	reg odd_reg;
	wire odd;	
	

	always @(*) begin
		case(state)
			IDLE  	: next = (in) ? IDLE : START;
			START 	: next = RECEIVE;
			RECEIVE : next = (i == 8) ? CHECK : RECEIVE;
			CHECK 	: next = (in) ? STOP : WAIT;
			WAIT 	: next = (in) ? IDLE : WAIT;
			STOP 	: next = (in) ? IDLE : START;
		endcase
	end

	always @(posedge clk) begin
		if(reset) state <= IDLE;
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) begin
			i <= 0;
		end
		else begin
			case(next) 
				RECEIVE : begin
					i = i + 4'h1;
				end
				STOP : begin
					i <= 0;
				end
				default : begin
					i <= 0;
				end
			endcase
		end
	end

    // New: Datapath to latch input bits.
    always @(posedge clk) begin
    	if (reset) out <= 0;
    	else if (next == RECEIVE)
    		out[i] <= in;
    end

    // New: Add parity checking.
    parity u_parity(
        .clk(clk),
        .reset(reset | odd_reset),
        .in(in),
        .odd(odd));  

    always @(posedge clk) begin
    	if(reset) odd_reg <= 0;
    	else odd_reg <= odd; 
    end

    always @(posedge clk) begin
		case(next)
			IDLE : odd_reset <= 1;	
			STOP : odd_reset <= 1;
			default : odd_reset <= 0;
		endcase
    end

    assign done = ((state == STOP) && odd_reg);
    assign out_byte = (done) ? out : 8'b0;
endmodule

// fsm hdlc:
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

    parameter [3:0]  NONE = 0,
					 ONE  = 1,
					 TWO  = 2,
					 THREE= 3,
					 FOUR = 4,
					 FIVE = 5,
					 SIX  = 6,
					 DISC = 7,
					 FLAG = 8,
					 ERR  = 9;

    reg [3:0] state, next;
    
    always @(*) begin
        case(state)
            NONE : next = (in) ? ONE   : NONE;
			ONE	 : next = (in) ? TWO   : NONE;
			TWO	 : next = (in) ? THREE : NONE;
			THREE: next = (in) ? FOUR  : NONE;
			FOUR : next = (in) ? FIVE  : NONE;
			FIVE : next = (in) ? SIX   : DISC;
			SIX	 : next = (in) ? ERR   : FLAG;
			DISC : next = (in) ? ONE   : NONE;
			FLAG : next = (in) ? ONE   : NONE;
			ERR  : next = (in) ? ERR   : NONE;
        endcase
    end
    
    always @(posedge clk) begin
		if (reset)
			state <= NONE;
		else 
			state <= next;
	end

	assign disc = (state == DISC);
	assign flag = (state == FLAG);
	assign err = (state == ERR);
    
endmodule


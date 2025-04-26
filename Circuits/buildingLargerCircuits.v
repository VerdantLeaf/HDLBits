// Solutions for building larger circuits:

// Counter with period 1000
module top_module (
    input clk,
    input reset,
    output [9:0] q);
    
    always @(posedge(clk)) begin
        if(reset) q <= 0;
        else begin
            if(q == 999) q <= 0;
            else q <= q + 1;
        end
    end
endmodule

// 4 bit shift register and down counter
module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    
    always @(posedge clk) begin
        if(shift_ena)
            q <= {q[2:0], data};
        else if (count_ena)
            q <= q - 1;
    end
endmodule

// FSM Sequence recognizer
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
    
    reg [2:0] state, next;
    
    always @(*) begin
        case(state)
            A : next = (data) ? B : A;
            B : next = (data) ? C : A;
            C : next = (data) ? C : D;
            D : next = (data) ? E : A;
            E : next = E;
       	endcase 
    end
            
   always @(posedge clk) begin
        if (reset) state <=  A;
        else state <= next;
    end 
    
    
    assign start_shifting = (state == E);

endmodule


// FSM shift register
module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    integer count;
    // mildly proud of this implementation
    always @(posedge clk) begin
        if(reset) count = 4;
        else count = count -1;
    end
    
    assign shift_ena = (count > 0);

endmodule

// Complete FSM
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack 
  );

	localparam [3:0] IDLE	= 0,
					 S1		= 1,
					 S11	= 2,
					 S110	= 3,
					 S1101	= 4,	//'S1101' and 'SHIFT0' can be regarded as one state.
					 SHIFT1 = 5,
					 SHIFT2 = 6,
					 SHIFT3 = 7,
					 COUNT  = 8,
					 DONE   = 9; 
	reg [3:0] state, next;

	always @(*) begin
		case (state) 
			IDLE  : next = (data) ? S1    : IDLE;
			S1    : next = (data) ? S11   : IDLE;
			S11   : next = (data) ? S11   : S110;
			S110  : next = (data) ? S1101 : IDLE;
			S1101 : next = SHIFT1;
			SHIFT1: next = SHIFT2;
			SHIFT2: next = SHIFT3;
			SHIFT3: next = COUNT;
			COUNT : next = (done_counting) ? DONE : COUNT;
			DONE  : next = (ack) ? IDLE : DONE;			
		endcase
	end

	always @(posedge clk) begin
		if (reset) state <= IDLE;
		else state <= next;
	end

	assign shift_ena = ((state == S1101) | (state == SHIFT1) | (state == SHIFT2) | (state == SHIFT3));
	assign counting = (state == COUNT);
	assign done = (state == DONE);
endmodule

// Complete Timer
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack 
  );

	localparam [3:0] IDLE	= 0,
					 S1		= 1,
					 S11	= 2,
					 S110	= 3,
					 S1101	= 4,	//'S1101' and 'SHIFT0' can be regarded as one state.
					 SHIFT1 = 5,
					 SHIFT2 = 6,
					 SHIFT3 = 7,
					 COUNT  = 8,
					 DONE   = 9; 
	
	reg [3:0] state, next;
	reg [9:0] count_1000; 

	always @(*) begin
		case (state) 
			IDLE  : next = (data) ? S1    : IDLE;
			S1    : next = (data) ? S11   : IDLE;
			S11   : next = (data) ? S11   : S110;
			S110  : next = (data) ? S1101 : IDLE;
			S1101 : next = SHIFT1;
			SHIFT1: next = SHIFT2;
			SHIFT2: next = SHIFT3;
			SHIFT3: next = COUNT;
			COUNT : next = (count == 0 & count_1000 == 999) ? DONE : COUNT;
			DONE  : next = (ack) ? IDLE : DONE;			
		endcase
	end

	//state transition
	always @(posedge clk) begin
		if (reset) state <= IDLE;
		else state <= next;
	end

	//shift in and then down count.
	always @(posedge clk) begin
		case (state) 
			S1101 : count[3] <= data;
			SHIFT1: count[2] <= data;
			SHIFT2: count[1] <= data;
			SHIFT3: count[0] <= data;
			COUNT : begin
				if (count >= 0) begin
					if (count_1000 < 999) 
						count_1000 <= count_1000 + 1'b1;
					else begin
						count <= count - 1'b1;
						count_1000 <= 0;
					end
				end
			end
			default : count_1000 <= 0;
		endcase
	end

	assign counting = (state == COUNT);
	assign done = (state == DONE);


endmodule

// FSM One Hot
module top_module(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,    // 10-bit one-hot current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
  ); 
    
    parameter S=0, S1=1, S11=2, S110=3, B0=4, B1=5, B2=6, B3=7, Count=8, Wait=9;

    assign B3_next = state[B2];
    assign S_next = (state[S] & (~d)) | (state[S1] & (~d)) | (state[S110] & (~d)) | (state[Wait] & ack);
    assign S1_next = state[S] & d;
    assign Count_next = state[B3] | (state[Count] & (~done_counting));
    assign Wait_next = (state[Count] & (done_counting)) | (state[Wait] & (~ack));
    assign done = state[Wait];
    assign counting = state[Count];
    assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];

endmodule
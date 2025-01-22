// Solutions for KMap to Circuit problems

// Kmap 1:
module top_module(
    input a,
    input b,
    input c,
    output out  ); 
    
    assign out = a || b || c;
    
endmodule

// Kmap2:
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    
    assign out = (~b & ~c) || (~a & ~d) || ( b & c & d) || (a & ~b & d);

endmodule

// Kmap3:
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    
    assign out = a || (~b & c);

endmodule

// Kmap4:
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 
    // A little proud
    assign out = a ^ b ^ c ^ d;
    
endmodule

// Min SOP/POS:
module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
); 

    assign out_sop = (c & d) || (~a & ~b & c);
    assign out_pos = (c) & (~a | b) & (~b | d);

endmodule

// Karnaugh Map:
module top_module (
    input [4:1] x, 
    output f );
    
    assign f = (~x[1] & x[3]) || (x[1] & x[2] & x[4]);

endmodule

// Karnaugh Map 2
module top_module (
    input [4:1] x,
    output f ); 
    
    assign f = (~x[1] & x[3]) | (~x[2] & ~x[4]) | (x[2] & x[3] & x[4]);

endmodule

// K Map MUX
module top_module (
    input c,
    input d,
    output [3:0] mux_in
); 

    always @(*) begin
        case({c ,d})
            2'b00 : mux_in = 4'b0100;
            2'b01 : mux_in = 4'b0001;
            2'b10 : mux_in = 4'b0101;
            2'b11 : mux_in = 4'b1001;
        endcase
    end
    
endmodule

// Provided solution:
// (much different than mine lol)
module top_module (
	input c,
	input d,
	output [3:0] mux_in
);
	
	// After splitting the truth table into four columns,
	// the rest of this question involves implementing logic functions
	// using only multiplexers (no other gates).
	// I will use the conditional operator for each 2-to-1 mux: (s ? a : b)
	assign mux_in[0] = c ? 1 : d;          // 1 mux:   c|d
	assign mux_in[1] = 0;                  // No muxes:  0
	assign mux_in[2] = d ? 0 : 1;          // 1 mux:    ~d
	assign mux_in[3] = c ? d : 0;          // 1 mux:   c&d
	
endmodule

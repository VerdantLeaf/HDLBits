// Solutions for basic gates:

// wire:
module top_module (
    input in,
    output out);

    assign out = in;
    
endmodule

// gnd:
module top_module (
    output out);

    assign out = 0;
    
endmodule

// NOR:
module top_module (
    input in1,
    input in2,
    output out);
    
    assign out = !(in1 || in2);

endmodule

// NOT AND
module top_module (
    input in1,
    input in2,
    output out);

    assign out = in1 && !in2;
    
endmodule

// Two gates:
module top_module (
    input in1,
    input in2,
    input in3,
    output out);
    
    wire w12;
    
    assign w12 = !(in1 ^ in2);
    assign out = w12 ^ in3;

endmodule

// More gates:
module top_module( 
    input a, b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);
    assign out_and = a && b;
    assign out_or = a || b;
    assign out_xor = a ^ b;
    assign out_nand = !(a && b);
    assign out_nor = !(a || b);
    assign out_xnor = !(a ^ b);
    assign out_anotb = a && !b;

endmodule

// 7420 chip:
module top_module ( 
    input p1a, p1b, p1c, p1d,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );

    assign p1y = !(p1a && p1b && p1c && p1d);
    assign p2y = !(p2a && p2b && p2c && p2d);

endmodule

// Truthtable1:
module top_module( 
    input x3,
    input x2,
    input x1,  // three inputs
    output f   // one output
);
    assign f = (!x3 && x2) || (x1 && x3);
    
endmodule

// Two bit equality
module top_module ( input [1:0] A, input [1:0] B, output z ); 

    // XNOR of each bit is equality
    assign z = ~(A[1] ^ B[1]) && ~(A[0] ^ B[0]);

    // or don't be stupid/learn that you can just do equalities
    // like this??
    assign z = (A[1:0]==B[1:0]);

endmodule

// Simple Circuit A:
module top_module (input x, input y, output z);
    // Really easy lol
    assign z = (x ^ y) && x;
    
endmodule

// Simple Circuit B:
module top_module ( input x, input y, output z );

    assign z = !(x ^ y);
    // OR:
    assign z = x == y;
    
endmodule

// Combine A & B:
module top_module (input x, input y, output z);

    wire a1out, a2out, b1out, b2out;
    
    circA A1(.x(x), .y(y), .z(a1out));
    circA A2(.x(y), .y(y), .z(a2out));
    
    circB B1(.x(x), .y(y), .z(b1out));
    circB B2(.x(x), .y(y), .z(b2out));
    
    assign z = (a2out && b2out) ^ (a1out || b1out);
    
endmodule

module circA (input x, input y, output z);
    
    assign z = (x ^ y) && x;
    
endmodule

// Simple Circuit B:
module circB ( input x, input y, output z );

    assign z = x == y;
    
endmodule

// Ringer:
module top_module (
    input ring,
    input vibrate_mode,
    output ringer,       // Make sound
    output motor         // Vibrate
);
    assign ringer = ring && !vibrate_mode;
    assign motor = ring && vibrate_mode;

endmodule

// Thermostat:
module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
); 
    // Can also just do heater | aircon | fan_on;
    assign fan = fan_on || (mode && too_cold) || (!mode && too_hot);
    
    assign heater = mode && too_cold;
    assign aircon = !mode && too_hot;

endmodule

// Popcount3:
module top_module( 
    input [2:0] in,
    output [1:0] out );
    // This is great and I love it
    assign out = in[2] + in[1] + in[0];

endmodule

// Gatesv:
module top_module( 
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );
    
    // And to see if the same
    assign out_both[0] = in[1] & in[0];
    assign out_both[1] = in[2] & in[1];
    assign out_both[2] = in[3] & in[2];
    
    // Or since it can be either
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];
    
    // XNOR for equality
    assign out_different[0] = (in[1] ^ in[0]); 
    assign out_different[1] = (in[2] ^ in[1]); 
    assign out_different[2] = (in[3] ^ in[2]); 
    assign out_different[3] = (in[0] ^ in[3]); 

    // That is not a very efficient way to do it.
    
    // This all because it's bitwise - which would have been smart
    assign out_any = in[3:1] | in[2:0];

	assign out_both = in[2:0] & in[3:1];
	// Use concat to rearrange bits
	assign out_different = in ^ {in[0], in[3:1]};

endmodule

// Gatesv100:
module top_module( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );

    // Take the same architeeture and bring it over
    assign out_both = in[98:0] & in[99:1];
    assign out_any = in[98:0] | in[99:1];
    assign out_different = in ^ {in[0], in[99:1]};
    
    // Listed soln uses in and not in[98:0], but I think
    // it just truncates.

endmodule
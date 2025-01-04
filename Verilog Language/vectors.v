// Vector set of problems

// Vector0:
module top_module ( 
    input wire [2:0] vec, // decl of vector has size before the name
    output wire [2:0] outv, // like "downto" from VHDL => Little endian
    output wire o2,
    output wire o1,
    output wire o0  ); // Module body starts after module declaration
    
    assign outv = vec;
    
    assign o2 = vec[2]; // use of vector is like C syntax except
    assign o1 = vec[1]; // bits are arranged: [2][1][0]
    assign o0 = vec[0]; 

endmodule

// Vector1:
// type [upper:lower] vector_name;
// type => wire or reg (register)
// can niclude port type input/output)
// wire[0:7] b => b[0] is most significant bit (like C arrs) (big Endian)
// Dimensions before name => Packed dimensions
// Dimensions after name => Unpacked dimensions
// ex: reg [7:0] mem [255:0]
`default_nettype none     // Disable implicit nets. Reduces some types of bugs.
module top_module( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );
    
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule

// Vector2:
module top_module( 
    input [31:0] in,
    output [31:0] out );//

    // assign out[31:24] = ...;
    assign out[31:24] = in[7:0];
    assign out[23:16] = in[15:8];
    assign out[15:8] = in[23:16];
    assign out[7:0] = in[31:24];
    
endmodule

// vectorgates:
module top_module( 
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // sometimes my brain thinks I am doing C
    // and forgets to write assign lol
    assign out_or_bitwise = a | b;
    assign out_or_logical = a || b;
    assign out_not = {~b, ~a}; // love the concatenation

endmodule

// Gates4:
module top_module( 
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // operator and the vector does the operation to the entire vector.
    assign out_and = &in;
    assign out_or = |in;
    assign out_xor = ^in; // More efficient than listing each vec elem

endmodule

// Vector3:
// [bit_length]'[d|h|b][number]
// d=> dec, h => hex, b => bin
module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );//

    // assign { ... } = { ... };
    assign w = {a, b[4:2]};
    assign x = {b[1:0], c, d[4]};
    assign y = {d[3:0], e[4:1]};
    assign z = {e[0], f[4:0], 2'b11};

endmodule

// Vectorr
module top_module( 
    input [7:0] in,
    output [7:0] out
);
    // Gotta be a better way to do this for a longer vector lol
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule


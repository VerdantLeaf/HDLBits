// Modules set

// Modules:
// By position:
module top_module ( input a, input b, output out );

    // it's like passing arguments as parameters to a constructor
    // or something similar to build an object
    mod_a instancePosition( a, b, out);
    
endmodule

// By name:
module top_module ( input a, input b, output out );

    // If the name for the module output is the same as your module's
    // in/output then it gets weird
    mod_a instanceName( .out(out), .in2(b), .in1(a));
    
endmodule

// Module pos:
module top_module ( 
    input a, 
    input b, 
    input c,
    input d,
    output out1,
    output out2
);

    mod_a instancepos(out1, out2, a, b, c, d);
    
endmodule

// Module name:
module top_module ( 
    input a, 
    input b, 
    input c,
    input d,
    output out1,
    output out2
);
    
    mod_a instancename(.out1(out1), .out2(out2), .in4(d), .in2(b), .in3(c), .in1(a));

endmodule

// Module Shift:
module top_module ( input clk, input d, output q );

    wire dff12, dff23;
    
    my_dff dff1(clk, d, dff12); // Assign directly to the wires
    my_dff dff2(clk, dff12, dff23);
    my_dff dff3(clk, dff23, q); // Assign directly to ins/outs
    
endmodule

// Module shift8:
module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);
    
    wire [7:0]dff12, dff23, dffres; // You need to declare these as 8b (duh)
    
    my_dff8 dff1(clk, d, dff12);
    my_dff8 dff2(clk, dff12, dff23);
    my_dff8 dff3(clk, dff23, dffres);
    
    // You can replace this with @(*) to be sensitive to all inputs
    always @(d or dff12 or dff23 or dffres or sel) begin
        // Can also do with if statement
        case(sel)
            0 : q = d;
            1 :	q = dff12;
            2 :	q = dff23;
            3 : q = dffres;
        endcase
    end
endmodule

// Module Add:
module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry;
    // Try connection by name, heavier syntax, but alright
    add16 lowerAdder(.a(a[15:0]), .b(b[15:0]), .cin(0), .cout(carry), .sum(sum[15:0]));
    add16 upperAdder(.a(a[31:16]), .b(b[31:16]), .cin(carry), .cout(0), .sum(sum[31:16]));

endmodule

// Module fadd:
module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    // Top module should be the exact same code
    wire carry;
    add16 lowerAdder(.a(a[15:0]), .b(b[15:0]), .cin(0), .cout(carry), .sum(sum[15:0]));
    add16 upperAdder(.a(a[31:16]), .b(b[31:16]), .cin(carry), .cout(0), .sum(sum[31:16]));

endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );

// Full adder module here
    // This is the addition operator and we use the concatenation operator to differentiate the 
    // lower and upper sum and cout bits respectively.
    assign {cout, sum} = a + b + cin;
    

endmodule

// Module cseladd:
module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    
    wire [15:0] sumCarryZero, sumCarryOne; // This declares both as 16 bit vectors
    wire carrySel;
    
    // The same, except cout runs to carrySel
    add16 lowerAdder(.a(a[15:0]), .b(b[15:0]), .cin(0), .cout(carrySel), .sum(sum[15:0]));
    // Run sum to sumCarruZero and sumCarryOne
    add16 upperAdder0(.a(a[31:16]), .b(b[31:16]), .cin(0), .cout(0), .sum(sumCarryZero));
    add16 upperAdder1(.a(a[31:16]), .b(b[31:16]), .cin(1), .cout(0), .sum(sumCarryOne));
    
    // Build a mux
    always @(*) begin
        case(carrySel)
            0 : sum[31:16] = sumCarryZero;
            1 : sum[31:16] = sumCarryOne;
        endcase
    end

endmodule

// Module addsub - Tough one, not going to lie
module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    
    wire carry;
    wire [31:0] bPosNeg;
    
    // This is all the same code - except changing b input source & cin
    add16 lowerAdder(.a(a[15:0]), .b(bPosNeg[15:0]), .cin(sub), .cout(carry), .sum(sum[15:0]));
    add16 upperAdder(.a(a[31:16]), .b(bPosNeg[31:16]), .cin(carry), .cout(0), .sum(sum[31:16]));
    
    // XOR gate is a selectable inverter (needed the hint for that)
    always @(*) begin
        case(sub)
            0 : bPosNeg = b;
            1 : bPosNeg = ~b;
        endcase
    end

endmodule
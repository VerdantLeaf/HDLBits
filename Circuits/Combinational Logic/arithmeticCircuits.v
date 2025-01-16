// Solutions for arithmetic circuits problems

// Hadd:
module top_module( 
    input a, b,
    output cout, sum );
    // Half adder
    assign sum = a ^ b;
    assign cout = a & b;
    
endmodule

// Fadd:
module top_module( 
    input a, b, cin,
    output cout, sum );
    
    // Could also do gate description
    assign {cout, sum} = a + b + cin;

endmodule

// Adder3:
module top_module( 
    input [2:0] a, b,
    input cin,
    output [2:0] cout,
	output [2:0] sum );
    
    fadder add0(a[0], b[0], cin, cout[0], sum[0]);
    fadder add1(a[1], b[1], cout[0], cout[1], sum[1]);
    fadder add2(a[2], b[2], cout[1], cout[2], sum[2]);    

endmodule

module fadder( 
    input a, b, cin,
    output cout, sum );
    
    // Could also do gate description
    assign {cout, sum} = a + b + cin;

endmodule

// Adder:
module top_module (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);
    
    wire cout[2:0];
    
    fadder add0(x[0], y[0], 0, cout[0], sum[0]);
    fadder add1(x[1], y[1], cout[0], cout[1], sum[1]);
    fadder add2(x[2], y[2], cout[1], cout[2], sum[2]);
    fadder add3(x[3], y[3], cout[2], sum[4], sum[3]);

endmodule

module fadder( 
    input a, b, cin,
    output cout, sum );
    
    // Could also do gate description
    assign {cout, sum} = a + b + cin;

endmodule

// Signed Addition Overflow:
module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); //

    assign s = a + b;
    // I was originally checking that the result of the XNOR was equal
    // to s[7], need to compare s[7] with a or b[7]
    assign overflow = (!(a[7] ^ b[7]) & (b[7] != s[7])) ? 1 : 0;
    
endmodule

// Adder100:
module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    // This syntax can be used for any width
    assign {cout, sum} = a + b + cin;
    
endmodule

// Bcdadd4:
module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    
    wire[2:0] carry;
    
    bcd_fadd add0(a[3:0], b[3:0], cin, carry[0], sum[3:0]);
    bcd_fadd add1(a[7:4], b[7:4], carry[0], carry[1], sum[7:4]);
    bcd_fadd add2(a[11:8], b[11:8], carry[1], carry[2], sum[11:8]);
    bcd_fadd add3(a[15:12], b[15:12], carry[2], cout, sum[15:12]);
   
endmodule
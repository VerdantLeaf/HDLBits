// Answers for basics set of problems.

// Wire:
module top_module( input in, output out );

    assign out = in;
    
endmodule

// wire4:
module top_module( 
    input a,b,c,
    output w,x,y,z );

    assign w = a;
    assign z = c;
    assign x = b;
    assign y = b;
    
endmodule

// notgate:
module top_module( input in, output out );

    assign out = !in; // Could also use ~in (bitwise inversion)
    
endmodule

// andgate:
module top_module( 
    input a, 
    input b, 
    output out );
    
    // && => "Logical" (results in 1 bit output)
    // & => Bitwise anding
    assign out = a && b;

endmodule

// norgate
module top_module( 
    input a, 
    input b, 
    output out );
    
    assign out = !(a || b);

endmodule

// xnorgate
module top_module( 
    input a, 
    input b, 
    output out );

    assign out = !(a ^ b);
    
endmodule

// wire_decl
`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
    
    wire and_ab, and_cd;

    assign and_ab = a && b;
    assign and_cd = c && d;
    assign out = and_ab || and_cd;
    assign out_n = !out;

endmodule

// 7458
// spln 1:
module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );

    assign p1y = ((p1a && p1b && p1c) || (p1d && p1e && p1f));
    assign p2y = ((p2a && p2b) || (p2c && p2d));

endmodule
// soln 2:
module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );

    wire p1abc, p1def, p2ab, p2cd;
    
    assign p1abc = p1a && p1b && p1c;
    assign p1def = p1d && p1e && p1f;
    assign p2ab = p2a && p2b;
    assign p2cd = p2c && p2d;
    
    assign p1y = p1abc || p1def;
    assign p2y = p2ab || p2cd;

endmodule
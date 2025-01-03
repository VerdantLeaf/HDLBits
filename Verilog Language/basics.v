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

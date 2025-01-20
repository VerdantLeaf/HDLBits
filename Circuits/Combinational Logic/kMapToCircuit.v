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

//
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

// Module name
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
// Solutions for multiplexers problems

// Mux2to1:
module top_module( 
    input a, b, sel,
    output out ); 

    always @(*) begin
        case(sel)
            0 : out = a;
            1 : out = b;
        endcase
    end
endmodule


// Mux2to1v:
module top_module( 
    input [99:0] a, b,
    input sel,
    output [99:0] out );

    assign out = (sel) ? b : a;
    
endmodule

// Mux9to1v:
module top_module( 
    input [15:0] a, b, c, d, e, f, g, h, i,
    input [3:0] sel,
    output [15:0] out );
    
    always @(*) begin

        out = '1;   // Can use this to set all bits to 1
                    // '0, 'x, and 'z are all valid as well
        case(sel)
            0 : out = a;
            1 : out = b;
            2 : out = c;
            3 : out = d;
            4 : out = e;
            5 : out = f;
            6 : out = g;
            7 : out = h;
            8 : out = i;
            default out = 16'hffff; // above makes unnecessary
        endcase
    end
endmodule

// Mux256to1:
module top_module( 
    input [255:0] in,
    input [7:0] sel,
    output out );
    
    assign out = in[sel]; // easy and simple

endmodule

// Mux256to1v:
module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );

    // Does not work: in[sel*4+3:sel*4]
    
    // indjexed vector part select
    assign out = in[sel*4 +: 4];

    // w[x +:y] => w{x : (x+y-1)]
    
endmodule
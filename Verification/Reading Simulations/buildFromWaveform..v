// Solutions for building from the waveforms
// circuit 1:
module top_module (
    input a,
    input b,
    output q );//

    assign q = a & b; // Fix me

endmodule

// circuit 2:
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//
	// it's only when any multiple of two of the signals are on
    assign q = a + b + c + d == 0 || a + b + c + d == 2 || a + b + c + d == 4;
    // That's sneaky
endmodule

// circuit 3:
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = (a & d) || (b & d) || (b & c) || (a & c);

endmodule

// circuit 4:
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = b || c;

endmodule


// circuit 5:
module top_module (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q );
    
    always @(*) begin
        case(c)
            0 : q <= b;
            1 : q <= e;
            2 : q <= a;
            3 : q <= d;
            default : q <= 4'hF;
        endcase
    end
endmodule

// circuit 6:
module top_module (
    input [2:0] a,
    output [15:0] q ); 

    always @(*) begin
        case(a)
            0 : q <= 16'h1232;
            1 : q <= 16'haee0;
            2 : q <= 16'h27d4;
            3 : q <= 16'h5a0e;
            4 : q <= 16'h2066;
            5 : q <= 16'h64ce;
            6 : q <= 16'hc526;
            7 : q <= 16'h2f19;
        endcase
    end
    	
endmodule

// circuit 7:
module top_module (
    input clk,
    input a,
    output q );
    // was making this more complicated than it should have been
    always @(posedge clk) begin
        q <= !a;
    end

endmodule

// circuit 8:
module top_module (
    input clock,
    input a,
    output p,
    output q );

    always @(*) begin
        if(clock)
            p <= a;
    end
    // tricky
    always @(negedge clock) begin
        q <= p;
    end
    
endmodule

// circuit 9:
module top_module (
    input clk,
    input a,
    output [3:0] q );

    always @(posedge clk) begin
        if(a)
            q <= 4;
        else
            case(q)
                6 : q <= 0;
                default q <= q + 1;
            endcase
    end
    
endmodule

// circuit 10:
module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );
    
    always @(posedge clk) begin
        if(a == 1 && b == 1 && state == 0)
           state <= 1;
        if(a == 0 && b == 0 && state == 1)
           state <= 0;
    end
        
    assign q = a ^ b ^ state;

endmodule
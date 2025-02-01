// Finding bugs solutions

// MUX2
module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out  );

    assign out = sel ? a : b;

endmodule

// NAND3
module top_module (input a, input b, input c, output out);//

    wire aout;
    andgate inst1 (aout, a, b, c,1 ,1);
    
    assign out = !aout;

endmodule

// MUX4
module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //
    // soln ended up being pretty simple
    wire [7:0] mux0, mux1;
    mux2 mux21_0 ( sel[0],    a,    b, mux0 );
    mux2 mux21_1 ( sel[0],    c,    d, mux1 );
    mux2 mux2 ( sel[1], mux0, mux1,  out );

endmodule

// Add/sub:
// synthesis verilog_input_version verilog_2001
module top_module ( 
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);//

    always @(*) begin
        case (do_sub)
          0: out <= a+b;
          1: out <= a-b;
        endcase
   
        result_is_zero <= out ? 0 : 1;
    end

endmodule

// Case statement:
module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid=1 );//

    always @(*) begin
        out = 0;
        valid = 1;
        case (code)
            8'h45: out = 0;
            8'h16: out = 1;
            8'h1e: out = 2;
            8'h26: out = 3;
            8'h25: out = 4;
            8'h2e: out = 5;
            8'h36: out = 6;
            8'h3d: out = 7;
            8'h3e: out = 8;
            8'h46: out = 9; // having to change this is criminal lol
            default: 
                valid = 0;
        endcase
    end
endmodule

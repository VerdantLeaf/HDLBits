// Procedures set

// // synthesis verilog_input_version verilog_2001
module top_module(
    input a, 
    input b,
    output wire out_assign,
    output reg out_alwaysblock
);
    // Always always use (*) in always statements

    assign out_assign = a && b;
    
    // For single lines, you don't need begin/end
    always @(*) out_alwaysblock = a && b;

endmodule

// Alwaysblock2:
// synthesis verilog_input_version verilog_2001
module top_module(
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff   );
    
    assign out_assign = a ^ b;
    
    always @(*) out_always_comb = a ^ b;
    // Use "<=" for clocked triggers
    always @(posedge clk) out_always_ff <= a ^ b;

endmodule

// Always if:

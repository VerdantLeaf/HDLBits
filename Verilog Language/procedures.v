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
// synthesis verilog_input_version verilog_2001
module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output wire out_assign,
    output reg out_always   ); 
    // Same as C ? operator
    assign out_assign = (sel_b1 && sel_b2) ? b : a;
    
    always @(*) begin
        // Condition requires paranthesis
        if (sel_b1 && sel_b2) begin
            out_always = b;
        end
        else begin
            out_always = a;
        end
    end

endmodule

// Always if2:
// synthesis verilog_input_version verilog_2001
module top_module (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving  ); //

    always @(*) begin
        if (cpu_overheated)
           shut_off_computer = 1;
    	else    // easy
    		shut_off_computer = 0;
    end

    always @(*) begin
        if (~arrived)
           keep_driving = ~gas_tank_empty;
        else
            // THat doesn't feel correct, but is on the timing
            keep_driving = (gas_tank_empty && ~arrived);
    end

endmodule

// Always case:
// synthesis verilog_input_version verilog_2001
module top_module ( 
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out   );//

    always@(*) begin  // This is a combinational circuit
        case(sel)
            0 : out = data0;
            1 : out = data1;
            2 : out = data2;
            3 : out = data3;
            4 : out = data4;
            5 : out = data5;
            default out = 4'b0000; // remember default to not latch
        endcase
    end

endmodule

// Always case2:
// synthesis verilog_input_version verilog_2001
module top_module (
    input [3:0] in,
    output reg [1:0] pos  );
    
    // Priority encoded
    // This seems like an interesting way to do this, don't know if that was the intention
    // but I am slightly proud to have a "unique" soln
    always @(*) begin
        case(in[0])
            1 : pos = 2'b00;
            default begin
                case(in[1])
                    1 : pos = 2'b01;
                    default begin
                        case(in[2])
                            1 : pos = 2'b10;
                            default begin 
                                case(in[3])
                            		1 : pos = 2'b11;
                            		default pos = 2'b00;
                                endcase
                            end
                        endcase
                    end
                endcase
            end
        endcase
    end

    // Listed solution lists all 16 combinations, lol
        
endmodule

// Always casez:
// synthesis verilog_input_version verilog_2001
module top_module (
    input [7:0] in,
    output reg [2:0] pos );

    // oh that's actually pretty cool/smart.
    // like a more compact version of my soln to the past problem
    always @(*) begin
        casez(in[7:0])
        // YOU NEED TO SPECIFY "CASEZ" to have the z work

            8'bzzzzzzz1 : pos = 3'b000;
            8'bzzzzzz1z : pos = 3'b001;
            8'bzzzzz1zz : pos = 3'b010;
            8'bzzzz1zzz : pos = 3'b011;
            8'bzzz1zzzz : pos = 3'b100;
            8'bzz1zzzzz : pos = 3'b101;
            8'bz1zzzzzz : pos = 3'b110;
            8'b1zzzzzzz : pos = 3'b111;
          	default pos = 3'b000;
        endcase
    end
    
endmodule

// Always nolatches:
// synthesis verilog_input_version verilog_2001
module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up  ); 

    
    always @(*) begin
        left = 0;
        down = 0;
        right = 0;
        up = 0;
        // Just using bottom 8 bits does not work
        case(scancode)
            16'he06b : left = 1;
            16'he072 : down = 1;
            16'he074 : right = 1;
            16'he075 : up = 1;
        endcase
    end  
endmodule

// Popcount255:
module top_module( 
    input [254:0] in,
    output [7:0] out );

    reg[7:0] count = 0;
    
    always @(*) begin
        count = 0;
        for(int i = 0; i < $bits(in); i = i + 1) begin
            if(in[i])
                count = count +1;
        end
        out = count;
    end   
    
endmodule

// Adder100i:

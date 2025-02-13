// Solutions to shift register questions
// shift4:
module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 

    always @(posedge clk, posedge areset) begin
        
        if(areset)
            q <= 4'b0000;
        else if(load)
        	q <= data;
        else if(ena)
            q <= q >> 1;
    end
endmodule

// Rotate100:
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q); 

    always @(posedge clk) begin
        
        if(load)
            q <= data;
        else if(ena == 2'b10)
            q <= {q[98:0], q[99]};
		else if(ena == 2'b01)
            q <= {q[0], q[99:1]};
        else
            q <= q;
    end
    
endmodule

// shift18:
module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 
    
    always @(posedge clk) begin
        if(load)
            q <= data;
        else if(ena) begin
            if(amount == 2'b10)
                q <= {q[63], q[63:1]};
            else if(amount == 2'b11)
                q <= {{8{q[63]}}, q[63:8]};
            else if(amount == 2'b00 || amount == 2'b01)
                q <= q << (amount ? 8 : 1);
        end
    end

endmodule

// Lsfr5:
module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    output [4:0] q
); 
   // imply the flip flops 
    always @(posedge clk) begin
        if(reset)
            q <= 5'h1;
    	else begin
            q[4] <= q[0] ^ 1'b0;
            q[3] <= q[4];
            q[2] <= q[3] ^ q[0];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end // way easier than I thought at first

endmodule

// MT2015 lfsr:
module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q

    always @(posedge KEY[0]) begin
        LEDR[2] <= KEY[1] ? SW[2] : LEDR[1] ^ LEDR[2];
        LEDR[1] <= KEY[1] ? SW[1] : LEDR[0];
        LEDR[0] <= KEY[1] ? SW[0] : LEDR[2]; 
    end
endmodule

// lfsr32:
module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
    reg [31:0] q_n;
    
    always @(posedge clk) begin
        if(reset)
            q_n <= 32'h1;
        else begin
        	q_n <= q[31:1];
            q_n[31] <= q[0] ^ 1'b0;
            q_n[21] <= q[22] ^ q[0];
            q_n[1] <= q[2] ^ q[0];
            q_n[0] <= q[1] ^ q[0];
        end
    end
    
    assign q = q_n;

endmodule

// shift register
module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    
    reg [3:0] d;
    // really can't tell if this is a good implementation or not
    always @(posedge clk) begin
        if(!resetn) begin
        	d <= 4'h0;
            out <= 1'b0;
        end
        else begin
            d <= {in, d[3:1]};
            out <= d[1]; // this works, not entirely sure why
        end
    end
endmodule

// Shift register 2:
module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    MUXDFF MUX3(KEY[0], KEY[3], SW[3], KEY[1], KEY[2], LEDR[3]);
    MUXDFF MUX2(KEY[0], LEDR[3], SW[2], KEY[1], KEY[2], LEDR[2]);
    MUXDFF MUX1(KEY[0], LEDR[2], SW[1], KEY[1], KEY[2], LEDR[1]);
    MUXDFF MUX0(KEY[0], LEDR[1], SW[0], KEY[1], KEY[2], LEDR[0]);
endmodule

module MUXDFF (
    input clk,
    input w, R, E, L,
    output Q
);
    always @(posedge(clk)) begin
        if ({E, L} == 2'b00)
            Q <= Q;
        else if ({E, L} == 2'b10)
            Q <= w;
        else 
            Q <= R;
    end    
endmodule

// 3-input LUT:
// my soln:
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 
    
    reg [0:7] d;
    
    always @(posedge clk) begin
        if(enable)
            d <= {S, d[0:6]};
    end
    always @(*) begin
        case({A, B, C})
                0 : Z <= d[0];
                1 : Z <= d[1];
                2 : Z <= d[2];
                3 : Z <= d[3];
                4 : Z <= d[4];
                5 : Z <= d[5];
                6 : Z <= d[6];
                7 : Z <= d[7];
        endcase
    end
    
endmodule

// better soln from the soln given:
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 
    
    reg [0:7] d;
    
    always @(posedge clk) begin
        if(enable)
            d <= {S, d[0:6]};
    end

    assign Z = d[ {A, B, C}];

endmodule

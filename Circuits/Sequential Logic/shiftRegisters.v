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

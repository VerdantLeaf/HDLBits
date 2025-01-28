// Latches and FF's solutions

// Dff
module top_module (
    input clk,    // Clocks are used in sequential circuits
    input d,
    output reg q );//

    // Use a clocked always block
    //   copy d to q at every positive edge of clk
    //   Clocked always blocks should use non-blocking assignments
    always @(posedge(clk)) begin
        q <= d; // Always use nonblocking assignments
    end

endmodule

// dff8
module top_module (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    always @(posedge(clk))
        q <= d; // same
    
endmodule

// Dff8r
module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);
    // You still need to clk for reset, which makes sense
    always @(posedge(clk)) begin
        if(reset)
        	q <= 8'h00;
    	else
        	q <= d;
    end
    
endmodule

// Dff8p
module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    always @(negedge(clk)) begin
        if(reset)
            q <= 8'h34;
        else
            q <= d;
    end
endmodule

// Dff8ar
module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output [7:0] q
);
    // You need to do posedge of both, which makes sense
    always @(posedge(clk),posedge(areset)) begin
        if(areset)
            q <= 8'h00;
    	else
        	q <= d;
    end
endmodule

// dff16e:
module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    
    always @(posedge(clk)) begin
        if(~resetn)
            q <= 16'h0000;
        else begin
            if(byteena[1])
                q[15:8] <= d[15:8];
        	if(byteena[0])
                q[7:0] <= d[7:0];
        end
    end
endmodule

// D Latch
module top_module (
    input d, 
    input ena,
    output q);
    
    assign q = ena ? d : q;

endmodule

// DFF
module top_module (
    input clk,
    input d, 
    input ar,   // asynchronous reset
    output q);

    always @(posedge(clk), posedge(ar)) begin
        if(ar)
            q <= 1'b0;
        else
            q <= d;
    end
    
endmodule

// DFF2
module top_module (
    input clk,
    input d, 
    input r,   // synchronous reset
    output q);

    always @(posedge(clk)) begin
        if(r)
            q <= 1'b0;
        else
            q <= d;
    end 
endmodule

// DFF+Gate:
module top_module (
    input clk,
    input in, 
    output out);
        
    flipflopd dflip(clk, in ^ out, out);
    
endmodule
        // Could not name module dff
module flipflopd(input clk, input d, output q);
    
    always @(posedge(clk))
        q <= d;
    
endmodule

// Muxx DFF:
module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);
    
    // sometimes the answer is simpler than you think    
    always @(posedge(clk)) begin
        if(L)
            Q <= r_in;
        else
            Q <= q_in;
    end
endmodule

// Mux and DFF 2
module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    // you need to build the internal muxes inside the FF stuff (sort of)
    always @(posedge(clk)) begin
        if ({E, L} == 2'b00)
            Q <= Q;
        else if ({E, L} == 2'b10)
            Q <= w;
        else 
            Q <= R;
    end    
endmodule

// DFF and Gates:
module top_module (
    input clk,
    input x,
    output z
); 

    wire q1, q2, q3;

    
    d_ff inst1(q1 ^ x,clk,q1);
    d_ff inst2(~q2 & x,clk,q2);
    d_ff inst3(~q3 | x,clk,q3);
 
    assign z = ~(q1 | q2 | q3); 
        
endmodule

module d_ff (input d, input clk, output reg q);
    // q needs to hold it's value, therefore it has to be a reg and not a wire
    always@(posedge clk) begin
        q <= d;
    end
endmodule
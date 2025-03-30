// Solutions for building larger circuits:

// Counter with period 1000
module top_module (
    input clk,
    input reset,
    output [9:0] q);
    
    always @(posedge(clk)) begin
        if(reset) q <= 0;
        else begin
            if(q == 999) q <= 0;
            else q <= q + 1;
        end
    end
endmodule

// 4 bit shift register and down counter
module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    
    always @(posedge clk) begin
        if(shift_ena)
            q <= {q[2:0], data};
        else if (count_ena)
            q <= q - 1;
    end
endmodule

// FSM Sequence recognizer
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
    
    reg [2:0] state, next;
    
    always @(*) begin
        case(state)
            A : next = (data) ? B : A;
            B : next = (data) ? C : A;
            C : next = (data) ? C : D;
            D : next = (data) ? E : A;
            E : next = E;
       	endcase 
    end
            
   always @(posedge clk) begin
        if (reset) state <=  A;
        else state <= next;
    end 
    
    
    assign start_shifting = (state == E);

endmodule


// FSM shift register
module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    integer count;
    // mildly proud of this implementation
    always @(posedge clk) begin
        if(reset) count = 4;
        else count = count -1;
    end
    
    assign shift_ena = (count > 0);

endmodule

// 
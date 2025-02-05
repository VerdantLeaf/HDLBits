// Problem solutions for counters sub section
module top_module (
    input clk,
    input reset,      // Synchronous active-high reset
    output [3:0] q);
    
    always @(posedge clk) begin
        if(reset || q == 4'b1111)
            q <= 0;
        else
            q <= q + 1; // you can do q++ and have
                        // it roll over naturally
    end
endmodule

// count10:
module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output [3:0] q);

    always @(posedge clk) begin
        if(reset || q == 4'b1001)
            q <= 0;
        else
            q++; // can't do natural roll over since only counting to 10
    end
endmodule

// count1to10
module top_module (
    input clk,
    input reset,
    output [3:0] q);

    always @(posedge clk) begin
        if(reset || q == 4'b1010)
            q <= 1;
        else
            q++;
    end

endmodule

// countslow:
module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);
    
    always @(posedge clk) begin
        if(reset || ((q == 4'b1001) && slowena))
            q <= 0;
        else if(slowena)
            q++;
        // implied latch here on output
    end

endmodule

// Exams/ece241 2014 q7a

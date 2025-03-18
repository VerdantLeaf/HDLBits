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
module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //

    count4 the_counter (clk, c_enable, c_load, c_d, Q);
    
    assign c_enable = enable;	// if output is 12 and enabled, or rst set to 1
    							// else loop to zero
    assign c_load = ((Q==4'd12 && c_enable) || reset) ? 1 : 0;
    assign c_d = c_load ? 4'd1 : 0;

endmodule

// Counter1000
module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //

    wire [3:0] q0, q1, q2;

	bcdcount counter0 (clk, reset, c_enable[0], q0);
	bcdcount counter1 (clk, reset, c_enable[1], q1);
	bcdcount counter2 (clk, reset, c_enable[2], q2);

	assign c_enable = {(q1 == 4'd9) & (q0 == 4'd9), q0 == 4'd9, 1'b1};
	assign OneHertz = (q2 == 4'd9) & (q1 == 4'd9) & (q0 == 4'd9);

endmodule

// Countbcd
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    always @(posedge clk) begin
        if(reset) begin
            q = 16'b0;
            ena = 0;
        end
    else begin
            q[3:0] = q[3:0] + 1;
            ena[1] = (q[3:0] == 9) ? 1 : 0;
            if(q[3:0] == 10) begin
                q[3:0] = 0;
                q[7:4] = q[7:4] + 1;
            end
            ena[2] = ((q[7:4] == 9) && (q[3:0] == 9)) ? 1 : 0;
            if(q[7:4] == 10) begin
                q[7:4] = 0;
                q[11:8] = q[11:8] + 1;
            end
            ena[3] = ((q[11:8] == 9) && (q[7:4] == 9) && (q[3:0] == 9)) ? 1 : 0;
            if(q[11:8] == 10) begin
                q[11:8] = 0;
                q[15:12] = q[15:12] + 1;
            end
            if(q[15:12] == 10) begin
                q = 0;
            end
        end
    end
            

endmodule

// Count clock - thank you github folks, again
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);
    
    reg [2:0] ena_hms;	//determine when will "ss","mm" and "hh" need to be increased
    assign ena_hms = {(ena && (mm == 8'h59) && (ss == 8'h59)), (ena && (ss == 8'h59)), ena};   
    
    count60 count_ss(
        .clk(clk),
        .reset(reset),
        .ena(ena_hms[0]),
        .q(ss)
    );
    count60 count_mm(
        .clk(clk),
        .reset(reset),
        .ena(ena_hms[1]),
        .q(mm)
    );
    
    always @(posedge clk) begin
        if(reset) begin
        	hh <= 8'h12;    //hh=12
            pm <= 0;
        end
        else begin
            if(ena_hms[2] && (mm == 8'h59) && (ss == 8'h59)) begin    //if mm=59 and ss=59
                if(hh == 8'h12)  hh <= 8'h1; //hh changes:12AM->1AM or 12PM->1PM  
            	else if(hh == 8'h11) begin  //if hh=11, PM->AM or AM->PM
            		hh[3:0] <= hh[3:0] + 1'h1; //hh=12
               		pm <= ~pm;
                end 
                else begin
                    if(hh[3:0] == 4'h9) begin
                        hh[3:0] <= 4'h0;
                        hh[7:4] <= hh[7:4] + 1'h1;
                    end
                    else hh[3:0] = hh[3:0] + 1'h1;
                end
            end
            else hh <= hh;
        end
    end

endmodule

module count60(
	input clk,
    input reset,
    input ena,
    output [7:0] q
);
    always @(posedge clk) begin
        if(reset) q <= 8'h0;
        else begin
            if(ena) begin 
                if(q[3:0] == 4'h9) begin
                    if(q[7:4] == 4'h5) q <= 8'h0;
                    else begin
                        q[7:4] <= q[7:4] + 1'h1;
                        q[3:0] <= 4'h0;
                    end 
                end
                else q[3:0] <= q[3:0] + 1'h1; 
            end
            else q <= q;
        end
    end
endmodule

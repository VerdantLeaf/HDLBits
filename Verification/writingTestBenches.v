// Solutions for writing test benches:
module top_module ( );
	reg clk;
    initial clk = 0;
    
    always begin
        #5 clk = ~clk;
    end
    
    dut clk_dut(.clk(clk));
    
endmodule

// TB1:
module top_module ( output reg A, output reg B );//

    // generate input patterns here
    initial begin
		A = 0;
        B = 0;
        #10
        A = 1;
        #5
        B = 1;
        #5
        A = 0;
        #20
        B = 0;
    end

endmodule

// ANF TB:
module top_module();
    reg[1:0] in;
    wire out;
    
    initial begin
        in = 2'b00;
        #10
        in = 2'b01;
        #10
        in = 2'b10;
        #10
        in = 2'b11;
    end
    andgate my_and(in, out);
    
endmodule

// Testbench2:
module top_module();

	reg clk, in, out;
    reg[2:0] s;

    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        in = 0;
        s = 2;
        #10
        s = 6;
        #10
        s = 2;
        in = 1;
        #10
        in = 0;
        s = 7;
        #10
        in = 1;
        s = 0;
        #30
        in = 0;
    end
        
    q7 mod_q7(.clk(clk), .in(in), .s(s), .out(out));
    
endmodule

// T flip-flop:
module top_module ();

    reg clk, rst, t, q;
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        rst = 0;
        t = 0;
        #15
        rst = 1;
        #5
        rst = 0;
        #5
        t = 1;
    end
    
    tff tflipflop(.clk(clk), .reset(rst), .t(t), .q(q));
    
endmodule

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

//
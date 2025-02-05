// Solutions for building from the waveforms
// circuit 1:
module top_module (
    input a,
    input b,
    output q );//

    assign q = a & b; // Fix me

endmodule

// circuit 2:
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//
	// it's only when any multiple of two of the signals are on
    assign q = a + b + c + d == 0 || a + b + c + d == 2 || a + b + c + d == 4;
    // That's sneaky
endmodule

//

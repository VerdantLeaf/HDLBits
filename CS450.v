module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output tc
);
    reg [9:0] count;
    
    always @(posedge clk) begin
        if(load) count <= data;
        else begin
            if(count == 10'b0) count <= 10'b0;
            else count <= count - 1;
        end
    end
    
    assign tc = (count == 10'b0) ? 1 : 0;

endmodule

// counter 2bc
module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);
    
    always @(posedge clk or posedge areset) begin
        if(areset) state <= 2'b01;
        else if(train_valid) begin
            if(train_taken && state < 2'b11) state <= state + 1;
            else if(!train_taken && state > 2'b00) state <= state - 1;
            else state <= state // not needed, but there for code clarity. Produces the same result
        end else state <= state;
    end

endmodule

// history_shift
module top_module(
    input clk,
    input areset,

    input predict_valid,
    input predict_taken,
    output [31:0] predict_history,

    input train_mispredicted,
    input train_taken,
    input [31:0] train_history
);
    // This feels like it should have been harder
    always @(posedge clk or posedge areset) begin
        if(areset) predict_history <= 32'b0;
        else if (train_mispredicted) predict_history <= { train_history[30:0], train_taken};    
        else if (predict_valid) predict_history <= { predict_history[30:0], predict_taken};
    end 

endmodule

// gshare
module top_module(
    input clk,
    input areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    reg [1:0] PHT [127:0]; // 128 saturated counters
    
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            predict_history <= 0;
            for(int i =0 ; i < 128; i++)
                PHT[i] <= 2'b01;
        end
        else begin
            if(train_mispredicted && train_valid ) // train with the training token
                predict_history <= {train_history[5:0], train_taken};
            else if (predict_valid) /// add predicted token to prediction history
                predict_history <= {predict_history[5:0], predict_taken};
            if(train_valid && train_taken) // increment PHT value if correct
                PHT[train_history ^ train_pc] <= (PHT[train_history ^ train_pc] == 2'b11) ? 2'b11 : PHT[train_history ^ train_pc] + 1;
            else if(train_valid && ~train_taken) // decrement PHT value if incorrect
                PHT[train_history ^ train_pc] <= (PHT[train_history ^ train_pc] == 2'b00) ? 2'b00 : PHT[train_history ^ train_pc] - 1;
        end
    end
        
    // make assertion as to whether to branch or not
    assign predict_taken = PHT[predict_history ^ predict_pc][1];    
    
endmodule

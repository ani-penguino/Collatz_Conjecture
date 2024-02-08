module collatz( input logic         clk,   // Clock
		input logic 	    go,    // Load value from n; start iterating
		input logic  [31:0] n,     // Start value; only read when go = 1
		output logic [31:0] dout,  // Iteration value: true after go = 1
		output logic 	    done); // True when dout reaches 1

    logic [31:0] current_value;

    always_ff @(posedge clk) begin
        if (go) begin
            current_value <= n;
            done <= 0;
        end else begin
            if (~done) begin
                  if (current_value == 2) begin
                     current_value <= 1;
                     done <= 1;
                  end
                  else if (current_value[0] == 1) begin
                     current_value <= current_value * 3 + 1;
                  end
                  else begin
                     current_value <= current_value / 2;
                  end
            end else begin
               current_value <= 1;
               done <= 1;
            end
        end
    end

    assign dout = current_value; 

endmodule


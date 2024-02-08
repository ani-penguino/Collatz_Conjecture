// CSEE 4840 Lab 1: Run and Display Collatz Conjecture Iteration Counts
//
// Spring 2023
//
// By: <your name here>
// Uni: <your uni here>

module lab1( input logic        CLOCK_50,  // 50 MHz Clock input
	     
	     input logic [3:0] 	KEY, // Pushbuttons; KEY[0] is rightmost

	     input logic [9:0] 	SW, // Switches; SW[0] is rightmost

	     // 7-segment LED displays; HEX0 is rightmost
	     output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,

	     output logic [9:0] LEDR // LEDs above the switches; LED[0] on right
	     );

    logic [21:0]       rate_divider; // Counter for button press rate control
    logic [31:0]       start;  
    logic [31:0]       address;  
    logic [31:0]       n_display;    // Currently displayed value of n
    logic [15:0]       count;        // Iterations count
    logic              go;           // Trigger for the range module
    logic              reset_n;      // Reset signal for n_display
    logic	       done;
    logic [2:0]        state;
    `define Srst 3'd0
    `define Sstart 3'd1
    `define Sdone 3'd2
    `define Safter 3'd3
    `define Scount0 3'd4
    `define Scount1 3'd5
    `define Sresult 3'd6

    always_ff @(posedge CLOCK_50) begin
	if(!KEY[3]) begin
            state <= `Srst; 
	    n_display <= SW;
	    start <= SW;
	    address <= SW;
	    go <= 1;
      	end else begin
		case(state)
		    `Srst: begin
		       state <= `Sstart;n_display <= SW; address <= SW; go<=0;
		    end
		    `Sstart: begin
		          if(done == 0) begin state <= `Sstart; end
		          else begin state <= `Sdone; address <= 0;end
		    end
		    `Sdone: begin
		       state <= `Safter;
		    end
		    `Safter: begin
		       if(!KEY[2]) begin state <= `Safter; n_display <= SW; address <= SW-start;end
		       else if (!KEY[1] && KEY[0] && address>0) begin state <= `Scount0; n_display <= n_display-1; address <= address-1; end
                       else if (!KEY[0] && KEY[1] && address<255) begin state <= `Scount0; n_display <= n_display+1; address <= address+1; end
		       else begin state <= `Safter; n_display <= n_display; address <= address; end
		    end
		    `Scount0: begin
		       if(rate_divider == {22{1'b1}}) begin state <= `Scount1; rate_divider<=0; end
		       else begin state <= `Scount0; rate_divider<=rate_divider+1; end
		    end
		    `Scount1: begin
		       if(rate_divider == {22{1'b1}}) begin state <= `Safter; rate_divider<=0; end
		       else begin state <= `Scount1; rate_divider<=rate_divider+1; end
		    end
		    default: begin
		       state <= `Safter;
		    end
		 endcase
	end
    end

    range #(256,8)
	r(
        .clk(CLOCK_50),
        .start(address),
        .go(go),
        .count(count),
        .done(done)
    );

    hex7seg display_n_1 (.a(n_display[3:0]), .y(HEX3)); 
    hex7seg display_n_2 (.a(n_display[7:4]), .y(HEX4)); 
    hex7seg display_n_3 (.a(n_display[11:8]), .y(HEX5)); 

    hex7seg display_count_1 (.a(count[3:0]), .y(HEX0)); 
    hex7seg display_count_2 (.a(count[7:4]), .y(HEX1));
    hex7seg display_count_3 (.a(count[11:8]), .y(HEX2)); 

    assign LEDR = SW; 

   
  
endmodule

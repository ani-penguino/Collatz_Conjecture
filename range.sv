module range
   #(parameter
     RAM_WORDS = 16,            // Number of counts to store in RAM
     RAM_ADDR_BITS = 4)         // Number of RAM address bits
   (input logic         clk,    // Clock
    input logic 	go,     // Read start and start testing
    input logic [31:0] 	start,  // Number to start from or count to read
    output logic 	done,   // True once memory is filled
    output logic [15:0] count); // Iteration count once finished

     `define Srst 3'd0
     `define Sstart 3'd1
     `define Sdone 3'd2
     `define Safter 3'd3
     `define Sread 3'd4
     `define Stransit 3'd6

   logic 		cgo;    // "go" for the Collatz iterator
   logic                cdone;  // "done" from the Collatz iterator
   logic [31:0] 	n;      // number to start the Collatz iterator

// verilator lint_off PINCONNECTEMPTY
   
   // Instantiate the Collatz iterator
   collatz c1(.clk(clk),
	      .go(cgo),
	      .n(n),
	      .done(cdone),
	      .dout());

   logic [RAM_ADDR_BITS - 1:0] 	 num;         // The RAM address to write
   logic 			 running = 1; // True during the iterations

   /* Replace this comment and the code below with your solution,
      which should generate running, done, cgo, n, num, we, and din */
  
   /* Replace this comment and the code above with your solution */

   logic 			 we;                    // Write din to addr
   logic [15:0] 		 din;                   // Data to write
   logic [15:0] 		 mem[RAM_WORDS - 1:0];  // The RAM itself
   //logic [RAM_ADDR_BITS - 1:0] 	 addr;                  // Address to read/write
   logic [2:0] state;

   assign done = ~running;
   assign count = done? mem[start] : 0;
   always @(we or num) begin
      /* verilator lint_off WIDTH */
      if(we==1 || num == RAM_WORDS-1) 
      /* verilator lint_off WIDTH */
         mem[num]=din;
      else
         mem[num]=0;
   end
   always_ff @(posedge clk) begin
      if(go) begin
            state <= `Srst; 
            running <= 1;
            n <= start;
            num <= 0;
            din <= 0;
            cgo <= 1;
            we <= 0;
            //done <= 0;
      end else begin
         case(state)
            `Srst: begin
               state <= `Sstart;
               cgo <= 0;
               din <= din+1;
               we <= 0;
            end
            `Sstart: begin
                  if(cdone == 0) begin state <= `Sstart; din <= din+1; cgo <= 0; end
                  else begin state <= `Sdone; end
            end
            `Sdone: begin
               state <= `Safter;
               we <= 1;
            end
            `Safter: begin
               /* verilator lint_off WIDTH */
               if(num < RAM_WORDS-1) begin state <= `Stransit; din <= 0; n <= n+1; we <= 0; cgo <= 1; num <= num+1; end
               /* verilator lint_off WIDTH */
               else begin state <= `Sread; we <= 0;  end
            end
            `Stransit: begin
               if(cdone == 0) begin state <= `Sstart; end
               else begin state <= `Stransit; end
            end
            `Sread: begin
               state <= `Sread;
               running <= 0;
               //done <= 1;
            end
            default: begin
               state <= `Srst;
               cgo <= 0;
               din <= 1;
               we <= 0;
            end
         endcase
      end
   end

endmodule
	     

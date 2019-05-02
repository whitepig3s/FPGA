// Quartus II Verilog Template
// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)

module LED_state
(
	input	clk, in, reset,
	output reg [7:0] LEDG,
	output reg [2:0]state
);

	// Declare state register
	 

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;

	// Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
				LEDG = 8'b11111111;
			S1:
				LEDG = {clk,clk,clk,~clk,~clk,~clk,clk,clk};
			S2:
				LEDG = 8'b00000000;
			S3:
				LEDG = {clk,~clk,clk,~clk,clk,~clk,clk,~clk};
			default:
				LEDG = 8'b11111111;
		endcase
	end

	// Determine the next state
	always @ (posedge clk or posedge reset) begin//?LK??�?ES?		
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					if (in)			//S0?S1
						state <= S1;
					else
						state <= S0;
				S1:
					if (in)			//S1?S2
						state <= S2;
					else
						state <= S1;
				S2:
					if (in)			//S2?S3
						state <= S3;
					else
						state <= S2;
				S3:
					if (in)			//S3?S0
						state <= S0;
					else
						state <= S3;
			endcase
	end

endmodule

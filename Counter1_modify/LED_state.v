module LED_state
(
	input	clk, in, reset,start,pause,
	output reg [7:0] LEDG,
	output reg [2:0] state,
	output reg [0:0] value
);

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;

	// Output depends only on the state
	always @ (state) begin
	if (value)
		LEDG =LEDG;
	else
		case (state)
			S0:
				LEDG = 8'hFF;
			S1:
				LEDG = {clk,clk,clk,~clk,~clk,~clk,clk,clk};
			S2:
				LEDG = 8'h0;
			S3:
				LEDG = {clk,~clk,clk,~clk,clk,~clk,clk,~clk};	
			/*S4:
				LEDG=	;
			S5:
				LEDG= ;*/
			default:
				LEDG = 8'hFF;
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
						//state <= S4;
						state <= S0;
					else
						state <= S3;
				/*S4:
					if (in)			
						state <= S5;
					else
						state <= S4;
				S5:
					if (in)			
						state <= S0;
					else
						state <= S5;*/
			endcase
	end
	
	always @ (posedge start or posedge pause) begin
	if (pause)
		value =1'b1;
	if (start)
		value =1'b0;
	end
	
endmodule

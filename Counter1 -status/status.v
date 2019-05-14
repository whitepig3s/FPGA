module status (
	input	clk, in, reset,start,pause,
	output reg [17:0] LEDR,
	output reg [2:0] state,
	output reg [0:0] value
	);
	
	
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
	
		always @ (state) begin
			if (value)
				LEDR =LEDR;
			else
				case (state)
				S0:
					LEDR = 18'h30;
				S1:
					LEDR = {clk,clk,clk,~clk,~clk,~clk,clk,clk,~clk,~clk,clk,clk,~clk,~clk,clk,clk,~clk,~clk};
				S2:
					LEDR = 18'b0;
				S3:
					LEDR = {clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk};				
				S4:
					LEDR = 18'h2F0;
				/*S5:
					LEDR = ;*/
				default:
					LEDR = 18'h0;
				endcase
		end
		always @ (posedge clk or posedge reset) begin//?LK??�?ES?		
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					if (in)			//S0?S1
						state <= S0;
					else
						state <= S1;
				S1:
					if (in)			//S1?S2
						state <= S1;
					else
						state <= S2;
				S2:
					if (in)			//S2?S3
						state <= S2;
					else
						state <= S3;
				S3:
					if (in)			//S3?S0
						//state <= S4;
						state <= S3;
					else
						state <= S4;
				S4:
					if (in)			
						state <= S4;
					else
						state <= S0;
				/*S5:
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

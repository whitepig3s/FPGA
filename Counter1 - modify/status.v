module status (
	input	clk, in, reset,start,pause,
	output reg [17:0] LEDR,
	output reg [2:0]state);
	
		reg [0:0] value;
		
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
		always @ (state) begin
			if (value)
				LEDR =LEDR;
			else
				case (state)
				S0:
					LEDR = 18'h3FFFF;
				S1:
					LEDR = {clk,clk,clk,~clk,~clk,~clk,clk,clk,~clk,~clk,clk,clk,~clk,~clk,clk,clk,~clk,~clk};
				S2:
					LEDR = 18'b0;
				S3:
					LEDR = {clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk};				
				S4:
					LEDR = ;
				S5:
					LEDR = ;
					
				default:
					LEDR = 18'h3FFFF;
				endcase
		end
		
	always @ (posedge start or posedge pause) begin
	if (pause)
		value =1'b1;
	if (start)
		value =1'b0;
	end
	
endmodule

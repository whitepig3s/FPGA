module status (
	input	clk, in, reset,start,pause,
	output reg [17:0] LEDR,
	output reg [2:0]state);
	
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
		always @ (state) begin
			case (state)
			S0:
				LEDR = 18'h3FFFF;
			S1:
				LEDR = {clk,clk,clk,~clk,~clk,~clk,clk,clk,~clk,~clk,clk,clk,~clk,~clk,clk,clk,~clk,~clk};
			S2:
				LEDR = 18'b0;
			S3:
				LEDR = {clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk,clk,~clk};				
			default:
				LEDR = 18'h3FFFF;
			endcase
		end
	
endmodule

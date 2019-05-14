module LED_state
(
	input	clk,
	input [2:0]state,
	output reg [0:0] LEDG,
	output reg [1:0] LEDR
);

parameter S0 = 0, S1 = 1, S2 = 2;

always @(posedge clk)
begin 
	case (state)
		S0: //GREEN
			begin
				LEDG=1'b1;
				LEDR=2'b0;
			end	
			
		S1: //YELLOW
			begin
				LEDG=1'b0;
				LEDR=2'b10;
			end	
			
		S2: //RED
			begin
				LEDG=1'b0;
				LEDR=2'b01;
			end	
			
		endcase		
end
	
	
endmodule

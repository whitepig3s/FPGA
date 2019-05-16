module light(
	CLOCK_50,
	LEDG[0:0],
	LEDR[1:0],
	HEX0,
	clkout
);

input CLOCK_50;
output [0:0] LEDG;
output [1:0] LEDR;
output [6:0] HEX0;
output reg clkout;

reg [24:0] counter;
reg [3:0] second; //秒數
reg [1:0] state; //儲存燈號
parameter S0 = 0, S1 = 1, S2 = 2;


initial begin
    counter = 0;
    clkout = 0;
	 state = 0;
end

//50MHz to 1Hz ---
always @(posedge CLOCK_50)
begin    
	if (counter == 0) begin
        counter <= 24999999;
        clkout <= ~clkout;
    end 
	 else begin
        counter <= counter -1;
    end
end
//---


always @(posedge clkout)
begin 
	case (state)
		S0: //GREEN
			if (second >1)
				second=second-1;
			else
				begin
					second =9;
					state <=S1;
				end
				
		S1: //YELLOW
			if (second >1)
				second=second-1;				
			else
				begin
					second =3; 
					state <=S2;
				end
				
		S2: //RED
			if (second >1)
				second=second-1;
			else
				begin
					second =5;
					state <=S0;
				end
		endcase		
end

SEG7_LUT seg0(.oSEG(HEX0),.iDIG(second));
LED_state GR(.clk(clkout),.state(state),.LEDR(LEDR),.LEDG(LEDG));

endmodule

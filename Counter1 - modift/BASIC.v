module BASIC(
	CLOCK_50,
	KEY,
	LEDG,
	LEDR,
	HEX1,HEX0
);

input		          		CLOCK_50;
input		  [3:0]		KEY;
output	  [8:0]		LEDG;
output	  [17:0]		LEDR;
output	  [6:0]		HEX1,HEX0;


reg          [27:0]   counter_inc;

wire         [2:0]    state1;

always @(posedge CLOCK_50)
begin
    counter_inc <= counter_inc + 28'b1;
end
LED_state  LED1(.clk(counter_inc[23]) , .in(~KEY[1]), .reset(~KEY[0]), .pause(~KEY[3]), .start(~KEY[2]), .LEDG(LEDG), .state(state1));
status  LED(.clk(counter_inc[23]) , .in(~KEY[1]), .reset(~KEY[0]), .LEDR(LEDR[17:0]), .pause(~KEY[3]), .start(~KEY[2]));
SEG7_LUT  seg0(.oSEG(HEX0),.iDIG(state1));
SEG7_LUT  seg1(.oSEG(HEX1),.iDIG(0));

endmodule

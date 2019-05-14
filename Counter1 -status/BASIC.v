module BASIC(
	CLOCK_50,
	KEY,
	LEDG,
	LEDR,
	HEX1,HEX0,
	clkout
);

input		          	CLOCK_50;
input		  [3:0]		KEY;
output	  [8:0]		LEDG;
output	  [17:0]		LEDR;
output	  [6:0]		HEX1,HEX0;
output 		reg		clkout;

reg          [24:0]   counter;

wire         [2:0]    state1;
wire         [0:0] 	value1;
initial begin
    counter = 0;
    clkout = 0;
end

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

LED_state  LED1(.clk(clkout) , .in(~KEY[1]), .reset(~KEY[0]), .pause(~KEY[3]), .start(~KEY[2]), .LEDG(LEDG[8:0]), .state(state1), .value(value1));
status  LED(.clk(clkout) , .in(~KEY[1]), .reset(~KEY[0]), .LEDR(LEDR[17:0]), .pause(~KEY[3]), .start(~KEY[2]), .	value(value1));
SEG7_LUT  seg0(.oSEG(HEX0),.iDIG(state1));
SEG7_LUT  seg1(.oSEG(HEX1),.iDIG(0));

endmodule

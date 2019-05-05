module run (CLOCK_50,clkout);

input CLOCK_50;
reg [24:0] counter;
output reg clkout;

initial begin
    counter = 0;
    clkout = 0;
end

always @(posedge CLOCK_50) begin
    if (counter == 0) begin
        counter <= 24999999;
        clkout <= ~clkout;
    end 
	 else begin
        counter <= counter -1;
    end
end

endmodule 
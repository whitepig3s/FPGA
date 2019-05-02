module case0321(a,b,op,red_led,y);
input a;
input b;
input [1:0] op;
output[3:0] red_led;
output y;

reg yr;

wire yw;

always@(op)
begin
case (op)
	2'b00 :yr= a&b;
	2'b01 :yr= a|b;	
	2'b10 :yr= ~a;
	2'b11 :yr= a^b;
	endcase
end

assign y =yr;

assign red_led[0]=()

endmodule
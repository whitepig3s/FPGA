module ex1 (sw,led_red);

input [1:0] sw;
output [3:0] led_red;

assign led_red[0]=( sw[0] ==1)?1'b1:1'b0;

assign led_red[1]=( sw[1] ==1)?1'b1:1'b0;

assign led_red[2]=( sw[0] ==sw[1])?1'b1:1'b0;
endmodule

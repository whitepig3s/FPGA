module ex2 (key,led_red );

input key;
output led_red;
assign led_red =(key == 1)?1'b0:1'b1; 

endmodule

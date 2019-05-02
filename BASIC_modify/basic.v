module  basic (CLOCK_50,LEDG);

input                CLOCK_50;
output  reg   [7:0]  LEDG;

reg [2:0] key0_dly;

reg [2:0] key1_dly;

reg [27:0] counter_inc;



always@(posedge CLOCK_50)
begin

 if(!key0_dly[2] && key0_dly[1])
   LEDG[0]  <= ~LEDG[0]; 
  
 if(!key1_dly[2] && key1_dly[1])
  LEDG[7:1]  <=  LEDG[6:0];
 
  key0_dly <= {key0_dly[1:0],counter_inc[25]};
  key1_dly <= {key1_dly[1:0],counter_inc[23]};
  
  counter_inc <= counter_inc+28'b1;
  
end
  
endmodule 
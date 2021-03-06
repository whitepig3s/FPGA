// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 LTM module Timing control and output image data
//					form sdram 
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            		:| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Fan				:| 07/06/30  :| Initial Revision
// --------------------------------------------------------------------

module ltp_controller(
						iCLK, 				// LCD display clock
						iRST_n, 			// systen reset
						// SDRAM SIDE 
						iREAD_DATA1, 		// R and G  color data form sdram 	
						iREAD_DATA2,		// B color data form sdram
						oREAD_SDRAM_EN,		// read sdram data control signal
						//LCD SIDE
						oHD,				// LCD Horizontal sync 
						oVD,				// LCD Vertical sync 	
						oDEN,				// LCD Data Enable
						oLCD_R,				// LCD Red color data 
						oLCD_G,             // LCD Green color data  
						oLCD_B,             // LCD Blue color data  
						SW1);
//============================================================================
// PARAMETER declarations
//============================================================================
parameter H_LINE = 1056; 
parameter V_LINE = 525;
parameter Hsync_Blank = 46;   //H_SYNC + H_Back_Porch
parameter Hsync_Front_Porch = 210;
parameter Vertical_Back_Porch = 23; //V_SYNC + V_BACK_PORCH
parameter Vertical_Front_Porch = 22;
//===========================================================================
// PORT declarations
//===========================================================================
input			iCLK;   
input			iRST_n;
input	[15:0]	iREAD_DATA1;
input	[15:0]	iREAD_DATA2;

input SW1;

output			oREAD_SDRAM_EN;
output	[7:0]	oLCD_R;		
output  [7:0]	oLCD_G;
output  [7:0]	oLCD_B;
output			oHD;
output			oVD;
output			oDEN;
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg		[10:0]  x_cnt;  
reg		[9:0]	y_cnt; 
wire	[7:0]	read_red;
wire	[7:0]	read_green;
wire	[7:0]	read_blue; 
wire	[7:0]	tread_red;
wire	[7:0]	tread_green;
wire	[7:0]	tread_blue; 
/*wire			display_area;*/
wire			oREAD_SDRAM_EN;
reg				mhd;
reg				mvd;
reg				mden;
reg				oHD;
reg				oVD;
reg				oDEN;
reg		[7:0]	oLCD_R;
reg		[7:0]	oLCD_G;	
reg		[7:0]	oLCD_B;		
reg		[7:0]	gray;	

wire			display_area;
wire			detect_area;
wire			square;

reg	[19:0] num_red, num_green;	// calculate the number of red dots and green dots;
reg	obutton_right, obutton_left;
//=============================================================================
// Structural coding
//=============================================================================

// This signal control reading data form SDRAM , if high read color data form sdram  .
assign	oREAD_SDRAM_EN = (	(x_cnt>Hsync_Blank-2)&& //214
							(x_cnt<(H_LINE-Hsync_Front_Porch-1))&& //1015
							(y_cnt>(Vertical_Back_Porch-1))&& // //34
							(y_cnt<(V_LINE - Vertical_Front_Porch)) //515
						 )?  1'b1 : 1'b0;
						
// This signal indicate the lcd display area .
assign	display_area = ((x_cnt>(Hsync_Blank-1)&& //>215
						(x_cnt<(H_LINE-Hsync_Front_Porch))&& //< 1016
						(y_cnt>(Vertical_Back_Porch-1))&& 
						(y_cnt<(V_LINE - Vertical_Front_Porch-1))
						))  ? 1'b1 : 1'b0;

assign	detect_area = ((x_cnt>100) && (x_cnt<700) && (read_red > read_green)&&(2*read_red < 3*read_green)&&(read_red > read_blue)&&(2*read_red < 3*read_blue)) ? 1'b1 : 1'b0;	
assign	square = (((x_cnt>45) && (x_cnt<846) && (y_cnt>21) && (y_cnt<91))||((x_cnt>45) && (x_cnt<101) && (y_cnt>21) && (y_cnt<502))||((x_cnt>791) && (x_cnt<846) && (y_cnt>21) && (y_cnt<502))||((x_cnt>45) && (x_cnt<846) && (y_cnt>432) && (y_cnt<502)))	? 1'b1 : 1'b0;
assign   circle1 = (((x_cnt-400)*(x_cnt-400)+(y_cnt-240)*(y_cnt-240)<6000)) && (read_red > read_green)&&(2*read_red < 3*read_green)&&(read_red > read_blue) && (2*read_red < 3*read_blue)? 1'b1 : 1'b0 ;
assign   circle2 = (((x_cnt-400)*(x_cnt-400)+(y_cnt-240)*(y_cnt-240)<7000)) &&((x_cnt-400)*(x_cnt-400)+(y_cnt-240)*(y_cnt-240)>6000)? 1'b1 : 1'b0;

assign	tread_red   = obutton_left  && (x_cnt-150)*(x_cnt-150)+(y_cnt-240)*(y_cnt-240)<10000  ? 8'hFF : read_red;
assign	tread_green = obutton_right && ((x_cnt>600 && x_cnt<700 && y_cnt>100 && y_cnt<400) || (x_cnt>500 && x_cnt<800 && y_cnt>200 && y_cnt<300)) ? 8'hFF : read_green;
assign	tread_blue  = read_blue;

assign	read_red 	= display_area ? iREAD_DATA2[9:2] : 8'b0;
assign	read_green 	= display_area ? {iREAD_DATA1[14:10],iREAD_DATA2[14:12]}: 8'b0;
assign	read_blue 	= display_area ? iREAD_DATA1[9:2] : 8'b0;

///////////////////////// x  y counter  and lcd hd generator //////////////////
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
		begin
			x_cnt <= 11'd0;	
			mhd  <= 1'd0;  	
		end	
		else if (x_cnt == (H_LINE-1))
		begin
			x_cnt <= 11'd0;
			mhd  <= 1'd0;
		end	   
		else
		begin
			x_cnt <= x_cnt + 11'd1;
			mhd  <= 1'd1;
		end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			y_cnt <= 10'd0;
		else if (x_cnt == (H_LINE-1))
		begin
			if (y_cnt == (V_LINE-1))
				y_cnt <= 10'd0;
			else
				y_cnt <= y_cnt + 10'd1;	
		end
	end
////////////////////////////// touch panel timing //////////////////

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			mvd  <= 1'b1;
		else if (y_cnt == 10'd0)
			mvd  <= 1'b0;
		else
			mvd  <= 1'b1;
	end			

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			mden  <= 1'b0;
		else if (display_area)
			mden  <= 1'b1;
		else
			mden  <= 1'b0;
	end			
	//-------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				oHD	<= 1'd0;
				oVD	<= 1'd0;
				oDEN <= 1'd0;
				oLCD_R <= 8'd0;
				oLCD_G <= 8'd0;
				oLCD_B <= 8'd0;
			end
		else
			begin
				oHD	<= mhd;
				oVD	<= mvd;
				oDEN <= mden;
				if(SW1)
				begin
				oLCD_R <= (read_red+read_green+read_blue)/3;
				oLCD_G <= (read_red+read_green+read_blue)/3;
				oLCD_B <= (read_red+read_green+read_blue)/3;
				end
				else
				begin
				oLCD_R <= (read_red+read_green+read_blue)/3;
				oLCD_G <= (read_red+read_green+read_blue)/3;
				oLCD_B <= (read_red+read_green+read_blue)/3;
				end			
			end		
	end
						
endmodule
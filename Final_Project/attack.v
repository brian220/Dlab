`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:33 01/07/2017 
// Design Name: 
// Module Name:    attack 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module attack(rst,x,y,lazer,sbolt_run,bbolt_run,cbolt_run,mode,area
    );
	 input rst;
	 input signed [11:0] x;
	 input signed [11:0] y;
	 input [2:0] lazer;
	 input [7:0]sbolt_run,bbolt_run,cbolt_run;
	 input[1:0] mode;
	 wire [440:0] ball;
	 output reg [2:0] area;
	 parameter SBOLT = 0, BBOLT =1,LAZER =2;
		assign ball[21*1 -1:21*0 ] =21'b111111111111111111111;
		assign ball[21*2 -1:21*1 ] =21'b111111100000001111111;
		assign ball[21*3 -1:21*2 ] =21'b111111000000000111111;
		assign ball[21*4 -1:21*3 ] =21'b111100000000000001111;
		assign ball[21*5 -1:21*4 ] =21'b111000000000000000111;
		assign ball[21*6 -1:21*5 ] =21'b111000000000000000111;
		assign ball[21*7 -1:21*6 ] =21'b110000000000000000011;
		assign ball[21*8 -1:21*7 ] =21'b100000000000000000001;
		assign ball[21*9 -1:21*8 ] =21'b101110000000000011101;
		assign ball[21*10-1:21*9 ] =21'b100111110000011111001;
		assign ball[21*11-1:21*10] =21'b100011100010001110001;
		assign ball[21*12-1:21*11] =21'b100000000010000000001;
		assign ball[21*13-1:21*12] =21'b100000000111000000001;
		assign ball[21*14-1:21*13] =21'b111110001101100011111;
		assign ball[21*15-1:21*14] =21'b111110000000000011111;
		assign ball[21*16-1:21*15] =21'b111110000000000011111;
		assign ball[21*17-1:21*16] =21'b111110000000000011111;
		assign ball[21*18-1:21*17] =21'b111110000000000011111;
		assign ball[21*19-1:21*18] =21'b111110000000000011111;
		assign ball[21*20-1:21*19] =21'b111110010101010011111;
		assign ball[21*21-1:21*20] =21'b111111111111111111111;	 
	 always@(*)begin
	 if(rst)
			 area <= 0;
	 else if(mode!=3 && ((x >= 390+cbolt_run*2 && x <= 410+cbolt_run*2 && y<=360+cbolt_run*2 && y>=340+cbolt_run*2 && !ball[(y-340-cbolt_run*2)*21+x-390-cbolt_run*2])||
            (x >= 390-cbolt_run*2 && x <= 410-cbolt_run*2 && y<=360+cbolt_run*2 && y>=340+cbolt_run*2 && !ball[(y-340-cbolt_run*2)*21+x-390+cbolt_run*2])))begin
          area <= 1;
        end
        else if(mode == SBOLT &&(
		      (x <= 530 && x >= 510 && y <= 165 +sbolt_run*4 && y >=145 +sbolt_run*4 && !ball[21*(y-145-sbolt_run*4)+x-510])||
				(x <= 518 -sbolt_run*4 && x >= 498 -sbolt_run*4 && y <= 213 +sbolt_run*4 && y >=193 +sbolt_run*4 && !ball[21*(y-193-sbolt_run*4)+x-498+sbolt_run*4])||
				(x <= 494 -sbolt_run*3 && x >= 474 -sbolt_run*3 && y <= 249 +sbolt_run*4 && y >=229 +sbolt_run*4 && !ball[21*(y-229-sbolt_run*4)+x-474+sbolt_run*3])||
				(x <= 458 && x >= 438 && y <= 268 +sbolt_run*3 && y >= 248 +sbolt_run*3 && !ball[21*(y-248-sbolt_run*3)+x-438])||
				(x <= 410 && x >= 390 && y <= 360 +sbolt_run*3 && y >= 340 +sbolt_run*3 && !ball[21*(y-340-sbolt_run*3)+x-390])||
				(x <= 290 && x >= 270 && y <= 165 +sbolt_run*4 && y >= 145 +sbolt_run*4 && !ball[21*(y-sbolt_run*4-145)+x-270])||
				(x <= 302 +sbolt_run*4 && x >= 282 +sbolt_run*4 && y <= 213 +sbolt_run*4 && y >=193 +sbolt_run*4 && !ball[21*(y-sbolt_run*4-193)+x-sbolt_run*4-282])||
				(x <= 320 +sbolt_run*3 && x >= 300 +sbolt_run*3 && y <= 249 +sbolt_run*4 && y >=229 +sbolt_run*4 && !ball[21*(y-sbolt_run*4-229)+x-sbolt_run*3-320])||
				(x <= 362 && x >= 342 && y <= 268 +sbolt_run*3 && y >= 248 +sbolt_run*3 && !ball[21*(y-sbolt_run*3 -248)+x-342])
            ))begin//boss small bolt
		    area <= 2;
		  end
        else if(mode == BBOLT&&(
            (y>200+bbolt_run*3 && x+y <750+bbolt_run && x+bbolt_run*5 >y+250)||
				(y>200+bbolt_run*3 && x+y <750+3*bbolt_run && x+3*bbolt_run >y+250)||
				(y>200+bbolt_run*3 && x+y <550+5*bbolt_run && x+bbolt_run >y+50)||
				(y>200+bbolt_run*3 && x+y <550+3*bbolt_run && x+3*bbolt_run >y+50)||
				(y>155+bbolt_run*3 && x+y <605+3*bbolt_run && x+3*bbolt_run >y+195)
				))begin//boss big bolt
		    area <= 3;
		end
      else if (lazer == 2 && mode == LAZER &&((x>150&&x<250)||(x>350&&x<450)||(x>550&&x<650)))begin
          area <= 4;
      end	
	   else if (lazer == 4 && mode == LAZER &&((x>50&&x<150)||(x>250&&x<350)||(x>450&&x<550)||(x>650&&x<750)))begin
        area <= 5;
      end
	   else if(lazer == 6 && mode == LAZER &&(x>0 && x < 800 && y>470&&y<570))begin
	     area <= 6;
	   end
		else if(mode!=3 &&(x-400)*(x-400)+(y-155)*(y-155)<145*145)
		  area <= 7;
	   else
	  	  area <=0;
	   end
endmodule

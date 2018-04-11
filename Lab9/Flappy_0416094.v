`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:08 01/09/2017 
// Design Name: 
// Module Name:    Flappy 
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
module Flappy(input rst,input clk,input kclk,input kdata,output VGA_R,output VGA_G,output VGA_B,
			output h_sync,output v_sync
     );
	 reg signed [11:0] col,row;
	 reg R,G,B;
	 reg die;
	 reg [1:0]	 pass;
	 reg space,enter;
	 reg [30:0] sec_cnt;//[30:26] =sec;
	 reg [2:0] c_state,n_state;
	 reg signed [11:0] tube1_x,tube1_y,tube2_x,tube2_y,tube3_x,tube3_y,bird_x,bird_y;
	 wire signed [11:0] x,y;
	 wire [9:0] k_value;
	 wire [999:0] gameover;
	 wire [999:0] win;
	 wire refresh;
	 parameter IDLE = 0,SLOW=1,FAST =2,WIN=3,DIE=4;
	 always@(posedge clk or posedge rst)
	 begin
		if(rst)begin
		col <=0;
		row <=0;		
		end
		else begin
		col <= (col <1039)?col +1 :0;
		row <= (row <= 665)?(col == 1039)?row+1:row:0;
		end
	 end
	 key key(.rst(rst),.clk(clk),.kclk(kclk),.kdata(kdata),.k_value(k_value));
	 assign h_sync = ~(col >919 && col <=1039);
	 assign v_sync = ~(row >659 && row <=665);
	 assign x = (col > 103 && col <=903)? col-104:0;
	 assign y = (row > 22 && row <= 622)? row-23:0;
	 assign VGA_R = R;
	 assign VGA_G = G;
	 assign VGA_B = B;
assign gameover[99 :0  ] = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
assign gameover[199:100] = 100'b0000000011111111101111111110111000000111000111110000011111111101110000001110000000110000000111110000;
assign gameover[299:200] = 100'b0000000110000001100000000110011000000110001100011000000000001101111000011110000001111000001100011000;
assign gameover[399:300] = 100'b0000000110000001100000000110001100001100011000001100000000001101101100110110000011001100000000001100;
assign gameover[499:400] = 100'b0000000011000001100000000110001100001100011000001100000000001101100111100110000110001100000000001100;
assign gameover[599:500] = 100'b0000000000111111100011111110000110011000011000001100000111111101100011000110001111111110011110001100;
assign gameover[699:600] = 100'b0000000001100001100000000110000110011000011000001100000000001101100000000110001100000110001100001100;
assign gameover[799:700] = 100'b0000000011000001100000000110000011110000001100011000000000001101100000000110011000000011001100011000;
assign gameover[899:800] = 100'b0000001110000001101111111110000001100000000111110000011111111101100000000110111000000011100111110000;
assign gameover[999:900] = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

assign win[99 :0  ] = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
assign win[199:100] = 100'b0000000000000011000000011100000000000000001111111110000000001110000000000000001110000000000000000000;
assign win[299:200] = 100'b0000000000000011000001101100000000000000000001110000000000000110000000000000001100000000000000000000;
assign win[399:300] = 100'b0000000000000011000011001100000000000000000001110000000000000011000000100000011000000000000000000000;
assign win[499:400] = 100'b0000000000000011000110001100000000000000000001110000000000000001100001110000110000000000000000000000;
assign win[599:500] = 100'b0000000000000011001100001100000000000000000001110000000000000000110001110001100000000000000000000000;
assign win[699:600] = 100'b0000000000000011011000001100000000000000000001110000000000000000011011011011000000000000000000000000;
assign win[799:700] = 100'b0000000000000011110000001100000000000000000001110000000000000000001111011110000000000000000000000000;
assign win[899:800] = 100'b0000000000000011100000001100000000000000001111111110000000000000000110001100000000000000000000000000;
assign win[999:900] = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

	 always@(posedge clk or posedge rst)
	 begin
		if(rst)begin
			space <= 0;
			enter <= 0;
			end
		else 
		case (k_value[8:0])
			9'h029:space <= ~k_value[9];
			9'h05A:enter <= ~k_value[9];
			default:begin
					space <= space;
					enter <= enter;end
			endcase
	 end
	 always@(posedge clk or posedge rst)begin
		if(rst)
			c_state <= IDLE;
		else
			c_state <= n_state;
	 end
	 always@(*)
	 begin
		if(rst)
			n_state <= IDLE;
		else
			case(c_state)
			IDLE:if(enter) n_state <= SLOW;else n_state <= IDLE;
			SLOW:begin if(die)n_state <=DIE;else if(pass==1) n_state <= FAST; else  n_state <=SLOW;end
			FAST:begin if(die)n_state <=DIE;else if(pass==2) n_state <= WIN; else  n_state <=FAST;end
			WIN:n_state <= WIN;
			DIE:n_state <= DIE;
			default:n_state <= IDLE;
			endcase
	 end
	 always@(posedge clk or posedge rst)begin
		if(rst)
		sec_cnt <= 0;
		else if(sec_cnt[30:26] ==5'b11111)
		sec_cnt <= 0;
		else
		sec_cnt <= sec_cnt+1;
	 end
	 assign refresh = sec_cnt[23];
	 always@(posedge refresh or posedge rst)begin
		if(rst)begin
		bird_x<=30;
		bird_y<=300;
		end
		else if(c_state == SLOW ||c_state == FAST)begin
			if(space)
				bird_y <= bird_y-20;
			else
				bird_y <= bird_y+10;
		end
		else begin
			bird_x<=bird_x;
			bird_y<=bird_y;
		end
     end
	 always@(posedge refresh or posedge rst)begin
		if(rst)
			die <= 0;
		else if(((bird_y>(tube1_y+100)-15||bird_y<(tube1_y-100)+15))&&(bird_x>(tube1_x-25)-15&&bird_x<(tube1_x+25)+15)||
			  ((bird_y>(tube2_y+100)-15||bird_y<(tube2_y-100)+15))&&(bird_x>(tube2_x-25)-15&&bird_x<(tube2_x+25)+15)||
			  ((bird_y>(tube3_y+100)-15||bird_y<(tube3_y-100)+15))&&(bird_x>(tube3_x-25)-15&&bird_x<(tube3_x+25)+15))begin
			  die<=1;
			  end
	    else 
		    die<=die;
		end
	always@(posedge refresh or posedge rst)begin
		if(rst)
			pass <=0;
		else if(tube3_x <=-25)
			pass <= pass+1;
		else
			pass <= pass;
	 end
	 always@(posedge refresh or posedge rst)begin
		if(rst)begin
			tube1_x <= 400;
			tube1_y <= 300;
			tube2_x <= 600;
			tube2_y <= 400;
			tube3_x <= 800;
			tube3_y <= 300;
		end
		else if(c_state == SLOW)begin
				tube1_x <= (tube1_x <=-25)?825:tube1_x-20;
				tube2_x <= (tube2_x <=-25)?825:tube2_x-20;
				tube3_x <= (tube3_x <=-25)?825:tube3_x-20;
		end
		else if(c_state == FAST)begin
				tube1_x <= (tube1_x <=-25)?825:tube1_x-40;
				tube2_x <= (tube2_x <=-25)?825:tube2_x-40;
				tube3_x <= (tube3_x <=-25)?825:tube3_x-40;
		end
		else begin
				tube1_x <= tube1_x;
				tube2_x <= tube2_x;
				tube3_x <= tube3_x;
		end
	end
	always@(posedge clk)begin
	if(x>800 || x<0 || y>600||y<0) 
		{R,G,B}<=3'b000;
	else if(c_state == DIE && x>=350 &&x<450 &&y>=395 &&y<405 && gameover[(y-395)*100+x-250])
			{R,G,B}<=3'b111;
	else if(c_state == WIN && x>=350 &&x<450 &&y>=395 &&y<405 && win[(y-395)*100+x-250])
			{R,G,B}<=3'b111;
	else if(x>bird_x-15 &&x<bird_x+15 &&y<bird_y+15 && y>bird_y-15)
		{R,G,B}<=3'b110;
	 else if(x+y <bird_x+bird_y+20 && x>=bird_x+15 && y+bird_x+20 >x+bird_y)
		{R,G,B}<=3'b100;
     else if((x>tube1_x-25 && x<tube1_x+25 && (y>tube1_y+100 || y<tube1_y-100) && y>=0 &&y<=600) ||
		(x>tube2_x-25 && x<tube2_x+25 && (y>tube2_y+100 || y<tube2_y-100) && y>=0 &&y<=600) ||
		(x>tube3_x-25 && x<tube3_x+25 && (y>tube3_y+100 || y<tube3_y-100) && y>=0 &&y<=600))
		{R,G,B}<=3'b010;
	 else 
		{R,G,B}<= 3'b000;
	 end
		
endmodule

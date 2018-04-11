`timescale 1ns / 1ps
module Final_Project(output VGA_RED,
	output VGA_GREEN,
	output VGA_BLUE,
	output VGA_HSYNC,
	output VGA_VSYNC,
	input kdata,
	input kclk,
	input rst,
	input clk
    );
    //VGA
	reg signed [11:0] col;
	reg signed [11:0] row;
    wire signed [11:0] x , y;
	reg R, G, B;
    //ship action
    reg signed [11:0] ship_X , ship_Y;
    reg signed [11:0] bull_X , bull_Y;
    reg               c_state ,n_state;
    wire               refresh;
	 wire [9:0]         k_value;
	 wire [2:0]         area,danger;
	 reg               left,right,up,down,shoot;
    reg               hit;
	 wire              died;
	 reg               die;
	 reg               victory;
    reg        [30:0] cooldown;
    reg signed [8:0]  health;
    //boss action
    reg [30:0] sec_cnt;//sec_cnt[30:26] = sec;
    reg [1:0]  mode;  
    reg [2:0]  lazer;
	 wire [2099:0] over;
    reg [7:0] sbolt_run,bbolt_run,cbolt_run;
    parameter SBOLT = 0, BBOLT =1,LAZER =2,VICTORY =3;//boss attack mode
    //design
	 keyboard keyboard(.kdata(kdata),.clk(clk), .rst(rst), .kclk(kclk), .k_value(k_value));
	 attack attack(.rst(rst),.x(x),.y(y),.lazer(lazer),.sbolt_run(sbolt_run),.bbolt_run(bbolt_run),.cbolt_run(cbolt_run),.mode(mode),.area(area));
	 attack death(.rst(rst),.x(ship_X),.y(ship_Y),.lazer(lazer),.sbolt_run(sbolt_run),.bbolt_run(bbolt_run),.cbolt_run(cbolt_run),.mode(mode),.area(danger));
    //VGA
    assign x =(col >103 && col <=903)?col-104 : 0;
    assign y =(row >22 && row <= 622)?row -23 : 0;
	assign VGA_HSYNC= ~((col>=919)&(col<1039));
	assign VGA_VSYNC= ~((row>=659)&(row<665));
	always@(posedge clk)begin
		col<=(col<1039)?col+1:0;
		row<=(row==665)?0:(col==1039)?row+1:row;
	end
assign over[150*1 -1:150*0 ]=150'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
assign over[150*2 -1:150*1 ]=150'b000000000000000000000000000000000000000000000000111111111111000000000000000000000000000000000000000000000000000000000000000000000000011111111111100000;
assign over[150*3 -1:150*2 ]=150'b000000000000000000000000000000000000000000000011111000001111100000000000000000000000000000000000000000000000000000000000000000000000011000000011111000;
assign over[150*4 -1:150*3 ]=150'b000000000000000000000000000000000000000000000111100000000001111000000000000000000000000000000000000000000000000000000000000000000000000000000000111100;
assign over[150*5 -1:150*4 ]=150'b011110011100000011111110000011110000000111100111000000000000111000000000000001111111000000001111111000111111001110000001111111100000000000000000011110;
assign over[150*6 -1:150*5 ]=150'b011111111100001111101111100001110000000111001111000000000000111100000000000111110111110000011111111111111111111110000111100001110000000000000000001110;
assign over[150*7 -1:150*6 ]=150'b000000111100001110000001110000111000001110001110000000000000011100000000001110000000111000011100000111110000011110000111000000000000111111110000001110;
assign over[150*8 -1:150*7 ]=150'b000000011100011110110001111000111000011110001111000000000000011100000000001111011100111000011100000011100000011110000111111110000000111111110000001110;
assign over[150*9 -1:150*8 ]=150'b000000011100011111111111111000011100011100001111000000000000111100000000001111111111111100011100000011100000011110000111011111110000111000000000001110;
assign over[150*10-1:150*9 ]=150'b000000011100000000000001111000001100111000000111100000000001111000000000000000000000111000011100000011100000011110000111000000111000111000000000011110;
assign over[150*11-1:150*10]=150'b000000011100000000000001110000001110111000000011110000000011110000000000000000000001111000011100000011100000011110000111100000111000111100000001111100;
assign over[150*12-1:150*11]=150'b000000011100001111111111100000000111110000000000111111111111000000000000000111111111110000011100000011100000011110000111111111111000111111111111110000;
assign over[150*13-1:150*12]=150'b000000010000000001111100000000000000000000000000000011110000000000000000000001111100000000010000000000100000001100000100001111000000000001111100000000;
assign over[150*14-1:150*13]=150'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
 wire [2303:0] win;

assign win[128*1 -1:128*0 ]=128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
assign win[128*2 -1:128*1 ]=128'b00000000000000000000000000000000000000000000000000000000111111000000000000000000000000000000000000000000000000000000000000000000;
assign win[128*3 -1:128*2 ]=128'b01111111000000000000000000000000000000000000000000000001111111100000111111100000000000000000111111111000000000000000000111111110;
assign win[128*4 -1:128*3 ]=128'b01111111000000000000000000000000000000000000000000000000111111000000011111110000000000000000111111111000000000000000001111111100;
assign win[128*5 -1:128*4 ]=128'b00111111000000000000000000000000000000000000000000000000000000000000001111111000000000000001111111111100000000000000011111111000;
assign win[128*6 -1:128*5 ]=128'b00111111000000000000000000000000000000000000000000000000000000000000000111111000000000000011111101111110000000000000011111110000;
assign win[128*7 -1:128*6 ]=128'b00111111000000000000000111111111111100001111110000000000111111000000000111111100000000000111111100111111000000000000111111100000;
assign win[128*8 -1:128*7 ]=128'b00111111000000000000111111111111111111011111110000000001111111000000000011111110000000000111111000011111100000000001111111000000;
assign win[128*9 -1:128*8 ]=128'b00111111000000000001111111100000000001111111110000000000111111000000000001111110000000001111110000001111110000000011111110000000;
assign win[128*10-1:128*9 ]=128'b00111111000000000011111110000000000000011111110000000000111111000000000000111111000000011111100000001111110000000011111100000000;
assign win[128*11-1:128*10]=128'b00111111000000000011111110000000000000011111110000000000111111000000000000111111100000111111100000000111111000000111111100000000;
assign win[128*12-1:128*11]=128'b00111111000000000011111110000000000000011111110000000000111111000000000000011111110001111111000000000011111100001111111000000000;
assign win[128*13-1:128*12]=128'b00111110000000000011111110000000000000011111110000000000111111000000000000001111110001111110000000000001111110011111110000000000;
assign win[128*14-1:128*13]=128'b00000000000000000011111110000000000000011111110000000000111111000000000000000111111011111100000000000000111111011111100000000000;
assign win[128*15-1:128*14]=128'b00011100000000000011111110000000000000011111110000000000111111000000000000000011111111111000000000000000111111111111000000000000;
assign win[128*16-1:128*15]=128'b01111111100000000011111110000000000000011111110000000000111111000000000000000001111111111000000000000000011111111111000000000000;
assign win[128*17-1:128*16]=128'b01111111100000000011111110000000000000011111110000000000111111000000000000000001111111110000000000000000001111111110000000000000;
assign win[128*18-1:128*17]=128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	 
	 always@(posedge clk or posedge rst)begin//boss action cycle
        if(rst)
            sec_cnt <= 0;
        else if(sec_cnt[30:26] == 5'b11111)
            sec_cnt <= 0;
        else
            sec_cnt <= sec_cnt+1;
    end
    always@(posedge clk or posedge rst)begin
        if(rst)
            mode <= SBOLT;
		  else if(victory)
				mode <= VICTORY;
        else
            case(sec_cnt[30:26])
            5'b00000:mode <= SBOLT;
            5'b01010:mode <= BBOLT;
            5'b10100:mode <= LAZER;
            default mode <= mode;
            endcase
    end
    always@(posedge refresh or posedge rst)begin
        if(rst)
            sbolt_run <= 0;
        else if(sec_cnt[25:20] == 0)
            sbolt_run <= 0;
        else if(mode == SBOLT)
            sbolt_run <= sbolt_run+1;
        else
            sbolt_run <= 0;
    end
	 always@(posedge refresh or posedge rst)begin
        if(rst)
            cbolt_run <= 0;
        else if(sec_cnt[26:20] == 0)
            cbolt_run <= 0;
        else
            cbolt_run <= cbolt_run+1;
    end
    always@(posedge refresh or posedge rst)begin
        if(rst)
        bbolt_run <= 0;
        else if(sec_cnt[26:20] == 7'b0000000)
        bbolt_run <= 0;
        else if(mode == BBOLT)
        bbolt_run <= bbolt_run+1;
        else
        bbolt_run <= 0;
    end 
    always@(posedge clk or posedge rst)begin
        if(rst)
        lazer <= 0;
        else
        case(sec_cnt[30:26])
        5'b10100:lazer <= 1;
        5'b10110:lazer <= 2;
        5'b10111:lazer <= 3;
        5'b11001:lazer <= 4;
        5'b11010:lazer <= 1;
        5'b11100:lazer <= 2;
        5'b11101:lazer <= 5;
        5'b11110:lazer <= 6;
		  5'b00000:lazer <= 0;
        default:lazer <= 0;
        endcase
    end
    assign died = danger[0]|danger[1]|danger[2];
    assign  refresh = sec_cnt[18];
	 always@(posedge refresh or posedge rst)begin
	     if(rst)
		  die <= 0;
		  else
		  if(died)
		  die <= 1;
		  else
		  die <= die;
	 end
    always@(posedge clk or posedge rst)begin
	     if(rst)begin
            left <= 0;
				right <= 0;
				up <= 0;
				down <= 0;
				shoot <= 0;
        end
		  else
		  case(k_value[8:0])
		  9'h175:up <= ~k_value[9];
		  9'h172:down <= ~k_value[9];
		  9'h16B:left <= ~k_value[9];
		  9'h174:right <= ~k_value[9];
		  9'h029:shoot <= ~k_value[9];
		  default: begin
				up <= up;
				down <= down;
				left <= left;
				right <= right;
				shoot <= shoot;
		  end
		  endcase
	 end
	 
    always@(posedge refresh or posedge rst)//ship position
    begin
        if(rst)
        begin
            ship_X <= 400;
            ship_Y <= 520;
        end
        else 
        begin
            ship_X <= ship_X + right*3 -left*3;
            ship_Y <= ship_Y + down*3 - up*3;
        end
    end
    always@(*)//shooting state machine
    begin
        if(rst)
        c_state <= 0;
        else
        c_state <= n_state;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        cooldown <= 0;
        else
        cooldown <=(shoot && c_state == 0)?0:cooldown+1;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        n_state <= 0;
        else 
        case(c_state)
        0:if(shoot)n_state <= 1;else n_state <= 0;
        1:if(cooldown > 25000000) n_state <= 0;else n_state <= 1;
        default n_state <= 0;
        endcase
    end
    always@(posedge clk or posedge rst)//bullet tag
    begin
        if(rst)
            hit <= 0;
        else if((bull_X-400)*(bull_X-400)+(bull_Y-155)*(bull_Y-155)<155*155 && health >0 && c_state == 1)
            hit <= 1;
        else if(bull_Y <0)
            hit <= 1;
        else if(c_state == 0)
            hit <= 0;
        else hit <= hit;
    end
    always@(posedge refresh or posedge rst)//bullet position
    begin
        if(rst)
        begin
            bull_X <= ship_X;
            bull_Y <= ship_Y+15;
        end
        else if(c_state == 1 && !die)
        begin
            if(hit)
            begin
            bull_X <= ship_X;
            bull_Y <= ship_Y+15;
            end
            else
            begin
            bull_X <= bull_X;
            bull_Y <= bull_Y-15;
            end
        end
        else 
        begin
            bull_X <= ship_X;
            bull_Y <= ship_Y+15;
        end
    end
    always@(posedge refresh or posedge rst)begin//health bar
	  if(rst)begin
			health<=200;
			victory <= 0;
			end
			else if(health <= 0)begin
				health <= health;
				victory <= 1;
				end
	  else if((bull_X-400)*(bull_X-400)+(bull_Y-155)*(bull_Y-155)<155*155 && health >0 && !die)begin
	      health<=health-10;
	    end
	  else health<=health;
	end
	always@(posedge clk) begin
		 if(die&&(x>=325&&x<475)&&(y>=293 &&y<307)&&over[(y-293)*150+x-325])begin
			  R<=1;
			  G<=1;
			  B<=1;
		 end
		 else if(victory && x>=336 && x < 464 && y>=291 && y<309&&win[128*(y-291)+x-336])
			  {R,G,B}<= 3'b111;
		 else if((x>10&&x<health+10)&&(y>5&&y<15))begin//health bar
	       R<=1;
		    G<=0;
		    B<=0;
	    end
	    else if((x>health+10&&x<200)&&(y>5&&y<15))begin
	        R<=0;
	        G<=0;
	        B<=0;
	    end 
        else if((x>0&&x<220)&&(y>0&&y<20))begin//health bar
	        R<=1;
	  	    G<=1;
		    B<=1;
	    end
        else if(!die && ((y>=-2*(x-ship_X)+ship_Y&&y<=ship_Y+30 && x <=ship_X-5)||
		          (y>=2*(x-ship_X)+ship_Y && y<=ship_Y+30 && x>=ship_X+5)))begin//player
	        R<=1;
	        G<=0;
		    B<=0;
	    end
	    else if(!die && y>=2*(x-ship_X) +ship_Y && y>=-2*(x-ship_X)+ship_Y && y<=ship_Y+20)begin//player
		    R<=1;
	       G<=1;
		    B<=0;
	    end
        else if(!die &&(x-bull_X)*(x-bull_X)+(y-bull_Y)*(y-bull_Y)<5*5 && c_state == 1)begin//bullet
            R <= 1;
            G <= 0;
            B <= 0;
        end
		  else if(area == 1)begin//boss constant bolt
          R<=1;
		    G<=sec_cnt[24];
		    B<=1;    
        end
        else if(area == 2)begin//boss small bolt
		    R<=1;
		    G<=1;
		    B<=1;
		  end
        else if(area == 3)begin//boss big bolt
		    R<=0;
		    G<=0;
		    B<=1;	
		end
        else if(lazer==1&&mode == LAZER &&((x-200)*(x-200)+(y-540)*(y-540)<15*15||
								   (x-400)*(x-400)+(y-540)*(y-540)<15*15||
								   (x-600)*(x-600)+(y-540)*(y-540)<15*15))begin
        R<=1;
		  G<=sec_cnt[24];
        B<=0;
    end
    else if (lazer ==2 && area ==4)begin
        R<=1;
		  G<=0;
        B<=0;
    end	
	else if (lazer==3&&mode == LAZER &&((x-100)*(x-100)+(y-540)*(y-540)<15*15||
								    (x-300)*(x-300)+(y-540)*(y-540)<15*15||
								    (x-500)*(x-500)+(y-540)*(y-540)<15*15||
									(x-700)*(x-700)+(y-540)*(y-540)<15*15))begin
        R<=1;
		  G<=sec_cnt[24];
        B<=0;
    end	
	else if (lazer ==4 && area == 5)begin
        R<=1;
		  G<=0;
        B<=0;
    end
	else if(lazer==5&&mode == LAZER &&(((x-50)*(x-50)+(y-520)*(y-520)<15*15)||
									((x-750)*(x-750)+(y-520)*(y-520)<15*15)))begin				
		R<=1;
		G<=sec_cnt[24];
      B<=0;														
	end
	else if(lazer==6&& area == 6)begin
	    R<=1;
		 G<=0;
       B<=0;
	end
	     else if(!victory &&(((x-400)*(x-400)+(y-155)*(y-155)<50*50)||
					(((x>=403&&x<=408)||(x>=392&&x<=397))&&(y>=200&&y<=350))))begin//boss body
            if(mode == BBOLT)begin
                R<=1;
                G<=sec_cnt[24];
                B<=1;
            end
            else
            begin
                R<=1;
                G<=0;
                B<=1;	
            end            
        end
        else if(!victory && area == 7)begin
            R<=0;
            G<=1;
            B<=1;
        end	  
        else if(!victory && ((x-500)*(x-500)+(y-200)*(y-200)<80*80 || (x-300)*(x-300)+(y-200)*(y-200)<80*80))begin//boss body
            if(mode == BBOLT)begin
                R<=1;
                G<=sec_cnt[24];
                B<=1;
            end
            else begin
                R<=1;
                G<=0;
                B<=1;
            end
        end
        else
        begin
            R <= 0;
            G <= 0;
            B <= 0;
        end
	end
	assign VGA_RED=R;
	assign VGA_GREEN=G;
	assign VGA_BLUE=B;
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:13 12/05/2016 
// Design Name: 
// Module Name:    CAL 
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
module CAL(
    input clk,
    input rst,
    input sqrt,
    input mul,
    input add,
    input s0,
    input s1,
    input s2,
    input s3,
    output reg [7:0] ans
    );


parameter IDLE=0,ADD=1,MUL=2,SQRT=3,BOUND=4;
reg [3:0] cstate,nstate;
reg [3:0] mode;
reg [7:0] tans;
wire [7:0] root;

integer counter;

sqrt r(.x_in(tans),.x_out(root[4:0]));
assign root[7:5]=0;

always @(posedge clk or posedge rst)begin

  if(rst)cstate<=IDLE;
  
  else cstate<=nstate;

end

always @(*)begin

  if(rst)nstate<=IDLE;
  else begin
    case(cstate)
	  
	  IDLE:begin
            if(sqrt)nstate<=SQRT;
	         else if(mul)nstate<=MUL;
	         else if(add)nstate<=ADD;
	         else nstate<=IDLE;
          end
		   
	  SQRT:nstate<=BOUND;
      
     MUL:nstate<=BOUND;	   
	  
     ADD:nstate<=BOUND;
      
	  BOUND:begin
             if(counter>2000)nstate<=IDLE;
	          else nstate<=BOUND;
           end

	  default:
	      nstate<=IDLE;
	endcase
   end
end


always@(posedge clk or posedge rst)begin

  if(rst)tans<=0;

  else if((add||mul||sqrt)&&cstate==IDLE)tans<=ans;
  
  else tans<=tans; 
	
end



always @(posedge clk or posedge rst)begin

  if(rst)begin
           ans<=0;
           mode<=0;
  end

  else if(cstate==IDLE)begin

       case(mode)
         0:ans<=tans+{0,0,0,0,s3,s2,s1,s0};
         1:ans<=tans*{0,0,0,0,s3,s2,s1,s0};
         default:
                 ans<=ans;
       endcase
  end

  else if(cstate==ADD)begin

       ans<=tans+{0,0,0,0,s3,s2,s1,s0}; 
       mode<=0;	

  end
	 
  else if(cstate==MUL)begin

       ans<=tans*{0,0,0,0,s3,s2,s1,s0};
       mode<=1;

  end
	 
  else if(cstate==SQRT)begin

       ans<=root;
       mode<=2;

  end
	 
  else begin

         ans<=ans;
         mode<=mode;
  end
end



always @(posedge clk)begin

  if(rst)counter<=0;
	 
  else if(cstate==BOUND)begin

    if(counter>2000)counter<=0;

    else if(sqrt||mul||add)counter<=0;

    else counter<=counter+1;

  end
  
  else counter<=counter;

end
 
endmodule

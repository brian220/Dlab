`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:57:24 11/17/2016 
// Design Name: 
// Module Name:    DLAU 
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
module DALU(
    // Input signals
	clk,
	rst,
	in_valid,
	instruction,
  // Output signals
  out_valid,
  out
    );

input clk;
input rst;
input in_valid;
input [18:0] instruction;

output reg out_valid;
output reg [15:0]out;

reg counter_out;
reg counter_in;
reg [1:0]cstate,nstate;

parameter IDLE=0,IN=1,OUT=2;

reg signed [5:0]temp_s,temp_t;
reg signed [9:0]temp_i;
reg signed [3:0]temp_l;
reg [3:0]mode;

always@(posedge clk)begin

     if(rst==1)cstate<=IDLE;
		   
     else 
           cstate<=nstate;
end

always@(*)begin

    if(rst==1)nstate<=IDLE;

	else begin
         case(cstate)
		 
	      IDLE:nstate<=IN;
				   
          IN:begin
		         if(in_valid)nstate<=OUT; 
                 else nstate<=IN;				 
              end
				 
          OUT:begin
		  
		        if(counter_out)nstate<=IDLE;
		        else nstate<=OUT;
	          end
				  
	     default:
		     nstate<=IDLE;
		 endcase
    end
end

always@(posedge clk)begin

      if(rst==1)begin
	            temp_s<=0;
				temp_t<=0;
				temp_i<=0;
                temp_l<=0;
				mode<=0;
	            end
				
	  else if(counter_out==1)begin

	            temp_s<=0;
				temp_t<=0;
				temp_i<=0;
                temp_l<=0;
				mode<=0;
	  end
	  
      else if(cstate==IN)begin
	  
	       if(instruction[18:16]==3'b000)begin

	        case(instruction[3:0])
			     4'b0000:begin
				         temp_s<=instruction[15:10];
						 temp_t<=instruction[9:4];
						 mode<=0;
						 end
				 4'b0001:begin
				         temp_s<=instruction[15:10];
						 temp_t<=instruction[9:4];
						 mode<=1;
						 end
				 4'b0010:begin
				         temp_s<=instruction[15:10];
						 temp_t<=instruction[9:4];
						 mode<=2;
						 end
				 4'b0011:begin
				         temp_s<=instruction[15:10];
						 temp_t<=instruction[9:4];
						 mode<=3;
						 end
				 4'b0100:begin
				         temp_s<=instruction[15:10];
						 temp_t<=instruction[9:4];
						 mode<=4;
						 end
				 default:begin
				         temp_s<=temp_s;
						 temp_t<=temp_t;
						 mode<=mode;
				         end
				 endcase
	   end
	   
	   else begin

	       case(instruction[18:16])

	            3'b001:begin
				       temp_s<=instruction[15:10];
					   temp_t<=instruction[9:4];
                       temp_l<=instruction[3:0];
					   mode<=5;
					   end
				3'b010:begin
				       temp_s<=instruction[15:10];
					   temp_t<=instruction[9:4];
                       temp_l<=instruction[3:0];
					   mode<=6;
					   end
				3'b011:begin
				       temp_s<=instruction[15:10];
					   temp_i<=instruction[9:0];
					   mode<=7;
					   end
				3'b100:begin
				       temp_s<=instruction[15:10];
					   temp_i<=instruction[9:0];
					   mode<=8;
					   end
				default:begin
				       temp_s<=temp_s;
					   temp_t<=temp_t;
					   temp_i<=temp_i;
                       temp_l<=temp_l;
					   mode<=mode;
				       end
			endcase
	  end
	end

	else begin
	            temp_s<=temp_s;
			    temp_t<=temp_t;
			    temp_i<=temp_i;
                temp_l<=temp_l;
		        mode<=mode;
	end
end


always@(posedge clk)begin

  if(rst==1)counter_out<=0;
  
  else if(counter_out==1)counter_out<=0;
			
  else if(cstate==OUT)counter_out<=counter_out+1;

  else counter_out<=counter_out;

end

always@(posedge clk)begin

  if(rst==1)begin
            out<=0;
            out_valid<=0;
  end
			
  else if(counter_out==1)begin
            out<=0;
            out_valid<=0;
  end  
  
  else if(cstate==OUT)begin
    case(mode)
	     0:begin
		   out<=temp_s & temp_t;
		   out_valid<=1;
		   end
		 1:begin
		   out<=temp_s | temp_t;
		   out_valid<=1;
		   end	 
		 2:begin
		   out<=temp_s ^ temp_t;
		   out_valid<=1;
		   end
		 3:begin
		   out<=temp_s + temp_t;
		   out_valid<=1;
		   end
		 4:begin
		   out<=temp_s - temp_t;
		   out_valid<=1;
		   end
		 5:begin
		   out<=temp_s * temp_t * temp_l;
		   out_valid<=1;
		   end
         6:begin
		   out<=(temp_s + temp_t + temp_l) * (temp_s + temp_t + temp_l);
		   out_valid<=1;
		   end
		 7:begin
		   out<=temp_s + temp_i;
		   out_valid<=1;
		   end
		 8:begin
		   out<=temp_s - temp_i;
		   out_valid<=1;
		   end
		 default:begin
		   out<=out;
	       out_valid<=out_valid;
		 end
	endcase
  end
  else begin

    out<=out;
    out_valid<=out_valid;  
  end
end

endmodule
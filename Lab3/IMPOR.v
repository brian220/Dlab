module IMPOR(
	out,
	out_valid,
	ready,
	in,
	mode,
	in_valid,
	clk,
	rst_n
);



output  reg [2:0] out;
output  reg out_valid;
output  reg ready;
input  [2:0] in;
input  [2:0] mode;
input  in_valid;
input  clk;
input  rst_n;
parameter IDLE=0, INPUT=1,EX=2,OUTPUT=3;
reg [2:0] current_state;
reg [2:0] a0,a1,a2,a3,a4,a5,a6,a7,a8;
reg [3:0] count_in;
reg [3:0] count_out;
reg grid_done,M_done;



always@(posedge clk or negedge rst_n)begin
	if(!rst_n)current_state<=IDLE;
	else
	begin
	case(current_state)
	
	IDLE:current_state<=INPUT;
	INPUT:if(count_in==8)current_state<=EX;
		else
                        current_state<=current_state;
	
	EX:if(mode==0)current_state<=OUTPUT;
		else
			current_state<=current_state;

	OUTPUT:if(count_out==10)current_state<=IDLE;
		else
			current_state<=current_state;

	default: current_state<=IDLE;

	endcase
    end
end

always@(posedge clk or negedge rst_n)begin
	
		if(!rst_n)count_in<=0;

		else if(ready)count_in<=count_in+1;
		else if(in_valid==0)count_in<=0;
		else 
			count_in<=count_in;

end
always@(posedge clk or  negedge rst_n)begin
	if(!rst_n)begin
			grid_done<=0;
			a0<=0;
			a1<=0;
			a2<=0;
			a3<=0;
			a4<=0;
                        a5<=0;
                        a6<=0;
                        a7<=0;
			a8<=0;		
		  end
	else
	begin
	if(count_in==9)begin
			grid_done<=0;
			end
	if(count_out==10)begin
                        a0<=0;
                        a1<=0;
                        a2<=0;
                        a3<=0;
                        a4<=0;
                        a5<=0;
                        a6<=0;
                        a7<=0;
                        a8<=0;
                        end

	if(current_state==INPUT)begin
		case(count_in)
			4'b0000:begin
				a0<=in;
				end
			4'b0001:begin
				a1<=in;
				end
			4'b0010:begin
				a2<=in;
				end
			4'b0011:begin
				a3<=in;
				end
			4'b0100:begin
				a4<=in;			
				end
			4'b0101:begin
				a5<=in;
				end
			4'b0110:begin
				a6<=in;
				end
			4'b0111:begin
				a7<=in;
				end
			4'b1000:begin
				a8<=in;
				grid_done<=1;
				end
				
			default:begin

				a0<=a0;
                        	a1<=a1;
                       		a2<=a2;
                        	a3<=a3;
                        	a4<=a4;
                        	a5<=a5;
                        	a6<=a6;
                        	a7<=a7;
                        	a8<=a8;
				grid_done<=grid_done;
				end		
			endcase
	end
	
        else if(current_state==EX)begin
			if(count_out==10)begin
					a0<=0;
					a1<=0;
					a2<=0;
					a3<=0;
					a4<=0;
					a5<=0;
                                        a6<=0;
                                        a7<=0;
                                        a8<=0;
			end
                        case(mode)
                                3'b001:begin
                                        a0<=a2;
                                        a2<=a0;
                                        a3<=a5;
                                        a5<=a3;
                                        a6<=a8;
                                        a8<=a6;
                                       
                                        end
                                3'b010:begin
                                        a0<=a6;
                                        a6<=a0;
                                        a1<=a7;
                                        a7<=a1;
                                        a2<=a8;
                                        a8<=a2;
                                       
                                        end
                                3'b011:begin
                                        a0<=a2;
                                        a1<=a5;
                                        a2<=a8;
                                        a3<=a1;
                                        a5<=a7;
                                        a6<=a0;
                                        a7<=a3;
                                        a8<=a6;
                                      
                                        end
                                3'b100:begin
                                        a0<=a6;
                                        a1<=a3;
                                        a2<=a0;
                                        a3<=a7;
					a5<=a1;
                                        a6<=a8;
                                        a7<=a5;
                                        a8<=a2;
                                       
                                        end
                                3'b101:begin
                                        if(a0+1<=7)a0<=a0+1;
                                        else a0<=7;
                                        if(a3+1<=7)a3<=a3+1;
                                        else a3<=7;
                                        if(a6+1<=7)a6<=a6+1;
                                        else a6<=7;
                                        end
                                 3'b110:begin
                                        if(a1+1<=7)a1<=a1+1;
                                        else a1<=7;
                                        if(a4+1<=7)a4<=a4+1;
                                        else a4<=7;
                                        if(a7+1<=7)a7<=a7+1;
                                        else a7<=7;
                                        end

                                 3'b111:begin
                                        if(a2+1<=7)a2<=a2+1;
                                        else a2<=7;
                                        if(a5+1<=7)a5<=a5+1;
                                        else a5<=7;
                                        if(a8+1<=7)a8<=a8+1;
                                        else a8<=7;
                                       end
                                default:begin

                                        a0<=a0;
                                        a1<=a1;
                                        a2<=a2;
                                        a3<=a3;
                                        a4<=a4;
                                        a5<=a5;
                                        a6<=a6;
					a7<=a7;
					a8<=a8;
					
					end
				endcase
			end
		else begin
				a0<=a0;
                                a1<=a1;
                                a2<=a2;
                                a3<=a3;
                                a4<=a4;
                                a5<=a5;
                                a6<=a6;
                                a7<=a7;
                                a8<=a8;
				grid_done<=grid_done;
		

		end
	end
end

//ready
always@(posedge clk or negedge rst_n)begin

	if(!rst_n)ready<=0;
	
	else if(current_state==INPUT)ready<=1;

	else if(count_out==10)ready<=0;
	
	else
		ready<=ready;

end


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)count_out<=0;
	
	else if(count_out==10)count_out<=0;

	else if(current_state==OUTPUT)count_out<=count_out+1;

	else
		count_out<=count_out;
end

//out_valid
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)out_valid<=0;	
	
	else if(count_out==10)out_valid<=0;

	else if(count_out>=1)out_valid<=1;

	else
		out_valid<=out_valid;
	
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)out<=0;

	else if(current_state==OUTPUT)begin
	case(count_out)
	1:out<=a0;
	2:out<=a1;
	3:out<=a2;
	4:out<=a3;
	5:out<=a4;
	6:out<=a5;
	7:out<=a6;
	8:out<=a7;
	9:out<=a8;
	10:out<=0;
	default:out<=out;
	endcase
	end
	else
		out<=out;
end
endmodule

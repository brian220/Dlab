module CONVCOR(	
	clk, 
	rst_n, 
	in_valid, 
	in_a,
	in_b,
	in_mode,	
	out_valid, 
	out
);
				
//---------------------------------
//  input and output declaration
//---------------------------------  

input              clk;
input              rst_n;
input              in_valid;
input signed    [15:0]     in_a;
input signed	[15:0]     in_b;
input 	           in_mode;
output  reg        out_valid;
output  reg [35:0] out;

reg signed [17:0] out0[1:0],out1[1:0],out2[1:0],out3[1:0],out4[1:0],out5[1:0],outc[1:0];
reg signed[7:0] at0[1:0],at1[1:0],at2[1:0];
reg signed[7:0] bt0[1:0],bt1[1:0],bt2[1:0];
reg [3:0] counter1,counter2,counter;
reg mode;
reg flag;

//----------------------------------
// reg and wire declaration
//--------------------------------- 
 always@(posedge clk)
	begin
		if(rst_n==0)
		begin
		out_valid<=1'b0;
		out<=36'd0;
		out0[0]<=0;
		out0[1]<=0;
		out1[0]<=0;
		out1[1]<=0;
		out2[0]<=0;
		out2[1]<=0;
		out3[0]<=0;
		out3[1]<=0;
		out4[0]<=0;
		out4[1]<=0;
		out5[0]<=0;
		out5[1]<=0;
		outc[0]<=0;
		outc[1]<=0;
		counter<=0;
		counter1<=0;
		counter2<=0;
		flag<=0;
		end
	end


always@(posedge clk)
begin
	if(flag==0)
	begin
		if(in_mode==0)
		begin
		mode<=0;
		end
		else if(in_mode==1)
		begin
		mode<=1;
		end
		if(in_valid==1&&counter1==0)
		begin
		{at0[0],at0[1]}<=in_a;
	        {bt0[0],bt0[1]}<=in_b;
		counter1<=counter1+1;
		end

		else if(in_valid==1&&counter1==1)
		begin
	        {at1[0],at1[1]}<=in_a;
                {bt1[0],bt1[1]}<=in_b;
		counter1<=counter1+1;
		end

		else if(in_valid==1&&counter1==2)
		begin
		{at2[0],at2[1]}<=in_a;
                {bt2[0],bt2[1]}<=in_b;
		counter1<=counter1+1;
		flag<=1;	
		end 
	 		                            
	end

end
			
always@(posedge clk)
begin
	if(flag==1)
	begin	
		if(mode==0)
		begin
			if(in_valid==0&&counter2==0)
			begin
			out=0;
		        out0[0]=(at0[0]*bt0[0])-(at0[1]*bt0[1]);
			out0[1]=(at0[0]*bt0[1])+(at0[1]*bt0[0]);
			out={out0[0],out0[1]};
			counter2=counter2+1;
			out_valid=1;				
			end

			else if(in_valid==0&&counter2==1)
			begin
			//$display("kk");
			out=0;
			out1[0]=((at0[0]*bt1[0])-(at0[1]*bt1[1]))
			+((at1[0]*bt0[0])-(at1[1]*bt0[1]));

			out1[1]=((at0[0]*bt1[1])+(at0[1]*bt1[0]))
			+((at1[0]*bt0[1])+(at1[1]*bt0[0]));

			out={out1[0],out1[1]};
			counter2=counter2+1;
			out_valid=1;
			end

			else if(in_valid==0&&counter2==2)
                        begin 
	
			out=0;
			out2[0]=((at0[0]*bt2[0])-(at0[1]*bt2[1]))
			+((at1[0]*bt1[0])-(at1[1]*bt1[1]))
                        +((at2[0]*bt0[0])-(at2[1]*bt0[1]));
                   	
			out2[1]=((at0[0]*bt2[1])+(at0[1]*bt2[0]))
			+((at1[0]*bt1[1])+(at1[1]*bt1[0]))
			+((at2[0]*bt0[1])+(at2[1]*bt0[0]));
			
			out={out2[0],out2[1]};
                        counter2=counter2+1;
			out_valid=1;
                        end


			else if(in_valid==0&&counter2==3)		
                        begin
			out=0;
			out3[0]=((at1[0]*bt2[0])-(at1[1]*bt2[1]))
			+((at2[0]*bt1[0])-(at2[1]*bt1[1]));
                   	out3[1]=((at1[0]*bt2[1])+(at1[1]*bt2[0]))
			+((at2[0]*bt1[1])+(at2[1]*bt1[0]));

			out={out3[0],out3[1]};
                        counter2=counter2+1;
			out_valid=1;
                        end
			
			else if(in_valid==0&&counter2==4)
			begin
			out=0;
			out4[0]=(at2[0]*bt2[0])-(at2[1]*bt2[1]);
			out4[1]=(at2[0]*bt2[1])+(at2[1]*bt2[0]);
                        out={out4[0],out4[1]};
			counter2=counter2+1;
			out_valid=1;
			end
			
			else if(counter2==5)
			begin
			out_valid=0;
                        counter=0;
                        out=0;
                        counter1=0;
                        counter2=0;
                        flag=0;

			out0[0]<=0;
               		out0[1]<=0;
               		out1[0]<=0;
               	        out1[1]<=0;
               		out2[0]<=0;
               		out2[1]<=0;
                	out3[0]<=0;
               	 	out3[1]<=0;
               	 	out4[0]<=0;
                	out4[1]<=0;
                	out5[0]<=0;
                	out5[1]<=0;
                	outc[0]<=0;
                	outc[1]<=0;

			end
		end
		else if(mode==1)
		begin
			if(counter==0)
			begin
		/*	$display(at0[0],bt0[0]);
			$display(at0[1],bt0[1]);
			$display(at1[0],bt1[0]);
			$display(at1[1],bt1[1]);
		        $display(at2[0],bt2[0]);
			$display(at2[1],bt2[1]);*/

			outc[0]=(at0[0]*bt0[0])+(at0[1]*bt0[1])+(at1[0]*bt1[0])
			+(at1[1]*bt1[1])+(at2[0]*bt2[0])+(at2[1]*bt2[1]);
			outc[1]=(at0[1]*bt0[0])-(at0[0]*bt0[1])+(at1[1]*bt1[0])
                        -(at1[0]*bt1[1])+(at2[1]*bt2[0])-(at2[0]*bt2[1]);
		//	$display(outc[0],outc[1]);

                        out={outc[0],outc[1]};
			out_valid=1;
			counter=counter+1;
		//	$display(out);
			end
			else	if(counter==1)
			begin
			out_valid=0;
			counter=0;
			out=0;
			counter1=0;
			counter2=0;
			flag=0;
		/*	out0[0]<=0;
                        out0[1]<=0;
                        out1[0]<=0;
                        out1[1]<=0;
                        out2[0]<=0;
                        out2[1]<=0;
                        out3[0]<=0;
                        out3[1]<=0;
                        out4[0]<=0;
                        out4[1]<=0;
                        out5[0]<=0;
                        out5[1]<=0;
                        outc[0]<=0;
                        outc[1]<=0;
					*/
			end
		end		

	end

end
 //----------------------------------
//
//         My design
//
//----------------------------------


endmodule

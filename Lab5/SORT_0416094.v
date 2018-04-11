module SORT(
  // Input signals
  clk,
  rst_n,
  in_valid1,
  in_valid2,
  in,
  mode,
  op,
  // Output signals
  out_valid,
  out
);
output reg out_valid;
output reg [4:0] out;
input clk;
input rst_n;
input in_valid1;
input in_valid2;
input [4:0] in;
input mode;
input [1:0] op;
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
parameter IDLE=0,INPUT=1,EX=2,OUT=3;

//---------------------------------------------------------------------
// PARAMETER DECLARATION
//---------------------------------------------------------------------
reg [4:0] numset [0:9];
reg [2:0] cstate,nstate;
reg [1:0] get_op;
reg [3:0] count_out;
reg [3:0] count_ex;
reg temp_mode;
reg [3:0] index;
reg tag;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION                             
//---------------------------------------------------------------------

always@(posedge clk or negedge rst_n)begin

       if(!rst_n)cstate<=IDLE;

       else 
               cstate<=nstate;
end

always@(*)begin
       
       case(cstate)
	   
              IDLE:nstate<=INPUT;
 
              INPUT:if(op==2&&in_valid1)nstate<=EX;

                    else
                            nstate<=INPUT;

              EX:if(count_ex==9)nstate<=OUT;
             
                    else 
                           nstate<=EX;

              OUT:if(count_out==9)nstate<=IDLE;
 
                    else
                           nstate<=OUT;
              default:
                    nstate<=IDLE;
       
        endcase	   
end

//---------------------------------------------------------------------
//   Finite-State Mechine                                          
//---------------------------------------------------------------------
	
always@(posedge clk or negedge rst_n)begin

       if(!rst_n)begin
	            tag<=0;
	            index<=0;
	            numset[0]<=0;
		    numset[1]<=0;
		    numset[2]<=0;
		    numset[3]<=0;
		    numset[4]<=0;
	            numset[5]<=0;
	            numset[6]<=0;
		    numset[7]<=0;
		    numset[8]<=0;
		    numset[9]<=0;
        end

        else if(count_out==10)begin

                    tag<=0;
                    index<=0;
                    numset[0]<=0;
                    numset[1]<=0;
                    numset[2]<=0;
                    numset[3]<=0;
                    numset[4]<=0;
                    numset[5]<=0;
                    numset[6]<=0;
                    numset[7]<=0;
                    numset[8]<=0;
                    numset[9]<=0;

        end
			
	else if(cstate==INPUT)begin
		
	     if(in_valid1==1&&op==1)begin

                  numset[index]<=in;
				
                  if(index<10)index<=index+1;
				
		  else index<=index;
				
             end
        
             else if(op==0&&temp_mode==0&&in_valid1==1)begin

                   index<=index-1;
		   numset[index-1]<=0;

	     end
				
             else if(op==0&&temp_mode==1&&in_valid1==1)begin

                   index<=index-1;
		   numset[0]<=numset[1];
		   numset[1]<=numset[2];
		   numset[2]<=numset[3];
		   numset[3]<=numset[4];
		   numset[4]<=numset[5];
	           numset[5]<=numset[6];
	           numset[6]<=numset[7];
		   numset[7]<=numset[8];
		   numset[8]<=numset[9];
		   numset[9]<=0;

	     end
				
             else begin
			    index<=index;
			    numset[0]<=numset[0];
			    numset[1]<=numset[1];
			    numset[2]<=numset[2];
			    numset[3]<=numset[3];
			    numset[4]<=numset[4];
			    numset[5]<=numset[5];
			    numset[6]<=numset[6];
			    numset[7]<=numset[7];
			    numset[8]<=numset[8];
			    numset[9]<=numset[9];
	     end
	 end

	 else if(cstate==EX)begin

	           if(tag==0)begin
		        tag<=1;

	                if(numset[0]<numset[1])begin			
		             numset[0]<=numset[1];
		             numset[1]<=numset[0];
			end				
			else begin
                            numset[0]<=numset[0];
			    numset[1]<=numset[1];
                        end
					
			if(numset[2]<numset[3])begin						
		            numset[2]<=numset[3];
			    numset[3]<=numset[2];
			end
			else begin
                            numset[2]<=numset[2];
			    numset[3]<=numset[3];
                        end
					
		        if(numset[4]<numset[5])begin	
		            numset[4]<=numset[5];
		            numset[5]<=numset[4];
			end					
                        else begin
                            numset[4]<=numset[4];
			    numset[5]<=numset[5];
                        end
					
		        if(numset[6]<numset[7])begin	
			    numset[6]<=numset[7];
			    numset[7]<=numset[6];
			end		
                        else begin
                            numset[6]<=numset[6];
			    numset[7]<=numset[7];
                        end
					
		        if(numset[8]<numset[9])begin	
			    numset[8]<=numset[9];
		            numset[9]<=numset[8];
	                end
			else begin
                            numset[8]<=numset[8];
			    numset[9]<=numset[9];
                        end
		    end
	            	
		    else begin
		         tag<=0;

		         if(numset[1]<numset[2])begin			
		            numset[1]<=numset[2];
			    numset[2]<=numset[1];
			 end
			 else begin
                            numset[1]<=numset[1];
			    numset[2]<=numset[2];
                         end
					
			 if(numset[3]<numset[4])begin						
		            numset[3]<=numset[4];
			    numset[4]<=numset[3];
			 end
			 else begin
                            numset[3]<=numset[3];
			    numset[4]<=numset[4];
                         end
					
		         if(numset[5]<numset[6])begin	
		            numset[5]<=numset[6];
		            numset[6]<=numset[5];
			 end
			 else begin
                            numset[5]<=numset[5];
			    numset[6]<=numset[6];
                         end
					
		         if(numset[7]<numset[8])begin	
			    numset[7]<=numset[8];
			    numset[8]<=numset[7];
			 end		
                         else begin
                            numset[7]<=numset[7];
			    numset[8]<=numset[8];
                         end
					
		         if(numset[0]<numset[9])begin	
		             numset[0]<=numset[9];
		             numset[9]<=numset[0];
	                 end
			 else begin
                             numset[0]<=numset[0];
			     numset[9]<=numset[9];
                         end

		       end

		    end
			
	  else begin

	        index<=index;
		tag<=tag;
                numset[0]<=numset[0];
		numset[1]<=numset[1];
		numset[2]<=numset[2];
		numset[3]<=numset[3];
		numset[4]<=numset[4];
	        numset[5]<=numset[5];
	        numset[6]<=numset[6];
		numset[7]<=numset[7];
		numset[8]<=numset[8];
		numset[9]<=numset[9];
			 
	   end
end
always@(posedge clk or negedge rst_n)begin

    if(!rst_n)temp_mode<=0;
    
    else if(count_out==10)temp_mode<=0;   
 
    else if(in_valid2&&cstate==INPUT)temp_mode<=mode;

    else if(cstate==OUT)temp_mode<=0;

    else  
           temp_mode<=temp_mode;

end

always@(posedge clk or negedge rst_n)begin

   if(!rst_n)count_ex<=0;
	 
   else if(cstate==EX)begin

      count_ex<=count_ex+1;
   end

   else if(count_ex==10)begin

      count_ex<=0;
   end

   else
 
      count_ex<=count_ex;
end

always@(posedge clk or negedge rst_n)begin

    if(!rst_n)count_out<=0;

    else if(cstate==OUT)begin

         count_out<=count_out+1;

    end

    else if(count_out==10)begin

	 count_out<=0;

    end

    else
	 count_out<=count_out;
end

always@(posedge clk or negedge rst_n)begin

   if(!rst_n)begin

          out<=0;
	  out_valid<=0;
   end

   else if(count_out==10)begin
          out<=0;
          out_valid<=0;
   end	

   else if(cstate==OUT)begin

	  case(count_out) 
	           0:begin
                     out<=numset[0];
                     out_valid<=1;
                     end
	           1:begin
                     out<=numset[1];
                     out_valid<=1;
                     end
		   2:begin
                     out<=numset[2];
                     out_valid<=1;
                     end
		   3:begin
                     out<=numset[3];
                     out_valid<=1;
                     end
		   4:begin
                     out<=numset[4];
                     out_valid<=1;
                     end
		   5:begin
                     out<=numset[5];
                     out_valid<=1;
                     end
		   6:begin
                     out<=numset[6];
                     out_valid<=1;
                     end
		   7:begin
                     out<=numset[7];
                     out_valid<=1;
                     end
		   8:begin
                     out<=numset[8];
                     out_valid<=1;
                     end
		   9:begin
                     out<=numset[9];
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
//---------------------------------------------------------------------
//   Design Description                                          
//---------------------------------------------------------------------




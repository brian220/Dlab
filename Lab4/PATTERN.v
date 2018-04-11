
`timescale 1ns/10ps
`define CLK_PERIOD  4.0
`define PATTERN_NUM 1000

module PATTERN(
	clk,
	circle1,
	circle2,
	in,
	in_valid,
	rst_n,
	out,
	out_valid
);

output reg clk;
output reg [2:0] circle1;
output reg [2:0] circle2;
output reg [4:0]in;
output reg in_valid;
output reg rst_n;

input [5:0] out;
input out_valid;

integer i,j,temp,pn;
integer lantency,out_num;
integer num1[0:7],num2[0:7],nums[0:7];

//clock cycle
initial begin
     clk=1'b0;
     forever#(`CLK_PERIOD/2)clk=~clk;
end

initial begin
    
    lantency<=0;
    in_valid<=1'b0;
    rst_n<=1'b1;
    in<=1'bx;
    circle1<=3'bx;
    circle2<=3'bx;

    @(negedge clk);
           rst_n=1'b0;
       
           
    @(negedge clk);
           rst_n=1'b1;
           check_outvalid;
           check_output;
    for(pn=0;pn<`PATTERN_NUM;pn=pn+1)begin

    @(negedge clk);
    @(negedge clk);
    
    in_valid<=1'b1;
    
     for(i=0;i<16;i=i+1)begin

       if(i===0)begin

          circle1={$random}%8;
          circle2={$random}%8;

       end
       
       in={$random}%32;

       if(i<8)begin
          if(i+circle1>7)num1[i+circle1-8]<=in;

          else num1[i+circle1]<=in;
       end
       
       else begin
          if((i-8)+circle2>7)num2[(i-8)+circle2-8]<=in;

          else num2[(i-8)+circle2]<=in;  

       end
     
       @(posedge clk)
           check_outvalid;
    
       @(negedge clk);
   end
   /*for(i=0;i<8;i=i+1)begin
      $display(num1[i]);
   end

   for(i=0;i<8;i=i+1)begin
      $display(num2[i]);
   end*/

   for(i=0;i<8;i=i+1)begin
       
        nums[i]=num1[i]+num2[i];

   end
   
   for(i=0;i<8;i=i+1)begin
       for(j=0;j<8-i-1;j=j+1)begin
           if(nums[j]>nums[j+1])begin          
              temp=nums[j];
              nums[j]=nums[j+1];
              nums[j+1]=temp;
           end
      end
   end
  /* for(i=0;i<8;i=i+1)begin
      $display(nums[i]);
   end*/

   in_valid<=1'b0;
   in<=1'bx;
   
   @(negedge clk);

   while(!(out_valid===1'b1))begin

        if(lantency>=100)begin 
            $display("");
            $display("=================================================");
            $display("  Latency more than 100 !!!!                     ");
            $display("=================================================");
            $display("");
            $finish;        
        end
        lantency<=lantency+1;
        @(negedge clk);

   end
   lantency<=0;
   out_num=0;

   while(out_valid===1'b1)begin
       
      if(out_num>7)begin
          $display("");
          $display("=================================================");
          $display("  out_valid more than 8 cycle !!!!               ");
          $display("=================================================");
          $display("");
          @(negedge clk);
          $finish;
      end
      if(nums[out_num]!==out)begin
           $display("");
           $display("=================================================");
           $display("  Failed!!  PATTERN %3d is wrong!                ",pn+1);
           $display("=================================================");
           $display("");
           @(negedge clk);
           $finish;
      end
      out_num=out_num+1;
      
      @(negedge clk);

   end
     
  if(out_num!=8)begin
        $display("");
        $display("=================================================");
        $display("  out_valid less than 8 cycle !!!!               ");
        $display("=================================================");
        $display("");
        @(negedge clk);
        $finish;

  end
  
  $display("");
  $display(" Pass pattern %3d",pn+1);
    if(pn+1==`PATTERN_NUM)begin
        $display("");
        $display("=================================================");
        $display("You Pass all pattern!!!!??!!??!!                 ");
        $display("=================================================");
        $display("");
        @(negedge clk);
        $finish;
    end
  end
end

task check_outvalid;

     if(out_valid!==1'b0)begin
         $display("");
                $display("=================================================");
                $display("  out_valid should be reset !!!!               ");
                $display("=================================================");
                $display("");
                @(negedge clk);
                $finish;
     end
endtask

task check_output;
     if(out!==1'b0)begin
           $display("");
                $display("=================================================");
                $display("  output should be reset !!!!               ");
                $display("=================================================");
                $display("");
                @(negedge clk);
                $finish;
      end
endtask
endmodule

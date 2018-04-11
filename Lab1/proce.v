

module ALU(OUT,A,B,MODE);
//############
// your design
//############

input [3:0]A;
input [3:0]B;
input [1:0]MODE;
output [7:0]OUT;
reg [7:0]OUT;
always@(A,B,MODE)
	begin

	if(MODE==2'b00)OUT=A+B;
	else
	if(MODE==2'b01)OUT=A&B;
	else
	if(MODE==2'b10)
		if(A>B)OUT=1;
		else 
		OUT=0;
	else
	if(MODE==2'b11)OUT=A>>B;
	end
endmodule


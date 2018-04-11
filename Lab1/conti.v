module ALU( OUT, A, B, MODE);



//############
// your design
//############


input [3:0]A;
input [3:0]B;
input [1:0]MODE;
output [7:0]OUT;


assign OUT=(MODE==2'b00)?(A+B):(MODE==2'b01)?A&B:(MODE==2'b10)?(A>B)?1

:0:A>>B;


endmodule 

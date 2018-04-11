`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:16:27 01/09/2017 
// Design Name: 
// Module Name:    key 
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
module key(rst ,clk ,kclk, kdata, k_value
    );
	input rst;
	input kclk;
	input clk;
	input kdata;
	output reg[9:0] k_value;
	reg [10:0] key;
	reg Long, Break;
	reg [3:0] cnt;
	reg c_state;
	reg n_state;
	wire check;
	always@(posedge clk)
	begin
	c_state <= n_state;
	n_state = kclk;
	end
	assign check = key[1]^key[2]^key[3]^key[4]^key[5]^key[6]^key[7]^key[8]^key[9];
	always@(posedge clk)
	begin
		if(rst)
		cnt <= 0;
		else if(cnt ==4'd11)
		cnt <= 0;
		else if({c_state,n_state} == 2'b10)
		cnt <= cnt+1;
		else 
		cnt <= cnt;
	end
	
	always@(posedge clk)
	begin
		if(rst)
		key <= 0;
		else if({c_state,n_state} == 2'b10)
		key <= {kdata , key[10:1]};
		else
		key <= key;
	end
	
	always@(posedge clk)
	begin
		if(rst)begin
		k_value <= 0;
		Break <= 0;
		Long <= 0;
		end
		else if(cnt == 4'd11 && check)begin
			if(key[8:1]==8'hF0)
				Break <= 1;
			else if(key[8:1]==8'hE0)
				Long <= 1;
			else begin
				k_value <= {Break,Long,key[8:1]};
				Break <= 0;
				Long <= 0;
				end
		end
		else begin
			k_value <= k_value;
			Break <= Break;
			Long <= Long;
		end
	end
endmodule

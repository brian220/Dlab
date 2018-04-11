`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:40:11 01/05/2017 
// Design Name: 
// Module Name:    keyboard
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
module keyboard(kdata,clk, rst, kclk, k_value
    );
    input kdata, clk, rst, kclk;
    output reg [9:0] k_value;
    wire check;
    reg c_state,n_state,Break,arrow;
    reg [10:0] key;
    reg [3:0] k_cnt;
    
    assign check = key[1]^key[2]^key[3]^key[4]^key[5]^key[6]^key[7]^key[8]^key[9];
    always@(posedge clk or posedge rst)begin
	if(rst)
		begin
		c_state <= 0;
		n_state <= 0;
		end
	else
		begin
		c_state <= n_state;
        n_state <= kclk;
		end
    end
    always@(posedge clk or posedge rst)begin
	if(rst)
		key <= 0;
	 else
        case({c_state,n_state})
        2'b10:key <= {kdata , key[10:1]};
        default:key <= key;
        endcase
    end
    always@(posedge clk or posedge rst)begin
	 if(rst)
		  k_cnt <= 0;
	 else if(k_cnt == 4'd11)
		  k_cnt <= 0;
	 else if({c_state,n_state}== 2'b10)
		  k_cnt <= k_cnt+1;
	 else
        k_cnt <= k_cnt;
	 end
    always@(posedge clk or posedge rst)begin
	if(rst)
		begin
        k_value <= 0;
        Break <= 0;
        arrow <= 0;
        end
	else if(check == 1 && k_cnt == 4'd11)
    begin
        if(key[8:1] == 8'hF0)
        Break <= 1;
        else if(key[8:1] == 8'hE0)
        arrow <= 1;
        else begin
        k_value <= {Break,arrow,key[8:1]};
        Break <= 0;
        arrow <= 0;
        end
    end
    else
        begin
        k_value <= k_value;
        Break <= Break;
        arrow <= arrow;
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:23 07/21/2019 
// Design Name: 
// Module Name:    Clk_fx_generator 
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
module Clk_fx_generator
(
	input       sys_clk,
	input       rst_n,
	output reg  clk_fx
);

localparam     DIVISION_FACTOR = 32'd1_000;
reg[31:0]      clk_cnt;

always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		clk_cnt <= 32'd0;
		clk_fx  <= 1'b0;
	end
	else if(clk_cnt >= ((DIVISION_FACTOR / 2) - 1))
	begin
		clk_cnt <= 32'd0;
		clk_fx  <= ~clk_fx;
	end
	else
	begin
		clk_cnt <= clk_cnt + 1'b1;
		clk_fx  <= clk_fx;
	end
end
endmodule

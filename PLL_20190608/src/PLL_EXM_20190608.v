`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:18:37 06/08/2019 
// Design Name: 
// Module Name:    PLL_EXM 
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
module PLL_EXM(
	input clk,
	input rst_n,
	output clkout1,
	output clkout2,
	output clkout3,
	output clkout4
    );

wire locked;
IBUFG IBUFG_INST
(
	.O(clk_bufg),
	.I(clk)
);

PLL_20190608 pll_inst
(
	.clk_in(clk_bufg),
	.clk_out1(clkout1),
	.clk_out2(clkout2),
	.clk_out3(clkout3),
	.clk_out4(clkout4),
	
	.reset(~rst_n),
	.locked(locked)
);
endmodule

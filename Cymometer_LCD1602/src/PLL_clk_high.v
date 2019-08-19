`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:16 07/21/2019 
// Design Name: 
// Module Name:    PLL_clk_high 
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
module PLL_clk_high
(
	input     sys_clk,
	input     rst_n,
	output    sys_clk_h
);

wire locked;

IBUFG IBUFG_INST
(
	.O  (clk_bufg),
	.I  (sys_clk)
);

PLL_CLK PLL_Inst
(
	.clk_in     (clk_bufg),
	.sys_clk_h  (sys_clk_h),
	.rst        (~rst_n)
);

endmodule

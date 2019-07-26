`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:52 07/20/2019 
// Design Name: 
// Module Name:    Top_cymometer 
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
module Top_cymometer
(
	input        sys_clk,
	input        rst_n,
	input        clk_fx,
	output[7:0]  LCD_DATA,
	output       LCD_RW,
	output       LCD_EN,
	output       LCD_RS,
	output       LCD_ON
);
wire[21:0]       data_fx;
wire             sys_clk_h;
/*
Clk_fx_generator Clk_fx
(
	.sys_clk     (sys_clk_h),
	.rst_n       (rst_n),
	.clk_fx      (clk_out)
);
*/
PLL_clk_high  PLL_Clk
(
	.sys_clk     (sys_clk),
	.rst_n       (rst_n),
	.sys_clk_h   (sys_clk_h)
);

Cymometer Cymometer
(
	.clk_fs      (sys_clk_h),
	.rst_n       (rst_n),
	.clk_fx      (clk_fx),
	.data_fx     (data_fx)
);

LCD1602_Top LCD1602_U1
(
	.sys_clk     (sys_clk_h),
	.rst_n       (rst_n),
	.data_fx     (data_fx),
	.LCD_DATA    (LCD_DATA),
	.LCD_RW      (LCD_RW),
	.LCD_EN      (LCD_EN),
	.LCD_RS      (LCD_RS),
	.LCD_ON      (LCD_ON)
);
endmodule

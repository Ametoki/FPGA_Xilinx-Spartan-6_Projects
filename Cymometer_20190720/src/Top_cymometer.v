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
//	input        clk_fx,
	output[5:0]  seg_sel,
	output[7:0]  seg_data
);
wire        clk_fx;
wire        clk_out;
wire[19:0]  data_fx;

assign      clk_fx = clk_out;
Clk_fx_generator Clk_fx
(
	.sys_clk     (sys_clk_h),
	.rst_n       (rst_n),
	.clk_fx      (clk_out)
);

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

SEG_Data Seg_top
(
	.sys_clk     (sys_clk_h),
	.rst_n       (rst_n),
	.bin_data    (data_fx),
	.seg_sel     (seg_sel),
	.seg_data    (seg_data)
);
endmodule

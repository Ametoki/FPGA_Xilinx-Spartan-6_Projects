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
	input        nCS,
	//input        MOSI,
	input        SCK,
	output       MISO,
	output       MISO_2,
	output       SCK_2,
	output       nCS_2
);
assign SCK_2 = SCK;
assign MISO_2 = MISO;
assign nCS_2 = nCS;
wire   sys_clk_h;
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
wire[31:0] fs_cnt;
wire[31:0] fx_cnt;
Cymometer Cymometer
(
	.clk_fs      (sys_clk_h),
	.rst_n       (rst_n),
	.clk_fx      (clk_fx),
	.fs_cnt_out  (fs_cnt),
	.fx_cnt_out  (fx_cnt)
);

SPI_Top SPI_ctrl_top
(
	.sys_clk     (sys_clk_h),
	.rst_n       (rst_n),
	.fs_cnt      (fs_cnt),
	.fx_cnt      (fx_cnt),
	//.data_fx     ({5'd0,data_fx}),//{5'd0,data_fx}
	.nCS         (nCS),
	//.MOSI        (MOSI),
	.SCK         (SCK),
	.MISO        (MISO)
);

wire[35:0]  CONTROL0;
wire[255:0] TRIG0;
assign TRIG0[0] = SCK_2;
assign TRIG0[1] = MISO_2;
assign TRIG0[2] = nCS_2;
chipscope_icon icon_debug
(
	.CONTROL0(CONTROL0)
);
chipscope_ila ila_filter_debug
(
	.CONTROL(CONTROL0),
	.CLK    (sys_clk_h),
	.TRIG0  (TRIG0)
);

endmodule

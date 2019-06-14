//////////////////////////////////////////////////////////////////////////////////
//   lcd color bar test                                                         //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2017/7/20                    1.0          Original
//*******************************************************************************/
module top(
	input                       clk,
	input                       rst_n,
	output                      lcd_dclk,   
	output                      lcd_hs,      //lcd horizontal synchronization
	output                      lcd_vs,      //lcd vertical synchronization  
	output                      lcd_de,      //lcd data valid
	output[7:0]                 lcd_r,       //lcd red
	output[7:0]                 lcd_g,       //lcd green
	output[7:0]                 lcd_b        // lcd blue
);

wire                            video_clk;
wire                            video_hs;
wire                            video_vs;
wire                            video_de;
wire[7:0]                       video_r;
wire[7:0]                       video_g;
wire[7:0]                       video_b;

assign lcd_hs = video_hs;
assign lcd_vs = video_vs;
assign lcd_de = video_de;
assign lcd_r  = video_r[7:0];
assign lcd_g  = video_g[7:0];
assign lcd_b  = video_b[7:0];
assign lcd_dclk = ~video_clk;              //to meet the timing requirements, the clock is inverting


IBUFG IBUFG_INST
(
   .O(clk_bufg),
	.I(clk)
);


//generate video pixel clock
video_pll video_pll_m0
(
	.CLK_IN1(clk_bufg),
	.CLK_OUT1(video_clk),
	.LOCKED(),
	.RESET(~rst_n)
);

color_bar color_bar_m0(
	.clk(video_clk),
	.rst(~rst_n),
	.hs(video_hs),
	.vs(video_vs),
	.de(video_de),
	.rgb_r(video_r),
	.rgb_g(video_g),
	.rgb_b(video_b)
);
endmodule
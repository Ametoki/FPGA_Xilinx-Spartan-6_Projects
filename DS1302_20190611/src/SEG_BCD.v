`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:14 06/18/2019 
// Design Name: 
// Module Name:    SEG_BCD 
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
module SEG_BCD
(
	input  clk,
	input  rst_n,
	input[7:0] EN,
	output[5:0] seg_sel,
	output[7:0] seg_data,
	input[23:0] seg_bcd
);
wire[7:0] seg_data_0;
wire[7:0] seg_data_1;
wire[7:0] seg_data_2;
wire[7:0] seg_data_3;
wire[7:0] seg_data_4;
wire[7:0] seg_data_5;
SEG_Decoder SEG_Decoder_U0
(
	.bin_data(seg_bcd[23:20]),
	.seg_data(seg_data_0)
);
SEG_Decoder SEG_Decoder_U1
(
	.bin_data(seg_bcd[19:16]),
	.seg_data(seg_data_1)
);
SEG_Decoder SEG_Decoder_U2
(
	.bin_data(seg_bcd[15:12]),
	.seg_data(seg_data_2)
);
SEG_Decoder SEG_Decoder_U3
(
	.bin_data(seg_bcd[11:8]),
	.seg_data(seg_data_3)
);
SEG_Decoder SEG_Decoder_U4
(
	.bin_data(seg_bcd[7:4]),
	.seg_data(seg_data_4)
);
SEG_Decoder SEG_Decoder_U5
(
	.bin_data(seg_bcd[3:0]),
	.seg_data(seg_data_5)
);
SEG_Scan SEG_Scan_U0(
	.clk        (clk),
	.rst_n      (rst_n),
	.seg_sel    (seg_sel),
	.seg_data   (seg_data),
	.seg_data_0 (seg_data_0 | EN),
	.seg_data_1 ((seg_data_1 & 8'h7f) | EN),
	.seg_data_2 (seg_data_2 | EN),
	.seg_data_3 ((seg_data_3 & 8'h7f) | EN),
	.seg_data_4 (seg_data_4 | EN),
	.seg_data_5 (seg_data_5 | EN)
);
endmodule

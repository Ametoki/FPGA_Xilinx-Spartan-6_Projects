`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:52:24 07/21/2019 
// Design Name: 
// Module Name:    SEG_Top 
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
module SEG_Data
(
	input         sys_clk,
	input         rst_n,
	input[19:0]   bin_data,
	output[5:0]   seg_sel,
	output[7:0]   seg_data
);

/*
reg[2:0]  clk_cnt;
reg[31:0] bin_data_temp;
reg[3:0]  bin_data_0;
reg[3:0]  bin_data_1;
reg[3:0]  bin_data_2;
reg[3:0]  bin_data_3;
reg[3:0]  bin_data_4;
reg[3:0]  bin_data_5;
*/

wire[3:0] bin_data_0;
wire[3:0] bin_data_1;
wire[3:0] bin_data_2;
wire[3:0] bin_data_3;
wire[3:0] bin_data_4;
wire[3:0] bin_data_5;
assign    bin_data_0 = bin_data % 4'd10;
assign    bin_data_1 = (bin_data / 19'd10) % 4'd10;
assign    bin_data_2 = (bin_data / 19'd100) % 4'd10;
assign    bin_data_3 = (bin_data / 19'd1_000) % 4'd10;
assign    bin_data_4 = (bin_data / 19'd10_000) % 4'd10;
assign    bin_data_5 = (bin_data / 19'd100_000) % 4'd10;

/*
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		clk_cnt       <= 3'd0;
		bin_data_temp <= bin_data;
	end
	else
	begin
		case(clk_cnt)
			3'd0:
			begin
				bin_data_temp <= bin_data;
				clk_cnt       <= 3'd1;
			end
			3'd1:
			begin
				bin_data_0    <= bin_data_temp % 32'd10;
				bin_data_temp <= bin_data_temp / 32'd10;
				clk_cnt       <= 3'd2;
			end
			3'd2:
			begin
				bin_data_1    <= bin_data_temp % 32'd10;
				bin_data_temp <= bin_data_temp / 32'd10;
				clk_cnt       <= 3'd3;
			end
			3'd3:
			begin
				bin_data_2    <= bin_data_temp % 32'd10;
				bin_data_temp <= bin_data_temp / 32'd10;
				clk_cnt       <= 3'd4;
			end
			3'd4:
			begin
				bin_data_3    <= bin_data_temp % 32'd10;
				bin_data_temp <= bin_data_temp / 32'd10;
				clk_cnt       <= 3'd5;
			end
			3'd5:
			begin
				bin_data_4    <= bin_data_temp % 32'd10;
				bin_data_temp <= bin_data_temp / 32'd10;
				clk_cnt       <= 3'd6;
			end
			3'd6:
			begin
				bin_data_5    <= bin_data_temp % 32'd10;
				clk_cnt       <= 3'd0;
			end
		default:
			begin
				bin_data_0    <= bin_data_0;
				bin_data_1    <= bin_data_1;
				bin_data_2    <= bin_data_2;
				bin_data_3    <= bin_data_3;
				bin_data_4    <= bin_data_4;
				bin_data_5    <= bin_data_5;
				bin_data_temp <= bin_data;
				clk_cnt       <= 3'd0;
			end
		endcase
	end
end
*/
wire[7:0] seg_data_0;
wire[7:0] seg_data_1;
wire[7:0] seg_data_2;
wire[7:0] seg_data_3;
wire[7:0] seg_data_4;
wire[7:0] seg_data_5;
SEG_Decoder Seg_decoder_U0
(
	.bin_data    (bin_data_5),
	.seg_data    (seg_data_0)
);
SEG_Decoder Seg_decoder_U1
(
	.bin_data    (bin_data_4),
	.seg_data    (seg_data_1)
);
SEG_Decoder Seg_decoder_U2
(
	.bin_data    (bin_data_3),
	.seg_data    (seg_data_2)
);
SEG_Decoder Seg_decoder_U3
(
	.bin_data    (bin_data_2),
	.seg_data    (seg_data_3)
);
SEG_Decoder Seg_decoder_U4
(
	.bin_data    (bin_data_1),
	.seg_data    (seg_data_4)
);
SEG_Decoder Seg_decoder_U5
(
	.bin_data    (bin_data_0),
	.seg_data    (seg_data_5)
);

SEG_Scan Seg_scan
(
	.clk         (sys_clk),
	.rst_n       (rst_n),
	.seg_data_0  (seg_data_0),
	.seg_data_1  (seg_data_1),
	.seg_data_2  (seg_data_2),
	.seg_data_3  (seg_data_3),
	.seg_data_4  (seg_data_4),
	.seg_data_5  (seg_data_5),
	.seg_sel     (seg_sel),
	.seg_data    (seg_data)
);

endmodule

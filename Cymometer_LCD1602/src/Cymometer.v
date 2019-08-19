`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:09 07/20/2019 
// Design Name: 
// Module Name:    cymometer 
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
module Cymometer
(
	input            clk_fs,
	input            rst_n,
	input            clk_fx,
	output reg[31:0] fs_cnt_out,
	output reg[31:0] fx_cnt_out
);
/*
reg[1:0]             state;
localparam           FX_LOW    = 2'b01;
localparam           FX_HIGH   = 2'b10;
*/
localparam           CNT_MAX   = 6'd32;
reg[CNT_MAX - 1:0]   GATE_TIME = 32'd10;
reg[CNT_MAX - 1:0]   GATE_TIME_NEXT;
reg                  gate_fx;
reg                  gate_fs;
reg                  gate_fs_reg;
reg                  gate_fs_d0;
reg                  gate_fs_d1;
reg                  gate_fx_d0;
reg                  gate_fx_d1;
reg[10:0]            gate_cnt;
reg[CNT_MAX - 1:0]   fs_cnt;
reg[CNT_MAX - 1:0]   fs_cnt_temp;
reg[CNT_MAX - 1:0]   fx_cnt;
reg[CNT_MAX - 1:0]   fx_cnt_temp;
//wire[26:0]         	 data_fx;
//reg[3:0]             fx_dvi_cnt;//5'd20
//reg                  fx_dvi;
wire                 neg_gate_fs;
wire                 neg_gate_fx;

assign neg_gate_fs = gate_fs_d1 & (!gate_fs_d0);
assign neg_gate_fx = gate_fx_d1 & (!gate_fx_d0);

/*
always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
	begin
		fx_dvi_cnt <= 1'b0;
		fx_dvi     <= 1'b0;
	end
	else if(fx_dvi_cnt == 4'b10)
	begin
		fx_dvi_cnt <= 1'b0;
		fx_dvi     <= ~fx_dvi;
	end
	else
		fx_dvi_cnt <= fx_dvi_cnt + 1'b1;
end
*/
/*
always@(posedge clk_fs)
begin
	if(neg_gate_fs)
	begin
		GATE_TIME_NEXT <= GATE_TIME;
		if(fs_cnt > 28'd200_000_000)
		begin
			GATE_TIME_NEXT <= 6'd50;
		end
		else if(fs_cnt <= 28'd150_000_000)
		begin
			if(GATE_TIME < 11'd2000)
				GATE_TIME_NEXT <= GATE_TIME_NEXT + 9'd496;
		end
	end
end
*/
always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
	begin
		gate_cnt  <= 1'b0;
	end
	else
	begin
		GATE_TIME <= GATE_TIME_NEXT;
		if(gate_cnt >= GATE_TIME + 5'd20)
		begin
			gate_cnt  <= 1'b0;
		end
		else if(gate_cnt < GATE_TIME + 5'd20)
			gate_cnt  <= gate_cnt + 1'b1;
	end
end

always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
		gate_fx <= 1'b0;
	else if(gate_cnt < 4'd10)
		gate_fx <= 1'b0;
	else if(gate_cnt < GATE_TIME + 4'd10)
		gate_fx <= 1'b1;
	else if(gate_cnt <= GATE_TIME + 5'd20)
		gate_fx <= 1'b0;
	else
		gate_fx <= 1'b0;
end

always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
	begin
		gate_fs_reg <= 1'b0;
		gate_fs     <= 1'b0;
	end
	else
	begin
		gate_fs_reg <= gate_fx;
		gate_fs     <= gate_fs_reg;
	end
end

always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
	begin
		gate_fs_d0 <= 1'b0;
		gate_fs_d1 <= 1'b0;
	end
	else
	begin
		gate_fs_d0 <= gate_fs;
		gate_fs_d1 <= gate_fs_d0;
	end
end

always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
	begin
		gate_fx_d0 <= 1'b0;
		gate_fx_d1 <= 1'b0;
	end
	else
	begin
		gate_fx_d0 <= gate_fx;
		gate_fx_d1 <= gate_fx_d0;
	end
end

always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
	begin
		fs_cnt_temp <= 1'b0;
		fs_cnt      <= 1'b0;
	end
	else if(gate_fs)
		fs_cnt_temp <= fs_cnt_temp + 1'b1;
	else if(neg_gate_fs)
	begin
		fs_cnt      <= fs_cnt_temp;
		fs_cnt_temp <= 1'b0;
	end
end

always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
	begin
		fx_cnt_temp <= 1'b0;
		fx_cnt      <= 1'b0;
	end
	else if(gate_fx)
		fx_cnt_temp <= fx_cnt_temp + 1'b1;
	else if(neg_gate_fx)
	begin
		fx_cnt      <= fx_cnt_temp;
		fx_cnt_temp <= 1'b0;
	end
end
reg[25:0] fs_output_cnt;
reg[25:0] fx_output_cnt;
always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
	begin
		fs_cnt_out    <= 1'b0;
		fs_output_cnt <= 1'b0;
	end
	else if (fs_output_cnt >= 26'd67_108_863)
	begin
		fs_cnt_out    <= fs_cnt;
		fs_output_cnt <= 1'b0;
	end
	else
	begin
		fs_cnt_out    <= fs_cnt_out;
		fs_output_cnt <= fs_output_cnt + 1'b1;
	end
end
always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
	begin
		fx_cnt_out    <= 1'b0;
		fx_output_cnt <= 1'b0;
	end
	else if (fx_output_cnt >= 26'd67_108_863)
	begin
		fx_cnt_out    <= fx_cnt;
		fx_output_cnt <= 1'b0;
	end
	else
	begin
		fx_cnt_out    <= fx_cnt_out;
		fx_output_cnt <= fx_output_cnt + 1'b1;
	end
end

reg[2:0]  fx_edge;
wire fx_posedge;
assign fx_posedge = (fx_edge[2:1] == 2'b01);

always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
		fx_edge <= 3'b000;
	else
		fx_edge <= {fx_edge[1:0], clk_fx};
end
reg[27:0] clk_cnt;
reg[30:0] fx_cnt_predict;
reg[30:0] fx_cnt_predict_temp;
always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
	begin
		clk_cnt             <= 1'b0;
		fx_cnt_predict      <= 1'b0;
		fx_cnt_predict_temp <= 1'b0;
	end
	else if(clk_cnt >= 28'd200_000_000)
	begin
		clk_cnt             <= 1'b0;
		fx_cnt_predict      <= fx_cnt_predict_temp;
		fx_cnt_predict_temp <= 1'b0;
	end
	else
	begin
		clk_cnt <= clk_cnt + 1'b1;
		if(fx_posedge)
			fx_cnt_predict_temp <= fx_cnt_predict_temp + 1'b1;
		else
			fx_cnt_predict_temp <= fx_cnt_predict_temp;
	end
end
always@(posedge clk_fs)
begin
	if(fx_cnt_predict > 1'b0)
		GATE_TIME_NEXT <= {fx_cnt_predict,1'b0};
	else
		GATE_TIME_NEXT <= 32'b1;
end
/*
wire[26:0] a;
wire[26:0] b;
wire[26:0] p;
wire       rfd;
wire[26:0] dividend;
wire[26:0] divisor;
wire[26:0] quotient;
wire[26:0] fractional;
assign     dividend = CLK_FS;
assign     divisor  = fs_cnt;
assign     a        = quotient;
assign     b        = fx_cnt;
assign     data_fx  = p;

Multiplier fx_multiplier
(
  .clk(clk), // input clk
  .a(a), // input [26 : 0] a
  .b(b), // input [26 : 0] b
  .p(p) // output [53 : 0] p
);

Divider_V3 fx_divider
(
	.clk(clk_fs), // input clk
	.rfd(rfd), // output rfd
	.dividend(dividend), // input [26 : 0] dividend
	.divisor(divisor), // input [26 : 0] divisor
	.quotient(quotient), // output [26 : 0] quotient
	.fractional(fractional)// output [26 : 0] fractional
);
*/
/*
always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
		data_fx <= 1'b0;
	else if(!(gate_fs | gate_fx))
		data_fx <= (CLK_FS / fs_cnt) * fx_cnt;
end
*/
endmodule

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
	output reg[19:0] data_fx
);
localparam           CLK_FS    = 32'd375_000_000;
localparam           CNT_MAX   = 6'd32;
localparam           GATE_TIME = 16'd50;
reg                  gate_fx;
reg                  gate_fs;
reg                  gate_fs_reg;
reg                  gate_fs_d0;
reg                  gate_fs_d1;
reg                  gate_fx_d0;
reg                  gate_fx_d1;
reg[15:0]            gate_cnt;
reg[CNT_MAX - 1:0]   fs_cnt;
reg[CNT_MAX - 1:0]   fs_cnt_temp;
reg[CNT_MAX - 1:0]   fx_cnt;
reg[CNT_MAX - 1:0]   fx_cnt_temp;
wire                 neg_gate_fs;
wire                 neg_gate_fx;

assign neg_gate_fs = gate_fs_d1 & (!gate_fs_d0);
assign neg_gate_fx = gate_fx_d1 & (!gate_fx_d0);
always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
		gate_cnt <= 16'd0;
	else if(gate_cnt == GATE_TIME + 5'd20)
		gate_cnt <= 16'd0;
	else if(gate_cnt < GATE_TIME + 5'd20)
		gate_cnt <= gate_cnt + 1'b1;
end

always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
		gate_fx <= 1'b0;
	else if(gate_cnt < 16'd10)
		gate_fx <= 1'b0;
	else if(gate_cnt < GATE_TIME + 16'd10)
		gate_fx <= 1'b1;
	else if(gate_cnt <= GATE_TIME + 16'd20)
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
		fs_cnt_temp <= 32'd0;
		fs_cnt      <= 32'd0;
	end
	else if(gate_fs)
		fs_cnt_temp <= fs_cnt_temp + 1'b1;
	else if(neg_gate_fs)
	begin
		fs_cnt      <= fs_cnt_temp;
		fs_cnt_temp <= 32'd0;
	end
end

always@(posedge clk_fx or negedge rst_n)
begin
	if(!rst_n)
	begin
		fx_cnt_temp <= 32'd0;
		fx_cnt      <= 32'd0;
	end
	else if(gate_fx)
		fx_cnt_temp <= fx_cnt_temp + 1'b1;
	else if(neg_gate_fx)
	begin
		fx_cnt      <= fx_cnt_temp;
		fx_cnt_temp <= 32'd0;
	end
end

always@(posedge clk_fs or negedge rst_n)
begin
	if(!rst_n)
		data_fx <= 32'd0;
	else if(!(gate_fs | gate_fx))
		data_fx <= (CLK_FS / fs_cnt) * fx_cnt;
end
endmodule

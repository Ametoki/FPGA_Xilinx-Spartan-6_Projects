`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:06 06/12/2019 
// Design Name: 
// Module Name:    DS1302_IO 
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
module DS1302_IO
(
	input           clk,
	input           rst,
	output          ds1302_ce,
	output          ds1302_sclk,
	inout           ds1302_io,
	input           cmd_read,
	input           cmd_write,
	output          cmd_read_ack,
	output          cmd_write_ack,
	input[7:0]      read_addr,
	input[7:0]      write_addr,
	output reg[7:0] read_data, 
	input[7:0]      write_data
);
localparam S_IDLE       = 4'd0;
localparam S_CE_HIGH    = 4'd1;
localparam S_READ       = 4'd2;
localparam S_READ_ADDR  = 4'd3;
localparam S_READ_DATA  = 4'd4;
localparam S_WRITE      = 4'd5;
localparam S_WRITE_ADDR = 4'd6;
localparam S_WRITE_DATA = 4'd7;
localparam S_CE_LOW     = 4'd8;
localparam S_ACK        = 4'd9;
reg[3:0]   state, next_state;
reg[19:0]  delay_cnt;
reg        wr_req;
wire       wr_ack;
reg        wr_ack_d0;
reg        CS_reg;
wire       DCLK;
wire       MOSI;
wire       MISO;
reg[7:0]   send_data;
wire[7:0]  data_rec;
reg        ds1302_io_dir;
assign     ds1302_io = ~ds1302_io_dir ? MOSI : 1'bz;
assign     MISO = ds1302_io;
assign     ds1302_sclk = DCLK;
assign     cmd_read_ack = (state == S_ACK);
assign     cmd_write_ack = (state == S_ACK);
always@(posedge clk or posedge rst)
begin
	if(rst)
		state <= S_IDLE;
	else
		state <= next_state;
end
always@(*)
begin
	case(state)
		S_IDLE:
			if(cmd_read || cmd_write)
				next_state <= S_CE_HIGH;
			else
				next_state <= S_IDLE;
		S_CE_HIGH:
			if(delay_cnt == 20'd255)
				next_state <= cmd_read ? S_READ : S_WRITE;
			else
				next_state <= S_CE_HIGH;
		S_READ:
			next_state <= S_READ_ADDR;
		S_READ_ADDR:
			if(wr_ack)
				next_state <= S_READ_DATA;
			else
				next_state <= S_READ_ADDR;
		S_READ_DATA:
			if(wr_ack)
				next_state <= S_ACK;
			else
				next_state <= S_READ_DATA;
		S_WRITE:
			next_state <= S_WRITE_ADDR;
		S_WRITE_ADDR:
			if(wr_ack)
				next_state <= S_WRITE_DATA;
			else
				next_state <= S_WRITE_ADDR;
		S_WRITE_DATA:
			if(wr_ack)
				next_state <= S_ACK;
			else
				next_state <= S_WRITE_DATA;
		S_ACK:
			next_state <= S_CE_LOW;
		S_CE_LOW:
			if(delay_cnt == 20'd255)
				next_state <= S_IDLE;
			else
				next_state <= S_CE_LOW;
		default:
			next_state <= S_IDLE;
	endcase
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		delay_cnt <= 20'd0;
	else if(state == S_CE_HIGH || state == S_CE_LOW)
		delay_cnt <= delay_cnt + 20'd1;
	else
		delay_cnt <= 20'd0;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		wr_req <= 1'b0;
	else if(wr_ack)
		wr_req <= 1'b0;
	else if(state == S_READ_ADDR || state == S_READ_DATA || state == S_WRITE_ADDR || state == S_WRITE_DATA)
		wr_req <= 1'b1;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		ds1302_io_dir <= 1'b0;
	else
		ds1302_io_dir <= (state == S_READ_DATA);
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		CS_reg <= 1'b0;
	else if(state == S_CE_HIGH)
		CS_reg <= 1'b1;
	else if(state == S_CE_LOW)
		CS_reg <= 1'b0;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_data <= 8'h00;
	else if(state == S_READ_DATA && wr_ack)
		read_data <= {data_rec[0], data_rec[1], data_rec[2], data_rec[3], data_rec[4], data_rec[5], data_rec[6], data_rec[7]};
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		send_data <= 8'h00;
	else if(state == S_READ_ADDR)
		send_data <= {1'b1, read_addr[1], read_addr[2], read_addr[3], read_addr[4], read_addr[5], read_addr[6], 1'b1};
	else if(state == S_WRITE_ADDR)
		send_data <= {1'b0, write_addr[1], write_addr[2], write_addr[3], write_addr[4], write_addr[5], write_addr[6], 1'b1};
	else if(state == S_WRITE_DATA)
		send_data <= {write_data[0], write_data[1], write_data[2], write_data[3], write_data[4], write_data[5], write_data[6], write_data[7]};
end
SPI_Master SPI_Master
(
	.sys_clk (clk),
	.rst     (rst),
	.nCS     (ds1302_ce),
	.DCLK    (DCLK),
	.MOSI    (MOSI),
	.MISO    (MISO),
	.CPOL    (1'b0),
	.CPHA    (1'b0),
	.nCS_ctrl(CS_reg),
	.clk_div (16'd50),
	.wr_req  (wr_req),
	.wr_ack  (wr_ack),
	.data_in (send_data),
	.data_out(data_rec)
);
endmodule

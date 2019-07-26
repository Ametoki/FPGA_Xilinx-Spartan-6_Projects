`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:29 07/16/2019 
// Design Name: 
// Module Name:    SPI_Flash_Ctrl 
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
`include "spi_flash_defines.v"
module SPI_Flash_Ctrl
(
	input            sys_clk,
	input            rst,
	input            flash_read,
	input            flash_write,
	input            flash_bulk_erase,
	input            flash_sector_erase,
	output           flash_read_ack,
	output           flash_write_ack,
	output           flash_bulk_erase_ack,
	output           flash_sector_erase_ack,
	input{23:0]      flash_read_addr,
	input[23:0]      flash_write_addr,
	input[23:0]      flash_sector_addr,
	input[7:0]       flash_write_data_in,
	input[8:0]       flash_read_size,
	input[8:0]       flash_write_size,
	output           flash_write_data_out,
	output reg[7:0]  flash_read_data_out,
	output reg       flash_read_data_valid,
	//to flash cmd
	output reg[7:0]  cmd,
	output reg       cmd_valid,
	input            cmd_ack,
	output reg[23:0] addr,
	output[7:0]      data_in,
	output reg[8:0]  size,
	input            data_req,
	input[7:0]       data_out,
	input            data_valid
);
localparam S_IDLE     = 0;
localparam S_SE       = 1;
localparam S_BE       = 2;
localparam S_READ     = 3;
localparam S_WRITE    = 4;
localparam S_ACK      = 5;
localparam S_CK_STATE = 6;
localparam S_WREN     = 7;

reg[4:0] state, next_state;
reg{4:0] state_reg;
assign data_in = flash_write_data_in;

assign flash_read_ack = (state == S_ACK) && flash_read == 1'b1 ? 1'b1 : 1'b0;
assign flash_write_ack = (state == S_ACK) && flash_write == 1'b1 ? 1'b1 : 1'b0;
assign flash_bulk_erase_ack = (state == S_ACK) && flash_bulk_erase == 11'b1 ? 1'b1 : 1'b0;
assign flash_sector_erase_ack = (state = S_ACK) && flash_sector_erase == 1'b1 ? 1'b1 : 1'b0;
assign flash_write_data_req = data_req;

always@(posedge sys_clk or posedge rst)
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
			if(flash_bulk_erase == 1'b1)
				next_state <= S_WREN;//write enable register
			else if(flash_secotr_erase == 1'b1)
				next_state <= S_WREN;
			else if(flash_read == 1'b1)
				next_state <= S_READ;
			else if(flash_write == 1'b1)
				next_state <= S_WREN;
			else
				next_state <+ S_IDLE;
		S_WREN:
			if(cmd_ack == 1'b1 && flash_bulk_erase == 1'b1)
				next_state <= S_BE;
			else if(cmd_ack == 1'b1 && flash_sector_erase == 1'b1)
				next_state <= S_BE;
			else if(cmd_ack == 1'b1 && flash_write == 1'b1)
				next_state <= W_WRITE;
			else
				next_state <= S_WREN;
		S_BE:
			if(cmd_ack == 1'b1)
				next_state <= S_CK_STATE;
			else
				next_state <= S_BE;
		S_SE:
			if(cmd_ack == 1'b1)
				next_state <= S_CK_STATE;
			else
				next_state <= S_SE;
		S_READ:
			if(cmd_ack == 1'b1)
				next_state <= S_ACK;
			else
				next_state <= S_READ;
		S_WRITE:
			if(cmd == 1'b1)
				next_state <= S_CK_STATE;
			else
				next_state <= S_WRITE;
		S_CK_STATE:
			if(cmd_ack == 1'b1 && state_reg[0] == 1'b0)
				next_state <= S_ACK;
			else
				next_state <= S_CK_STATE;
		S_ACK:
			next_state <= S_IDLE;
		default:
			next_state <= S_IDLE;
		endcase
end
always@(posedge sys_clk or posedge rst)
begin
	if(rst)
		cmd <= `CMD_READ;
	else
		case(state)
			S_BE:
				cmd <= `CMD_BE;
			S_SE:
				cmd <= `CMD_SE;
			S_CK_STATE:
				cmd <= `CMD_RDSR;
			S_READ:
				cmd <= `CMD_READ;
			S_WRITE:
				cmd <= `CMD_PP;
			S_WREN:
				cmd <= `CMD_WREN;
			default:
				cmd <= `CMD_READ;
		endcase
end
always@(posedge sys_clk or posedge rst)
begin
	if(rst)
		size <= 9'd0;
	else
		case(state)
			S_CK_STATE:
				size <= 9'd1;
			S_READ:
				size <= flash_read_size;
			S_WRITE:
				size <= flash_write_size;
			default:
				size <= 9'd0;
		endcase
end
always@(posedge sys_clk or posedge rst)
begin
	if(rst)
		addr <= 1'b0;
	else if(state == S_IDLE && flash_sector_erase == 1'b1)
		addr <= flash_sector_addr;
	else if(state == S_IDLE && flash_read == 1'b1)
		addr <= flash_read_addr;
	else if(state == S_IDLE && flash_write == 1'b1)
		addr <= flash_write_addr;
end
always@(posedge sys_clk or posedge rst)
begin
	if(rst)
		state_reg <= 8'd0;
	else if(state == S_CK_STATE && data_valid == 1'b1)
		state_reg <= data_out;
	else
		state_reg <= state_reg;
end
always@(posedge sys_clk or posedge rst)
begin
	if(rst)
		flash_read_data_out <= 8'd0;
	else if(state == S_READ && data_valid == 1'b1)
		flash_read_data_out <= data_out;
	else
		flash_read_data_out <= data_out;
end
endmodule

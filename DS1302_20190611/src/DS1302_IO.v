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
	input  clk,
	input  rst,
	output ds1302_ce,
	output ds1302_sclk,
	inout  ds1302_io,
	input  cmd_read,
	input  cmd_write,
	output cmd_read_ack,
	output cmd_write_ack,
	input[7:0] read_addr,
	input[7:0] write_addr,
	output reg[7:0] read_data;
	input[7:0] write_data
);
localparam S_IDLE = 0;
localparam S_CE_HIGH = 1;
localparam S_READ = 2;
localparam S_READ_ADDR = 3;
localparam S_READ_DATA = 4;
localparam S_WRITE = 5;
localparam S_WRITE_ADDR = 6;
localparam S_WRITE_DATA = 7;
localparam S_CE_LOW = 8;
localparam S_ACK = 9;
reg[3:0] state, next_state;

endmodule

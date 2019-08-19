`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:27 08/01/2019 
// Design Name: 
// Module Name:    SPI_Top 
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
module SPI_Top
(
	input       sys_clk,
	input       rst_n,
	input[31:0] fs_cnt,
	input[31:0] fx_cnt,
	input       nCS,
	//input       MOSI,
	input       SCK,
	output      MISO
);
localparam             BYTE_CNT = 7'd96;
reg[BYTE_CNT - 1'b1:0] data;// = 8'h30;
wire[7:0]              RECV_DATA;
reg                    sck_r0;
reg                    sck_r1;
reg                    ncs_r0;
reg                    ncs_r1;
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sck_r0 <= 1'b0;
		sck_r1 <= 1'b0;
	end
	else
	begin
		sck_r0 <= SCK;
		sck_r1 <= sck_r0;
	end
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		ncs_r0 <= 1'b0;
		ncs_r1 <= 1'b0;
	end
	else
	begin
		ncs_r0 <= nCS;
		ncs_r1 <= ncs_r0;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
		data <= 1'b0;
	else
		//data <= {32'h80000000,32'd0,32'd1};
		data <= {fs_cnt, fx_cnt, 32'd200_000_000};
end
//wire   ncs_posedge;
//assign ncs_posedge = (!ncs_r1) & ncs_r0;
/*
reg      sending_flag;
reg      byte_flag = 1'b0;
reg[1:0] byte_cnt;
reg[4:0] send_state;
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		byte_flag       <= 1'b0;
	end
	else if(ncs_r1)
	begin
		case(send_state)
			5'b00001:
				if(!sending_flag)
				begin
					send_state <= 5'b00010;
					sending_flag <= 1'b1;
				end
				else
				begin
					send_state <= send_state;
					byte_flag <= 1'b0;
				end
			5'b00010:
				if(!sending_flag)
				begin
					send_state <= 5'b00100;
					sending_flag <= 1'b1;
				end
				else
					send_state <= send_state;
			5'b00100:
				if(!sending_flag)
				begin
					send_state <= 5'b01000;
					sending_flag <= 1'b1;
				end
				else
					send_state <= send_state;
			5'b01000:
				if(!sending_flag)
				begin
					send_state <= 5'b10000;
					sending_flag <= 1'b1;
				end
				else
					send_state <= send_state;
			5'b10000:
				if(!sending_flag)
				begin
					send_state <= 5'b00001;
					sending_flag <= 1'b1;
					byte_flag  <= 1'b1;
				end
				else
					send_state <= send_state;
			default:
				if(!sending_flag)
				begin
					send_state <= 5'b00001;
					sending_flag <= 1'b1;
				end					
				else
					send_state <= send_state;
		endcase
	end
	else if(!ncs_r1)
	begin
		if(sending_flag)
			sending_flag <= 1'b0;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		byte_cnt  <= 1'b0;
	end
	else if(byte_flag)
	begin
		if(byte_cnt == 2'd2)
			byte_cnt <= 1'b0;
		else
			byte_cnt <= byte_cnt + 1'b1;
	end
	else
	begin
		byte_cnt <= byte_cnt;
	end
end
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
		send_data <= 40'd0;
	else
	begin
		case(byte_cnt)
			2'd0: send_data <= {8'hfe, fs_cnt};
			2'd1: send_data <= {8'hfd, fx_cnt};
			2'd2: send_data <= {8'hfb, 32'd200_000_000};
			default: send_data <= send_data;
		endcase
	end
end
always@(posedge sys_clk)
begin
	if(!ncs_r1)
	begin
		case(send_state)
			5'b00001:
				data <= send_data[39:32];
			5'b00010:
				data <= send_data[31:24];
			5'b00100:
				data <= send_data[23:16];
			5'b01000:
				data <= send_data[15:8];
			5'b10000:
				data <= send_data[7:0];
			default:
				data <= data;
		endcase
	end
	else if(ncs_r1)
	begin
		data <= data;
	end
end
*/

SPI_Slave SPI_Slave_Ctrl
(
	.sys_clk   (sys_clk),
	.rst_n     (rst_n),
	.nCS       (ncs_r1),
	//.MOSI      (MOSI),
	.SCK       (sck_r1),
	.MISO      (MISO),
	.SEND_DATA (data)
	//.RECV_DATA (RECV_DATA),
);
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:04:52 07/31/2019 
// Design Name: 
// Module Name:    SPI_Slave 
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
module SPI_Slave
(
	input           sys_clk,
	input           rst_n,
	input           nCS,
	input           MOSI,
	input           SCK,
	output reg      MISO,
	input[7:0]      SEND_DATA,
	output reg[7:0] RECV_DATA
);
reg[2:0] sck_edge;
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
		sck_edge <= 3'b000;
	else
		sck_edge <= {sck_edge[1:0], SCK};
end
wire     sck_posedge, sck_negedge;
assign   sck_posedge = (sck_edge[2:1] == 2'b01);
assign   sck_negedge = (sck_edge[2:1] == 2'b10);
reg      rec_flag;
reg[1:0] rec_state;
reg[2:0] rec_flag_width;
reg[7:0] byte_recv;
reg[3:0] bit_recv_cnt;

always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		byte_recv      <= 1'b0;
		bit_recv_cnt   <= 1'b0;
	end
	else
	begin
		if(!nCS)
		begin
			if(sck_posedge)
			begin
				byte_recv    <= {byte_recv[6:0], MOSI};
				if(bit_recv_cnt == 4'h8)
				begin
					bit_recv_cnt <= bit_recv_cnt;
					RECV_DATA    <= byte_recv;
				end
				else
				begin
					bit_recv_cnt <= bit_recv_cnt + 1'b1;
				end
			end
		end
		else if(nCS)
		begin
			byte_recv    <= 1'b0;
			bit_recv_cnt <= 1'b0;
		end
	end
end
reg       sending_flag;
reg[7:0]  byte_sended;
reg[3:0]  bit_sended_cnt;
reg[1:0]  send_state;
always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		byte_sended    <= 8'h00;
		bit_sended_cnt <= 4'b0000;
	end
	else
	begin
		if(!nCS)
		begin
			case(send_state)
				2'b00:
				begin
					if(!sending_flag)
					begin
						send_state   <= 2'b01;
						sending_flag <= 1'b1;
						MISO         <= byte_sended[7];
					end
				end
				2'b01:
				begin
					if(sck_posedge)
					begin
						send_state <= 2'b11;
					end
				end
				2'b11:
				begin
					if(sck_negedge)
					begin
						MISO <= byte_sended[7];
						byte_sended <= {byte_sended[6:0], 1'b0};
						if(bit_sended_cnt == 4'h8)
						begin
							bit_sended_cnt <= bit_sended_cnt;
							sending_flag   <= 1'b0;
						end
						else
						begin
							bit_sended_cnt <= bit_sended_cnt + 1'b1;
						end
					end
				end
				default:
					send_state <= send_state;
			endcase
		end
		else if(nCS)
		begin
			sending_flag   <= 1'b0;
			bit_sended_cnt <= 1'b0;
			byte_sended    <= SEND_DATA;
			send_state     <= 2'b00;
			MISO           <= 1'b0;
		end
	end
end

endmodule

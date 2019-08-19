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
	input       key1,
	input       key2,
	input       key3,
	input       key4,
	input       nCS,
	input       MOSI,
	input       SCK,
	output      MISO,
	output[7:0] LCD_DATA,
	output      LCD_RW,
	output      LCD_EN,
	output      LCD_RS,
	output      LCD_ON,
	output      MISO_2,
	output      SCK_2,
	output      nCS_2
);
assign SCK_2 = SCK;
assign MISO_2 = MISO;
assign nCS_2 = nCS;
reg[7:0]    data = 8'h30;
wire[7:0]   RECV_DATA;
reg sck_r0;
reg sck_r1;
reg ncs_r0;
reg ncs_r1;
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
LCD1602_Top LCD1602_Top
(
	.sys_clk   (sys_clk),
	.rst_n     (rst_n),
	.data      (data),
	.LCD_DATA  (LCD_DATA),
	.LCD_RW    (LCD_RW),
	.LCD_EN    (LCD_EN),
	.LCD_RS    (LCD_RS),
	.LCD_ON    (LCD_ON)
);
SPI_Slave SPI_Slave_Ctrl
(
	.sys_clk   (sys_clk),
	.rst_n     (rst_n),
	.nCS       (ncs_r1),
	.MOSI      (MOSI),
	.SCK       (sck_r1),
	.MISO      (MISO),
	.SEND_DATA (data),
	.RECV_DATA (RECV_DATA)
);
wire key1_n;
wire key2_n;
wire key3_n;
wire key4_n;
KEY_Debounce KEY_Debounce_0
(
    .clk             (sys_clk),
    .rst             (~rst_n),
    .button_in       (key1),
    .button_negedge  (key1_n)
);
KEY_Debounce KEY_Debounce_1
(
    .clk             (sys_clk),
    .rst             (~rst_n),
    .button_in       (key2),
    .button_negedge  (key2_n)
);
KEY_Debounce KEY_Debounce_2
(
    .clk             (sys_clk),
    .rst             (~rst_n),
    .button_in       (key3),
    .button_negedge  (key3_n)
);
KEY_Debounce KEY_Debounce_3
(
    .clk             (sys_clk),
    .rst             (~rst_n),
    .button_in       (key4),
    .button_negedge  (key4_n)
);
wire[3:0] key;
assign    key = {~key4_n, ~key3_n, ~key2_n, ~key1_n};
reg[1:0]  key_state = S_IDLE;
localparam S_PLUS = 2'b01;
localparam S_MINUS = 2'b10;
localparam S_IDLE = 2'b00;

always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		key_state <= S_IDLE;
		//data <= RECV_DATA;
	end
	else
	begin
		case(key_state)
			S_PLUS:
			begin
				if(!ncs_r1)
				begin
					key_state <= key_state;
					data <= RECV_DATA + 1'b1;
				end
				else if(ncs_r1)
				begin
					data <= RECV_DATA + 1'b1;
					key_state <= S_IDLE;
				end
			end
			S_MINUS:
			begin
				if(!ncs_r1)
				begin
					key_state <= key_state;
					data <= RECV_DATA - 1'b1;
				end
				else if(ncs_r1)
				begin
					data <= RECV_DATA - 1'b1;
					key_state <= S_IDLE;
				end
			end
			S_IDLE:
			begin
				case(key)
					4'b1110:
					begin
						key_state <= S_PLUS;
					end
					4'b1101:
					begin
						key_state <= S_MINUS;
					end
					default:
					begin
						key_state <= S_IDLE;
						data <= ncs_r1 ? data : RECV_DATA;
					end
				endcase
			end
		endcase
	end
end

/*
always@(posedge sys_clk)
begin
	data <= RECV_DATA;
end
*/
endmodule

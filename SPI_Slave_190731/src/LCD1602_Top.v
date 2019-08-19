`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:24:59 07/25/2019 
// Design Name: 
// Module Name:    LCD1602_Top 
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
module LCD1602_Top
(
	input           sys_clk,
	input           rst_n,
	input[7:0]      data,
	output[7:0]     LCD_DATA,//8-bit LCD DATA
	output          LCD_RW,//LCD Read/Write Select,0=Write,1=Read
	output          LCD_EN,//LCD Enable
	output          LCD_RS,//LCD Command/Data select,0=Command,1=Data
	output          LCD_ON//LCD Power ON/OFF,0=OFF,1=ON
);

localparam       CHAR_CNT = 5'd31;
reg[4:0]         char_cnt;
reg[7:0]         data_display;
reg              lcd_clk;
reg[15:0]        count;
wire             LCD_WE;
//wire[7:0]        data_disp;
//assign           data_disp = data + 8'h30;
wire[255:0]      Data_string;
assign           Data_string = {data,"                               "};

always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
       begin 
       count <= 16'b0;
       lcd_clk <= 1'b0;
       end
    else if(count == 16'd65535)
       begin
       count <= 16'b0;
       lcd_clk <= ~lcd_clk;
       end
   else
       count <= count + 1'b1;
end

always@(posedge lcd_clk or negedge rst_n)
begin
	if(!rst_n)
		char_cnt <= 1'b0;
	else if(LCD_WE)
	begin
		if(char_cnt < CHAR_CNT)
			char_cnt <= char_cnt + 1'b1;
		else
			char_cnt <= 1'b0;
	end
	else
		char_cnt <= char_cnt;
end

always@(*)
begin
	case(char_cnt)
		5'd0: data_display <= Data_string[255:248];
		5'd1: data_display <= Data_string[247:240];
		5'd2: data_display <= Data_string[239:232];
		5'd3: data_display <= Data_string[231:224];
		5'd4: data_display <= Data_string[223:216];
		5'd5: data_display <= Data_string[215:208];
		5'd6: data_display <= Data_string[207:200];
		5'd7: data_display <= Data_string[199:192];
		5'd8: data_display <= Data_string[191:184];
		5'd9: data_display <= Data_string[183:176];
		5'd10: data_display <= Data_string[175:168];
		5'd11: data_display <= Data_string[167:160];
		5'd12: data_display <= Data_string[159:152];
		5'd13: data_display <= Data_string[151:144];
		5'd14: data_display <= Data_string[143:136];
		5'd15: data_display <= Data_string[135:128];
		5'd16: data_display <= Data_string[127:120];
		5'd17: data_display <= Data_string[119:112];
		5'd18: data_display <= Data_string[111:104];
		5'd19: data_display <= Data_string[103:96];
		5'd20: data_display <= Data_string[95:88];
		5'd21: data_display <= Data_string[87:80];
		5'd22: data_display <= Data_string[79:72];
		5'd23: data_display <= Data_string[71:64];
		5'd24: data_display <= Data_string[63:56];
		5'd25: data_display <= Data_string[55:48];
		5'd26: data_display <= Data_string[47:40];
		5'd27: data_display <= Data_string[39:32];
		5'd28: data_display <= Data_string[31:24];
		5'd29: data_display <= Data_string[23:16];
		5'd30: data_display <= Data_string[15:8];
		5'd31: data_display <= Data_string[7:0];
		default: data_display <= 8'd32;
	endcase
end

LCD1602_Driver LCD1602_U1
(
	.rst_n         (rst_n),
	.char_count    (char_cnt),
	.data_display  (data_display),
	.lcd_clk       (lcd_clk),
	.LCD_DATA      (LCD_DATA),
	.LCD_RW        (LCD_RW),
	.LCD_EN        (LCD_EN),
	.LCD_RS        (LCD_RS),
	.LCD_ON        (LCD_ON),
	.LCD_WE        (LCD_WE)
);
endmodule
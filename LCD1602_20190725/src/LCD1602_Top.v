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
	input[255:0]    String,
	output[7:0]     LCD_DATA,//8-bit LCD DATA
	output          LCD_RW,//LCD Read/Write Select,0=Write,1=Read
	output          LCD_EN,//LCD Enable
	output          LCD_RS,//LCD Command/Data select,0=Command,1=Data
	output          LCD_ON//LCD Power ON/OFF,0=OFF,1=ON
);

localparam   CHAR_CNT = 6'd31;
reg[5:0]     char_cnt;
reg[7:0]     data_display;
reg          lcd_clk;
reg[15:0]    count; //counter
wire         LCD_WE;
always@(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)  //reset
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
		6'd0: data_display <= String[255:248];
		6'd1: data_display <= String[247:240];
		6'd2: data_display <= String[239:232];
		6'd3: data_display <= String[231:224];
		6'd4: data_display <= String[223:216];
		6'd5: data_display <= String[215:208];
		6'd6: data_display <= String[207:200];
		6'd7: data_display <= String[199:192];
		6'd8: data_display <= String[191:184];
		6'd9: data_display <= String[183:176];
		6'd10: data_display <= String[175:168];
		6'd11: data_display <= String[167:160];
		6'd12: data_display <= String[159:152];
		6'd13: data_display <= String[151:144];
		6'd14: data_display <= String[143:136];
		6'd15: data_display <= String[135:128];
		6'd16: data_display <= String[127:120];
		6'd17: data_display <= String[119:112];
		6'd18: data_display <= String[111:104];
		6'd19: data_display <= String[103:96];
		6'd20: data_display <= String[95:88];
		6'd21: data_display <= String[87:80];
		6'd22: data_display <= String[79:72];
		6'd23: data_display <= String[71:64];
		6'd24: data_display <= String[63:56];
		6'd25: data_display <= String[55:48];
		6'd26: data_display <= String[47:40];
		6'd27: data_display <= String[39:32];
		6'd28: data_display <= String[31:24];
		6'd29: data_display <= String[23:16];
		6'd30: data_display <= String[15:8];
		6'd31: data_display <= String[7:0];
		default: data_display <= 8'd32;
	endcase
end

LCD1602_Master  LCD1602_U1
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

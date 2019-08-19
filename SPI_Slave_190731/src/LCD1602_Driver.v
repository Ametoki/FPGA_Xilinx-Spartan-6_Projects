`define LINE_1 15   //the number of line 1
`define LINE_2 31   //the number of line 1 and line 2
//=========================================================
// Company:  Jackin
// Engineer: Jackin
//
// Create Date:   2012-2-26   
// Design Name:   LCD_1602   
// Module Name:   LCD_1602   
// Project Name:  LCD_1602   
// Target Device: EP2C35F672
// Tool versions: Modelsim SE PLUS 6.2b  &  Quartus II 9.0 
// Description:   CFAH1602B-TMC-JP port
//              
// Dependencies:
// 
// Revision:
// Additional Comments:
//=========================================================
module LCD1602_Driver
(
	input            rst_n,
	input[4:0]       char_count,
	input[7:0]       data_display,
	input            lcd_clk,
	output reg[7:0]  LCD_DATA,//8-bit LCD DATA
	output           LCD_RW,//LCD Read/Write Select,0=Write,1=Read
	output           LCD_EN,//LCD Enable
	output reg       LCD_RS,//LCD Command/Data select,0=Command,1=Data
	output           LCD_ON,//LCD Power ON/OFF,0=OFF,1=ON
	output reg       LCD_WE
);

assign    LCD_ON = 1'b1;
assign    LCD_RW = 1'b0;
assign    LCD_EN = lcd_clk;
initial   LCD_WE = 1'b0;
reg[9:0]  state;

parameter     IDLE = 10'b00_0000_0000; //initial state
parameter    CLEAR = 10'b00_0000_0001; //clear
parameter   RETURN = 10'b00_0000_0010; //return home
parameter     MODE = 10'b00_0000_0100; //entry mode set
parameter  DISPLAY = 10'b00_0000_1000; //display ON/OFF control
parameter   SHIFT  = 10'b00_0001_0000; //cursor or display shift
parameter FUNCTION = 10'b00_0010_0000; //function set
parameter    CGRAM = 10'b00_0100_0000; //set CGRAM address
parameter    DDRAM = 10'b00_1000_0000; //set DDRAM address
parameter    WRITE = 10'b01_0000_0000; //write data to RAM
parameter     WAIT = 10'b10_0000_0000;

always@(posedge lcd_clk or negedge rst_n)
begin
    if(!rst_n)
       LCD_RS <= 1'b0;
    else if(state == WRITE)
       LCD_RS <= 1'b1;
    else
       LCD_RS <= 1'b0;
end

always@(posedge lcd_clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state <= IDLE;
		LCD_DATA <= 8'b1111_1111;
		LCD_WE <= 1'b0;
	end
	else
	begin
		case(state)
			IDLE:
			begin  
				state <= CLEAR;
				LCD_DATA <= 8'b1111_1111;
			end
			CLEAR:
			begin  
				state <= RETURN;
				LCD_DATA <= 8'b0000_0001;
			end
			RETURN:
			begin  
					state <= MODE;
				LCD_DATA <= 8'b0000_0010;
			end
			MODE:
			begin  
				state <= DISPLAY;
				LCD_DATA <= 8'b0000_0110;
			end
			DISPLAY:
			begin  
				state <= SHIFT;
				LCD_DATA <= 8'b0000_1100;
			end
			SHIFT:
			begin  
				state <= FUNCTION;
				LCD_DATA <= 8'b0001_0100;
			end
			FUNCTION:
			begin
				state <= DDRAM;
				LCD_DATA <= 8'b0011_1000;
			end
			DDRAM:
			begin
				state <= WRITE;
				LCD_WE <= 1'b1;
				if(char_count <= `LINE_1)
					LCD_DATA <= 8'b1000_0000 + char_count;//line 1
				else
					LCD_DATA <= 8'b1100_0000 + char_count - 5'd16;//line 2
			end
			WRITE:
			begin
				state <= DDRAM;
				LCD_WE <= 1'b0;
				LCD_DATA <= data_display;
			end
			WAIT:
			begin
				state <= DDRAM;
				LCD_WE <= 1'b0;
			end
		default:state <= IDLE;
		endcase   
	end
end
endmodule
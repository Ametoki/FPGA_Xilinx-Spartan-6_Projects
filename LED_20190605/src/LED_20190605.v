`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ametoki
// 
// Create Date:    21:53:18 06/05/2019 
// Design Name: 
// Module Name:    LED_20190605 
// Project Name: LOOP_LED
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
module LED_20190605
(
	input clk, //system clock 50MHz on board
	input rst_n, //reset, low active
	output reg[3:0] led //LED, use for control the LED signal on board
);
//define the time counter
reg[31:0] timer;
//cycle counter:from 0 to 4 sec
always@(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		timer <= 32'd0;
	else if (timer == 32'd199_999_999)
		timer <= 32'd0;
	else
		timer <= timer + 32'd1;
end
//LED control
always@(posedge clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
		led <= 4'b0000;
	else if (timer == 32'd49_999_999)
		led <= 4'b0001;
	else if (timer == 32'd99_999_999)
		led <= 4'b0010;
	else if (timer == 32'd149_999_999)
		led <= 4'b0100;
	else if (timer == 32'd199_999_999)
		led <= 4'b1000;
end
endmodule

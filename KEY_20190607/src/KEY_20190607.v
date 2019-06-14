`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ametoki
// 
// Create Date:    23:46:44 06/07/2019 
// Design Name: KEY_LED_TEST
// Module Name:    KEY_20190607 
// Project Name: KEY_LED_TEST
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
module KEY_20190607(
	input clk,
	input[3:0] key,
	output[3:0] led
    );
	
reg[3:0] led_r;
reg[3:0] led_r1;

always@(posedge clk)
begin
	led_r <= ~key;
end

always@(posedge clk)
begin
	led_r1 <= led_r;
end

assign led = led_r1;

endmodule

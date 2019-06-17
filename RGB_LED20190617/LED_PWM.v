`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:28:25 06/17/2019 
// Design Name: 
// Module Name:    LED_PWM 
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
module LED_PWM
(
	input      clk,
	input      rst_n,
	input[7:0] led_pwm,
	output reg led
);
localparam[15:0] Counter = 16'd19999;//125Hz//= pwm * 100 - 1
reg[15:0] clk_cnt;
wire[15:0] pwm_cnt = led_pwm * 16'd800 - 1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		clk_cnt <= 16'b0;
		led <= 1'b0;
	end
	else if(clk_cnt >= Counter)
	begin
		clk_cnt <= 16'b0;
		led <= 1'b1;
	end
	else if(clk_cnt >= pwm_cnt)
	begin
		clk_cnt <= clk_cnt + 16'b1;
		led <= 1'b0;
	end
	else
	begin
		clk_cnt <= clk_cnt + 16'b1;
		led <= 1'b1;
	end
end
endmodule

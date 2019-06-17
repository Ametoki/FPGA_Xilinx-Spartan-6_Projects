`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:08:58 06/17/2019 
// Design Name: 
// Module Name:    RGB_LED20190617 
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
module RGB_LED20190617
(
	input       clk,
	input       rst_n,
	input       key1,
	input       key2,
	input       key3,
	input       key4,
	output      LED1,
	output      LED2,
	output      LED3,
	output      Red,
	output      Green,
	output      Blue,
	output[5:0] seg_sel,
	output[7:0] seg_data
);
assign Red   = LED3;
assign Green = LED2;
assign Blue  = LED1;
reg[7:0]  led1_pwm;
reg[7:0]  led2_pwm;
reg[7:0]  led3_pwm;
initial
begin
	led1_pwm <= 8'd1;
	led2_pwm <= 8'd1;
	led3_pwm <= 8'd1;
end
LED_PWM LED_U1
(
	.clk      (clk),
	.rst_n    (rst_n),
	.led_pwm  (led1_pwm),
	.led      (LED3)
);
LED_PWM LED_U2
(
	.clk      (clk),
	.rst_n    (rst_n),
	.led_pwm  (led2_pwm),
	.led      (LED2)
);
LED_PWM LED_U3
(
	.clk      (clk),
	.rst_n    (rst_n),
	.led_pwm  (led3_pwm),
	.led      (LED1)
);
wire[3:0]  temp_0 = led1_pwm % 8'd10;
wire[3:0]  temp_1 = led1_pwm / 8'd10;
wire[3:0]  temp_2 = led2_pwm % 8'd10;
wire[3:0]  temp_3 = led2_pwm / 8'd10;
wire[3:0]  temp_4 = led3_pwm % 8'd10;
wire[3:0]  temp_5 = led3_pwm / 8'd10;
wire[7:0]  seg_data_0;
SEG_Decoder SEG_Decoder_0
(
    .bin_data  (temp_5),
    .seg_data  (seg_data_0)
);
wire[7:0] seg_data_1;
SEG_Decoder SEG_Decoder_1
(
    .bin_data  (temp_4),
    .seg_data  (seg_data_1)
);
wire[7:0] seg_data_2;
SEG_Decoder SEG_Decoder_2
(
    .bin_data  (temp_3),
    .seg_data  (seg_data_2)
);
wire[7:0] seg_data_3;
SEG_Decoder SEG_Decoder_3
(
    .bin_data  (temp_2),
    .seg_data  (seg_data_3)
);
wire[7:0] seg_data_4;
SEG_Decoder SEG_Decoder_4
(
    .bin_data  (temp_1),
    .seg_data  (seg_data_4)
);
wire[7:0] seg_data_5;
SEG_Decoder SEG_Decoder_5
(
    .bin_data  (temp_0),
    .seg_data  (seg_data_5)
);
SEG_Scan SEG_Scan
(
    .clk        (clk),
    .rst_n      (rst_n),
    .seg_sel    (seg_sel),
    .seg_data   (seg_data),
    .seg_data_0 (seg_data_0),
    .seg_data_1 (seg_data_1), 
    .seg_data_2 (seg_data_2),
    .seg_data_3 (seg_data_3),
    .seg_data_4 (seg_data_4),
    .seg_data_5 (seg_data_5)
);
wire key1_n;
wire key2_n;
wire key3_n;
wire key4_n;
KEY_Debounce KEY_Debounce_0
(
    .clk             (clk),
    .rst             (~rst_n),
    .button_in       (key1),
    .button_posedge  (),
    .button_negedge  (key1_n),
    .button_out      ()
);
KEY_Debounce KEY_Debounce_1
(
    .clk             (clk),
    .rst             (~rst_n),
    .button_in       (key2),
    .button_posedge  (),
    .button_negedge  (key2_n),
    .button_out      ()
);
KEY_Debounce KEY_Debounce_2
(
    .clk             (clk),
    .rst             (~rst_n),
    .button_in       (key3),
    .button_posedge  (),
    .button_negedge  (key3_n),
    .button_out      ()
);
KEY_Debounce KEY_Debounce_3
(
    .clk             (clk),
    .rst             (~rst_n),
    .button_in       (key4),
    .button_posedge  (),
    .button_negedge  (key4_n),
    .button_out      ()
);
wire[3:0] key = {~key4_n, ~key3_n, ~key2_n, ~key1_n};
reg PM_Mode;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		led1_pwm <= 8'd1;
		led2_pwm <= 8'd1;
		led3_pwm <= 8'd1;
	end
	else
	begin
		case(key)
		4'b1110:
		begin
			if(!PM_Mode)
			begin
				if(led3_pwm < 8'd25)
					led3_pwm <= led3_pwm + 8'd1;
				else
					led3_pwm <= led3_pwm;
			end
			else
			begin
				if(led3_pwm > 8'd1)
					led3_pwm <= led3_pwm - 8'd1;
				else
					led3_pwm <= led3_pwm;
			end
		end
		4'b1101:
		begin
			if(!PM_Mode)
			begin
				if(led2_pwm < 8'd25)
					led2_pwm <= led2_pwm + 8'd1;
				else
					led2_pwm <= led2_pwm;
			end
			else
			begin
				if(led2_pwm > 8'd1)
					led2_pwm <= led2_pwm - 8'd1;
				else
					led2_pwm <= led2_pwm;
			end
		end
		4'b1011:
		begin
			if(!PM_Mode)
			begin
				if(led1_pwm < 8'd25)
					led1_pwm <= led1_pwm + 8'd1;
				else
					led1_pwm <= led1_pwm;
			end
			else
			begin
				if(led1_pwm > 8'd1)
					led1_pwm <= led1_pwm - 8'd1;
				else
					led1_pwm <= led1_pwm;
			end
		end
		4'b0111:
		begin
			PM_Mode <= !PM_Mode;
		end
		default:
		begin
			led1_pwm <= led1_pwm;
			led2_pwm <= led2_pwm;
			led3_pwm <= led3_pwm;
			PM_Mode <= PM_Mode;
		end
		endcase
	end
end
endmodule

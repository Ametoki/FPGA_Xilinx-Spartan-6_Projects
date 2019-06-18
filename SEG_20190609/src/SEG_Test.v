`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:45:10 06/09/2019 
// Design Name: 
// Module Name:    SEG_test 
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
module SEG_Test(
	input       clk,
	input       rst_n,
	input  		key1,
	input  		key2,
	input  		key3,
	input  		key4,
	output[5:0] seg_sel,
	output[7:0] seg_data
    );

localparam[31:0] timer_lmt = 32'd49_999_999;
wire clk_en = !PM_Mode;
reg en_1Hz_en;
reg[31:0] timer_cnt;
reg en_1Hz;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		en_1Hz <= 1'b0;
		timer_cnt <= 32'd0;
	end
	else if(clk_en)
	begin
		if(timer_cnt >= timer_lmt)
		begin
			en_1Hz <= 1'b1;
			timer_cnt <= 32'd0;
		end
		else
		begin
			en_1Hz <= 1'b0;
			timer_cnt <= timer_cnt + 32'd1;
		end
	end
end
wire[3:0] count0;
wire[3:0] count1;
wire co_0;
wire do_0;
reg Freq_Key1_P;
reg Freq_Key1_M;
reg Freq_Key2_P;
reg Freq_Key2_M;
reg Freq_Key3_P;
reg Freq_Key3_M;
Counter_M60 Counter_0(
	.clk   (clk),
	.rst_n (rst_n),
	.en    (en_1Hz || Freq_Key1_P),
	.clr   (1'b0),
	.data_0(count0),
	.data_1(count1),
	.co    (co_0),
	.di    (Freq_Key1_M),
	.d0    (do_0)
);
wire[3:0] count2;
wire[3:0] count3;
wire co_1;
wire do_1;
Counter_M60 Counter_1(
	.clk   (clk),
	.rst_n (rst_n),
	.en    (co_0 || Freq_Key2_P),
	.clr   (1'b0),
	.data_0(count2),
	.data_1(count3),
	.co    (co_1),
	.di    (do_0 || Freq_Key2_M),
	.d0    (do_1)
);
wire[3:0] count4;
wire[3:0] count5;
wire co_2;
wire do_2;
Counter_M24 Counter_2(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (co_1 || Freq_Key3_P),
    .clr   (1'b0),
    .data_0(count4),
	.data_1(count5),
	.co    (co_2),
	.di    (d0_1 || Freq_Key3_M),
	.d0    (do_2)
);
wire[7:0] seg_data_0;
SEG_Decoder SEG_Decoder_0(
    .bin_data  (count5),
    .seg_data  (seg_data_0)
);
wire[7:0] seg_data_1;
SEG_Decoder SEG_Decoder_1(
    .bin_data  (count4),
    .seg_data  (seg_data_1)
);
wire[7:0] seg_data_2;
SEG_Decoder SEG_Decoder_2(
    .bin_data  (count3),
    .seg_data  (seg_data_2)
);
wire[7:0] seg_data_3;
SEG_Decoder SEG_Decoder_3(
    .bin_data  (count2),
    .seg_data  (seg_data_3)
);
wire[7:0] seg_data_4;
SEG_Decoder SEG_Decoder_4(
    .bin_data  (count1),
    .seg_data  (seg_data_4)
);

wire[7:0] seg_data_5;
SEG_Decoder SEG_Decoder_5(
    .bin_data  (count0),
    .seg_data  (seg_data_5)
);

SEG_Scan SEG_Scan(
    .clk        (clk),
    .rst_n      (rst_n),
    .seg_sel    (seg_sel),
    .seg_data   (seg_data),
    .seg_data_0 (seg_data_0),
    .seg_data_1 (seg_data_1 & 8'h7f), 
    .seg_data_2 (seg_data_2),
    .seg_data_3 (seg_data_3 & 8'h7f),
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
		Freq_Key1_P <= 0;
		Freq_Key1_M <= 0;
		Freq_Key2_P <= 0;
		Freq_Key2_M <= 0;
		Freq_Key3_P <= 0;
		Freq_Key3_M <= 0;
		PM_Mode <= 0;
	end
	else
	begin
		case(key)
		4'b1110:
		begin
			if(!PM_Mode)
			begin
				Freq_Key3_P <= 1'b1;
			end
			else
			begin
				Freq_Key3_M <= 1'b1;
			end
		end
		4'b1101:
		begin
			if(!PM_Mode)
			begin
				Freq_Key2_P <= 1'b1;
			end
			else
			begin
				Freq_Key2_M <= 1'b1;
			end
		end
		4'b1011:
		begin
			if(!PM_Mode)
			begin
				Freq_Key1_P <= 1'b1;
			end
			else
			begin
				Freq_Key1_M <= 1'b1;
			end
		end
		4'b0111:
		begin
			PM_Mode <= !PM_Mode;
		end
		default:
		begin
			Freq_Key1_P <= 0;
			Freq_Key1_M <= 0;
			Freq_Key2_P <= 0;
			Freq_Key2_M <= 0;
			Freq_Key3_P <= 0;
			Freq_Key3_M <= 0;
			PM_Mode <= PM_Mode;
		end
		endcase
	end
end
endmodule

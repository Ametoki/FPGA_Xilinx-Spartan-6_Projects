`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:15:24 06/18/2019 
// Design Name: 
// Module Name:    DS1302_TOP 
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
module DS1302_Top
(
	input           clk,
	input           rst_n,
	output          rtc_sclk,
	output          rtc_ce,
	inout           rtc_data,
	input           key1,
	input           key2,
	input           key3,
	input           key4,
	output reg[7:0] seg_en,
	output[5:0]     seg_sel,
	output[7:0]     seg_data
);
wire[7:0] read_second;
wire[7:0] read_minute;
wire[7:0] read_hour;
wire[7:0] read_date;
wire[7:0] read_month;
wire[7:0] read_week;
wire[7:0] read_year;
reg[7:0]  write_second;
reg[7:0]  write_minute;
reg[7:0]  write_hour;
reg[7:0]  write_date;
reg[7:0]  write_month;
reg[7:0]  write_week;
reg[7:0]  write_year;
reg       CH;
SEG_BCD SEG_BCD_U0
(
	.clk      (clk),
    .rst_n    (rst_n),
	.EN       (seg_en),
    .seg_sel  (seg_sel),
    .seg_data (seg_data),
    .seg_bcd  ({read_hour,read_minute,read_second})
);
DS1302_Test DS1302_Test_U0(
    .rst          (~rst_n),
    .clk          (clk),
    .ds1302_ce    (rtc_ce),
    .ds1302_sclk  (rtc_sclk),
    .ds1302_io    (rtc_data),
	.CH           (CH),
    .read_second  (read_second),
    .read_minute  (read_minute),
    .read_hour    (read_hour),
    .read_date    (read_date),
    .read_month   (read_month),
    .read_week    (read_week),
    .read_year    (read_year),
	.write_second (write_second),
	.write_minute (write_minute),
	.write_hour   (write_hour),
	.write_date   (write_date),
	.write_month  (write_month),
	.write_week   (write_week),
	.write_year   (write_year)
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
reg[1:0]  RTC_Mode;
initial
begin
	CH <= 1'b0;
	RTC_Mode <= 2'd0;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		CH <= 1'b0;
		RTC_Mode <= 2'd0;
	end
	else
	begin
		case(key)
		4'b1110:
		begin
			if(RTC_Mode == 2'd1)
			begin
				if(write_hour[7:4] == 4'h2 && write_hour[3:0] == 4'h3)
				begin
					write_hour[7:4] <= 4'h0;
					write_hour[3:0] <= 4'h0;
				end
				else if(write_hour[3:0] == 4'h9)
				begin
					write_hour[7:4] <= write_hour[7:4] + 4'h1;
					write_hour[3:0] <= 4'h0;
				end
				else
				begin
					write_hour[7:4] <= write_hour[7:4];
					write_hour[3:0] <= write_hour[3:0] + 4'h1;
				end
			end
			else if(RTC_Mode == 2'd2)
			begin
				if(write_hour[7:4] == 4'h0 && write_hour[3:0] == 4'h0)
				begin
					write_hour[7:4] <= 4'h2;
					write_hour[3:0] <= 4'h3;
				end
				else if(write_hour[3:0] == 4'h0)
				begin
					write_hour[7:4] <= write_hour[7:4] - 4'h1;
					write_hour[3:0] <= 4'h9;
				end
				else
				begin
					write_hour[7:4] <= write_hour[7:4];
					write_hour[3:0] <= write_hour[3:0] - 4'h1;
				end
			end
		end
		4'b1101:
		begin
			if(RTC_Mode == 2'd1)
			begin
				if(write_minute[7:4] == 4'h5 && write_minute[3:0] == 4'h9)
				begin
					write_minute[7:4] <= 4'h0;
					write_minute[3:0] <= 4'h0;
				end
				else if(write_minute[3:0] == 4'h9)
				begin
					write_minute[7:4] <= write_minute[7:4] + 4'h1;
					write_minute[3:0] <= 4'h0;
				end
				else
				begin
					write_minute[7:4] <= write_minute[7:4];
					write_minute[3:0] <= write_minute[3:0] + 4'h1;
				end
			end
			else if(RTC_Mode == 2'd2)
			begin
				if(write_minute[7:4] == 4'h0 && write_minute[3:0] == 4'h0)
				begin
					write_minute[7:4] <= 4'h5;
					write_minute[3:0] <= 4'h9;
				end
				else if(write_minute[3:0] == 4'h0)
				begin
					write_minute[7:4] <= write_minute[7:4] - 4'h1;
					write_minute[3:0] <= 4'h9;
				end
				else
				begin
					write_minute[7:4] <= write_minute[7:4];
					write_minute[3:0] <= write_minute[3:0] - 4'h1;
				end
			end
		end
		4'b1011:
		begin
			if(RTC_Mode == 2'd1)
			begin
				if(write_second[7:4] == 4'h5 && write_second[3:0] == 4'h9)
				begin
					write_second[7:4] <= 4'h0;
					write_second[3:0] <= 4'h0;
				end
				else if(write_second[3:0] == 4'h9)
				begin
					write_second[7:4] <= write_second[7:4] + 4'h1;
					write_second[3:0] <= 4'h0;
				end
				else
				begin
					write_second[7:4] <= write_second[7:4];
					write_second[3:0] <= write_second[3:0] + 4'h1;
				end
			end
			else if(RTC_Mode == 2'd2)
			begin
				if(write_second[7:4] == 4'h0 && write_second[3:0] == 4'h0)
				begin
					write_second[7:4] <= 4'h5;
					write_second[3:0] <= 4'h9;
				end
				else if(write_second[3:0] == 4'h0)
				begin
					write_second[7:4] <= write_second[7:4] - 4'h1;
					write_second[3:0] <= 4'h9;
				end
				else
				begin
					write_second[7:4] <= write_second[7:4];
					write_second[3:0] <= write_second[3:0] - 4'h1;
				end
			end
		end
		4'b0111:
		case(RTC_Mode)
			2'd0:
				begin
					write_second <= read_second;
					write_minute <= read_minute;
					write_hour   <= read_hour;
					write_date   <= read_date;
					write_month  <= read_month;
					write_week   <= read_week;
					write_year   <= read_year;
					CH <= 1'b1;
					RTC_Mode <= RTC_Mode + 2'b1;
				end
			2'd1:
				RTC_Mode <= RTC_Mode + 2'b1;
			2'd2:
				begin
					CH <= 1'b0;
					RTC_Mode <= 2'b0;
				end
		endcase
		default:
		begin
			write_second <= write_second;
			write_minute <= write_minute;
			write_hour   <= write_hour;
			write_date   <= write_date;
			write_month  <= write_month;
			write_week   <= write_week;
			write_year   <= write_year;
			RTC_Mode     <= RTC_Mode;
		end
		endcase
	end
end
/*
always@(posedge clk)
begin
	write_second <= read_second;
	write_minute <= read_minute;
	write_hour   <= read_hour;
	write_date   <= read_date;
	write_month  <= read_month;
	write_week   <= read_week;
	write_year   <= read_year;
end
*/
/*
wire[5:0] Key_PM = {Key3_M, Key3_P, Key2_M, Key2_P, Key1_M, Key1_P};
always@(posedge clk)
begin
	case(Key_PM)
		6'b000001:
		if(read_second < 8'h59)
			write_second <= read_second + 8'b1;
		else
			write_second <= 8'h0;
		6'b000010:
		if(read_second > 8'h0) 
			write_second <= read_second - 8'b1;
		else
			write_second <= 8'h59;
		6'b000100:
		if(read_minute < 8'h59)
			write_minute <= read_minute + 8'b1;
		else
			write_minute <= 8'h0;
		6'b001000:
		if(write_minute > 8'h0) 
			write_minute <= read_minute - 8'b1;
		else
			write_minute <= 8'h59;
		6'b010000:
		if(read_hour < 8'h23)
			write_hour <= read_hour + 8'b1;
		else
			write_hour <= 8'h0;
		6'b100000:
		if(write_hour > 8'h0) 
			write_hour <= read_hour - 8'b1;
		else
			write_hour <= 8'h23;
		default:
			begin
				write_second <= 8'h2;//read_second;
				write_minute <= 8'h2;//read_minute;
				write_hour   <= 8'h2;//read_hour;
				write_date   <= 8'h2;//read_date;
				write_month  <= 8'h2;//read_month;
				write_week   <= 8'h2;//read_week;
				write_year   <= 8'h2//read_year;
			end
	endcase
end
*/
reg[31:0]  timer_cnt;
localparam seg_counter = 32'd12_499_999;
always@(posedge clk)
begin
	if(RTC_Mode == 1 || RTC_Mode == 2)
	begin
		if(timer_cnt >= seg_counter)
		begin
			timer_cnt <= 32'b0;
			seg_en <= ~seg_en;
		end
		else
		begin
			timer_cnt <= timer_cnt + 32'b1;
			seg_en <= seg_en;
		end
	end
	else
		seg_en <= 8'b0;
end
endmodule

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
	output[5:0]     seg_sel,
	output[7:0]     seg_data
);
localparam S_DISP_TIME    = 4'd0;
localparam S_DISP_DATE    = 4'd1;
localparam S_DISP_YEAR    = 4'd2;
localparam S_WRITE_TIME_P = 4'd3;
localparam S_WRITE_TIME_M = 4'd4;
localparam S_WRITE_DATE_P = 4'd5;
localparam S_WRITE_DATE_M = 4'd6;
localparam S_WRITE_YEAR_P = 4'd7;
localparam S_WRITE_YEAR_M = 4'd8;
reg[3:0]   state, next_state;
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
reg[23:0] seg_bcd;
reg[7:0]  seg_en;
reg[7:0]  seg_en_0;
reg[7:0]  seg_en_1;
reg[7:0]  seg_en_2;
reg[7:0]  seg_en_3;
reg[7:0]  seg_en_4;
reg[7:0]  seg_en_5;
reg[7:0]  seg_dp_0;
reg[7:0]  seg_dp_1;
reg       CH;
initial
begin
	seg_en   <=  8'h00;
	seg_en_0 <=  8'h00;
	seg_en_1 <=  8'h00;
	seg_en_2 <=  8'h00;
	seg_en_3 <=  8'h00;
	seg_en_4 <=  8'h00;
	seg_en_5 <=  8'h00;
	seg_dp_0 <=  8'hff;
	seg_dp_1 <=  8'hff;
	CH       <=  1'b0;
	state    <=  S_DISP_TIME;
end
SEG_BCD SEG_BCD_U0
(
	.clk      (clk),
    .rst_n    (rst_n),
	.EN       (seg_en),
	.EN_0     (seg_en_0),
	.EN_1     (seg_en_1),
	.EN_2     (seg_en_2),
	.EN_3     (seg_en_3),
	.EN_4     (seg_en_4),
	.EN_5     (seg_en_5),
	.DP_0     (seg_dp_0),
	.DP_1     (seg_dp_1),
    .seg_sel  (seg_sel),
    .seg_data (seg_data),
    .seg_bcd  (seg_bcd)
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
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		next_state <= S_DISP_TIME;
	end
	else
	begin
		case(key)
		4'b1110:
			case(state)
				S_DISP_TIME:
					next_state <= S_DISP_DATE;
				S_DISP_DATE:
					next_state <= S_DISP_YEAR;
				S_DISP_YEAR:
					next_state <= S_DISP_TIME;
				S_WRITE_TIME_P:
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
				S_WRITE_TIME_M:
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
				S_WRITE_DATE_P:
					if(write_month[7:4] == 4'h1 && write_month[3:0] == 4'h2)
					begin
						write_month[7:4] <= 4'h0;
						write_month[3:0] <= 4'h1;
					end
					else if(write_month[3:0] == 4'h9)
					begin
						write_month[7:4] <= write_month[7:4] + 4'h1;
						write_month[3:0] <= 4'h0;
					end
					else
					begin
						write_month[7:4] <= write_month[7:4];
						write_month[3:0] <= write_month[3:0] + 4'h1;
					end
				S_WRITE_DATE_M:
					if(write_month[7:4] == 4'h0 && write_month[3:0] == 4'h1)
					begin
						write_month[7:4] <= 4'h1;
						write_month[3:0] <= 4'h2;
					end
					else if(write_month[3:0] == 4'h0)
					begin
						write_month[7:4] <= write_month[7:4] - 4'h1;
						write_month[3:0] <= 4'h9;
					end
					else
					begin
						write_month[7:4] <= write_month[7:4];
						write_month[3:0] <= write_month[3:0] - 4'h1;
					end
				S_WRITE_YEAR_P:
					if(write_year[7:4] == 4'h9 && write_year[3:0] == 4'h9)
					begin
						write_year[7:4] <= 4'h0;
						write_year[3:0] <= 4'h0;
					end
					else if(write_year[3:0] == 4'h9)
					begin
						write_year[7:4] <= write_year[7:4] + 4'h1;
						write_year[3:0] <= 4'h0;
					end
					else
					begin
						write_year[7:4] <= write_year[7:4];
						write_year[3:0] <= write_year[3:0] + 4'h1;
					end
				S_WRITE_YEAR_M:
					if(write_year[7:4] == 4'h0 && write_year[3:0] == 4'h0)
					begin
						write_year[7:4] <= 4'h9;
						write_year[3:0] <= 4'h9;
					end
					else if(write_year[3:0] == 4'h0)
					begin
						write_year[7:4] <= write_year[7:4] - 4'h1;
						write_year[3:0] <= 4'h9;
					end
					else
					begin
						write_year[7:4] <= write_year[7:4];
						write_year[3:0] <= write_year[3:0] - 4'h1;
					end
				default:
					next_state <= next_state;
			endcase
		4'b1101:
			case(state)
				S_WRITE_TIME_P:
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
				S_WRITE_TIME_M:
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
				S_WRITE_DATE_P:
					begin
						case(write_month)
							8'h01, 8'h03, 8'h05, 8'h07, 8'h08, 8'h10, 8'h12:
								if(write_date[7:4] == 4'h3 && write_date[3:0] == 4'h1)
									begin
										write_date[7:4] <= 4'h0;
										write_date[3:0] <= 4'h1;
									end
								else if(write_date[3:0] == 4'h9)
								begin
									write_date[7:4] <= write_date[7:4] + 4'h1;
									write_date[3:0] <= 4'h0;
								end
								else
								begin
									write_date[7:4] <= write_date[7:4];
									write_date[3:0] <= write_date[3:0] + 4'h1;
								end
							8'h02:
								if(write_date[7:4] == 4'h2 && write_date[3:0] == 4'h8)
									begin
										write_date[7:4] <= 4'h0;
										write_date[3:0] <= 4'h1;
									end
								else if(write_date[3:0] == 4'h9)
								begin
									write_date[7:4] <= write_date[7:4] + 4'h1;
									write_date[3:0] <= 4'h0;
								end
								else
								begin
									write_date[7:4] <= write_date[7:4];
									write_date[3:0] <= write_date[3:0] + 4'h1;
								end
							8'h04, 8'h06, 8'h09, 8'h11:
								if(write_date[7:4] == 4'h3 && write_date[3:0] == 4'h0)
									begin
										write_date[7:4] <= 4'h0;
										write_date[3:0] <= 4'h1;
									end
								else if(write_date[3:0] == 4'h9)
								begin
									write_date[7:4] <= write_date[7:4] + 4'h1;
									write_date[3:0] <= 4'h0;
								end
								else
								begin
									write_date[7:4] <= write_date[7:4];
									write_date[3:0] <= write_date[3:0] + 4'h1;
								end
							default:
							begin
								if(write_date[7:4] == 4'h3 && write_date[3:0] == 4'h0)
									begin
										write_date[7:4] <= 4'h0;
										write_date[3:0] <= 4'h1;
									end
								else if(write_date[3:0] == 4'h9)
								begin
									write_date[7:4] <= write_date[7:4] + 4'h1;
									write_date[3:0] <= 4'h0;
								end
								else
								begin
									write_date[7:4] <= write_date[7:4];
									write_date[3:0] <= write_date[3:0] + 4'h1;
								end
							end
						endcase
					end
				S_WRITE_DATE_M:
				begin
					case(write_month)
						8'h01, 8'h03, 8'h05, 8'h07, 8'h08, 8'h10, 8'h12:
							if(write_date[7:4] == 4'h0 && write_date[3:0] == 4'h1)
								begin
									write_date[7:4] <= 4'h3;
									write_date[3:0] <= 4'h1;
								end
							else if(write_date[3:0] == 4'h0)
							begin
								write_date[7:4] <= write_date[7:4] - 4'h1;
								write_date[3:0] <= 4'h9;
							end
							else
							begin
								write_date[7:4] <= write_date[7:4];
								write_date[3:0] <= write_date[3:0] - 4'h1;
							end
						8'h02:
							if(write_date[7:4] == 4'h0 && write_date[3:0] == 4'h1)
								begin
									write_date[7:4] <= 4'h2;
									write_date[3:0] <= 4'h8;
								end
							else if(write_date[3:0] == 4'h0)
							begin
								write_date[7:4] <= write_date[7:4] - 4'h1;
								write_date[3:0] <= 4'h9;
							end
							else
							begin
								write_date[7:4] <= write_date[7:4];
								write_date[3:0] <= write_date[3:0] - 4'h1;
							end
						8'h04, 8'h06, 8'h09, 8'h11:
							if(write_date[7:4] == 4'h0 && write_date[3:0] == 4'h1)
								begin
									write_date[7:4] <= 4'h3;
									write_date[3:0] <= 4'h0;
								end
							else if(write_date[3:0] == 4'h0)
							begin
								write_date[7:4] <= write_date[7:4] - 4'h1;
								write_date[3:0] <= 4'h9;
							end
							else
							begin
								write_date[7:4] <= write_date[7:4];
								write_date[3:0] <= write_date[3:0] - 4'h1;
							end
						default:
							if(write_date[7:4] == 4'h0 && write_date[3:0] == 4'h1)
								begin
									write_date[7:4] <= 4'h3;
									write_date[3:0] <= 4'h0;
								end
							else if(write_date[3:0] == 4'h0)
							begin
								write_date[7:4] <= write_date[7:4] - 4'h1;
								write_date[3:0] <= 4'h9;
							end
							else
							begin
								write_date[7:4] <= write_date[7:4];
								write_date[3:0] <= write_date[3:0] - 4'h1;
							end
					endcase
				end
				default:
					next_state <= next_state;
			endcase
		4'b1011:
			case(state)
				S_WRITE_TIME_P:
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
				S_WRITE_TIME_M:
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
				S_WRITE_DATE_P:
					if(write_week == 4'h7)
						write_week <= 4'h1;
					else
						write_week <= write_week + 4'h1;
				S_WRITE_DATE_M:
					if(write_week == 4'h1)
						write_week <= 4'h7;
					else
						write_week <= write_week - 4'h1;
				default:
					next_state <= next_state;
			endcase
		4'b0111:
			case(state)
				S_DISP_TIME:
				begin
					write_second <= read_second;
					write_minute <= read_minute;
					write_hour   <= read_hour;
					write_date   <= read_date;
					write_month  <= read_month;
					write_week   <= read_week;
					write_year   <= read_year;
					next_state   <= S_WRITE_TIME_P;
				end
				S_WRITE_TIME_P:
					next_state <= S_WRITE_TIME_M;
				S_WRITE_TIME_M:
					next_state <= S_WRITE_DATE_P;
				S_WRITE_DATE_P:
					next_state <= S_WRITE_DATE_M;
				S_WRITE_DATE_M:
					next_state <= S_WRITE_YEAR_P;
				S_WRITE_YEAR_P:
					next_state <= S_WRITE_YEAR_M;
				S_WRITE_YEAR_M:
					next_state <= S_DISP_TIME;
				default:
					next_state <= next_state;
			endcase
		default:
			begin
				next_state <= next_state;
			end
		endcase
	end
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state <= S_DISP_TIME;
	else
		state <= next_state;
end
reg[31:0]  timer_cnt;
localparam seg_counter = 32'd12_499_999;
always@(posedge clk)
begin
	case(state)
		S_WRITE_TIME_P, S_WRITE_TIME_M, S_WRITE_DATE_P, S_WRITE_DATE_M, S_WRITE_YEAR_P, S_WRITE_YEAR_M:
		begin
			CH <= 1'b1;
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
		S_DISP_TIME, S_DISP_DATE, S_DISP_YEAR:
		begin
			CH <= 1'b0;
			seg_en <= 8'h00;
		end
		default:
		begin
			CH <= 1'b0;
			seg_en <= 8'h00;
		end
	endcase
end
always@(*)
begin
	case(state)
		S_DISP_TIME, S_WRITE_TIME_P, S_WRITE_TIME_M:
			begin
				seg_dp_0 <= 8'h7f;
				seg_dp_1 <= 8'h7f;
			end
		S_DISP_DATE, S_WRITE_DATE_P, S_WRITE_DATE_M:
			begin
				seg_dp_0 <= 8'h7f;
				seg_dp_1 <= 8'hff;
			end
		default:
			begin
				seg_dp_0 <= 8'hff;
				seg_dp_1 <= 8'hff;
			end
	endcase
end
always@(*)
begin
	case(state)
		S_DISP_TIME, S_WRITE_TIME_P, S_WRITE_TIME_M:
			seg_bcd <= {read_hour, read_minute, read_second};
		S_DISP_DATE, S_WRITE_DATE_P, S_WRITE_DATE_M:
			seg_bcd <= {read_month, read_date, read_week};
		S_DISP_YEAR, S_WRITE_YEAR_P, S_WRITE_YEAR_M:
			seg_bcd <= {4'h0, 8'h20, read_year, 4'h0};
		default:
			seg_bcd <= {read_hour, read_minute, read_second};
	endcase
end
always@(*)
begin
	case(state)
		S_DISP_TIME, S_WRITE_TIME_P, S_WRITE_TIME_M:
			begin
				//seg_en   <=  8'h00;
				seg_en_0 <=  8'h00;
				seg_en_1 <=  8'h00;
				seg_en_2 <=  8'h00;
				seg_en_3 <=  8'h00;
				seg_en_4 <=  8'h00;
				seg_en_5 <=  8'h00;
			end
		S_DISP_DATE, S_WRITE_DATE_P, S_WRITE_DATE_M:
			begin
				//seg_en   <=  8'h00;
				seg_en_0 <=  8'h00;
				seg_en_1 <=  8'h00;
				seg_en_2 <=  8'h00;
				seg_en_3 <=  8'h00;
				seg_en_4 <=  8'hff;
				seg_en_5 <=  8'h00;
			end
		S_DISP_YEAR, S_WRITE_YEAR_P, S_WRITE_YEAR_M:
			begin
				//seg_en   <=  8'h00;
				seg_en_0 <=  8'hff;
				seg_en_1 <=  8'h00;
				seg_en_2 <=  8'h00;
				seg_en_3 <=  8'h00;
				seg_en_4 <=  8'h00;
				seg_en_5 <=  8'hff;
			end
		default:
			begin
				//seg_en   <=  8'h00;
				seg_en_0 <=  8'h00;
				seg_en_1 <=  8'h00;
				seg_en_2 <=  8'h00;
				seg_en_3 <=  8'h00;
				seg_en_4 <=  8'h00;
				seg_en_5 <=  8'h00;
			end
	endcase
end
endmodule

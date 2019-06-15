`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:22:38 06/12/2019 
// Design Name: 
// Module Name:    Generator_Test 
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
module Generator_Test
(
	input   clk,
	input   rst_n,
	input  	key1,
	input  	key2,
	input  	key3,
	input  	key4,
	output  Square,
	output[5:0] seg_sel,
	output[7:0] seg_data
);
reg[31:0]  Freq;
wire[3:0]  temp_0;
wire[3:0]  temp_1;
wire[3:0]  temp_2;
wire[3:0]  temp_3;
wire[3:0]  temp_4;
wire[3:0]  temp_5;
always@(posedge clk)
begin
	if(Freq == 32'b0)
	begin
		Freq <= 32'b1;
	end
	else
	begin
		Freq <= {28'b0,temp_0}
			  + {28'b0,temp_1} * 32'd10 
			  + {28'b0,temp_2} * 32'd100 
			  + {28'b0,temp_3} * 32'd1000
			  + {28'b0,temp_4} * 32'd10000
			  + {28'b0,temp_5} * 32'd100000;
	end
end
Generator Generator_0
(
	.clk    (clk),
	.rst_n  (rst_n),
	.Freq   (Freq),
	.Square (Square)
//	.Counter (Counter)
);
wire[7:0] seg_data_0;
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
wire co_0;
wire do_0;
reg Freq_plus;
reg Freq_min;
reg Freq_Lplus;
reg Freq_Lmin;
Counter_M10 Counter_M10_0(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (Freq_plus),
    .clr   (1'b0),
    .data  (temp_0),
    .co    (co_0),
	.di    (Freq_min),
	.d0    (do_0)
 );
wire co_1;
wire do_1;
Counter_M10 Counter_M10_1(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (co_0),
    .clr   (1'b0),
    .data  (temp_1),
    .co    (co_1),
	.di    (do_0),
	.d0    (do_1)
 );
wire co_2;
wire do_2;
Counter_M10 Counter_M10_2(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (co_1),
    .clr   (1'b0),
    .data  (temp_2),
    .co    (co_2),
	.di    (do_1),
	.d0    (do_2)
);
wire co_3;
wire do_3;
Counter_M10 Counter_M10_3(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (co_2),
    .clr   (1'b0),
    .data  (temp_3),
    .co    (co_3),
	.di    (do_2),
	.d0    (do_3)
);
wire co_4;
wire do_4;
Counter_M10 Counter_M10_4(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (co_3 || Freq_Lplus),
    .clr   (1'b0),
    .data  (temp_4),
    .co    (co_4),
	.di    (do_3 || Freq_Lmin),
	.d0    (do_4)
);
wire co_5;
wire do_5;
Counter_M10 Counter_M10_5(
    .clk   (clk),
    .rst_n (rst_n),
    .en    (co_4),
    .clr   (1'b0),
    .data  (temp_5),
    .co    (co_5),
	.di    (do_4),
	.d0    (do_5)
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
		Freq_plus <= 1'b0;
		Freq_min <= 1'b0;
	end
	else
	begin
		case(key)
		4'b1110:
		begin
			Freq_plus <= 1'b1;
		end
		4'b1101:
		begin
			Freq_min <= 1'b1;
		end
		4'b1011:
		begin
			Freq_Lplus <= 1'b1;
		end
		4'b0111:
		begin
			Freq_Lmin <= 1'b1;
		end
		default:
		begin
			Freq_plus <= 1'b0;
			Freq_min <= 1'b0;
			Freq_Lplus <= 1'b0;
			Freq_Lmin <= 1'b0;
		end
		endcase
	end
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:52:59 06/12/2019 
// Design Name: 
// Module Name:    Generator 
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
module Generator
(
	input        clk,
	input        rst_n,
	input[23:0]  Freq,
	output reg   Square
);
localparam[31:0] FOSC_HALF = 32'd25000000;
reg[31:0]        timer;
wire[31:0] Freq_d = Freq[3:0]
				  + Freq[7:4] * 32'd10
				  + Freq[11:8] * 32'd100
				  + Freq[15:12] * 32'd1000
				  + Freq[19:16] * 32'd10000
				  + Freq[23:20] * 32'd100000;
wire[31:0] Counter = FOSC_HALF / Freq_d - 1;
always@(posedge clk)
begin
	if(timer >= Counter)
	begin
		timer <= 32'b0;
		Square <= !Square;
	end
	else
	begin
		timer <= timer + 32'b1;
		Square <= Square;
	end
end
endmodule

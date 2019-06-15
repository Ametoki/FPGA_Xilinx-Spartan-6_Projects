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
	input[31:0]  Freq,
	output reg   Square
//	output[31:0] Counter
);
//localparam[31:0] FOSC_HALF = 32'd25000000;
reg[31:0]        timer;
wire[31:0]       Counter = 25_000_000 / Freq - 1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		timer <= 32'b0;
		Square <= 1'b0;
	end
	else if(timer == Counter)
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

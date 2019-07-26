`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:23:40 06/09/2019 
// Design Name: 
// Module Name:    SEG_Decoder 
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
module SEG_Decoder
(
	input[3:0]      bin_data,
	output reg[7:0] seg_data
);

always@(*)
begin
	case(bin_data)
		4'd0:seg_data <= 8'b1100_0000;
		4'd1:seg_data <= 8'b1111_1001;
		4'd2:seg_data <= 8'b1010_0100;
		4'd3:seg_data <= 8'b1011_0000;
		4'd4:seg_data <= 8'b1001_1001;
		4'd5:seg_data <= 8'b1001_0010;
		4'd6:seg_data <= 8'b1000_0010;
		4'd7:seg_data <= 8'b1111_1000;
		4'd8:seg_data <= 8'b1000_0000;
		4'd9:seg_data <= 8'b1001_0000;
		4'ha:seg_data <= 8'b1000_1000;
		4'hb:seg_data <= 8'b1000_0011;
		4'hc:seg_data <= 8'b1100_0110;
		4'hd:seg_data <= 8'b1010_0001;
		4'he:seg_data <= 8'b1000_0110;
		4'hf:seg_data <= 8'b1000_1110;
		default:seg_data <= 8'b1111_1111;
	endcase
end

endmodule

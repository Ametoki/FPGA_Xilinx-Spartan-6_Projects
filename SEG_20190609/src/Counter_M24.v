`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:45 06/09/2019 
// Design Name: 
// Module Name:    Counter_M24 
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
module Counter_M24(
	input          clk,
	input          rst_n,
	input          en,
	input          clr,
	output reg[3:0]data_0,
	output reg[3:0]data_1,
	output reg     co
    );

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		data_0 <= 4'd0;
		data_1 <= 4'd0;
		co <= 1'd0;
	end
	else if(en)
	begin
		if(data_1 == 4'd2 && data_0 == 4'd3)
		begin
			co <= 1'b1;
			data_0 <= 4'd0;
			data_1 <= 4'd0;
		end
		else
		begin
			co <= 1'b0;
			if(data_0 == 9)
			begin
				data_0 <= 4'd0;
				data_1 <= data_1 + 4'd1;
			end
			else
			begin
				data_0 <= data_0 + 4'd1;
			end
		end
	end
	else
		co <= 1'b0;
end

endmodule

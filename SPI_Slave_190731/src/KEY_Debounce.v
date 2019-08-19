`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:31 06/10/2019 
// Design Name: 
// Module Name:    KEY_Debounce 
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
module KEY_Debounce(
	input      clk,
	input      rst,
	input      button_in,
	output reg button_negedge
    );
parameter N = 20;
parameter FREQ = 50;
parameter MAX_TIME = 20;
localparam TIMER_MAX_VAL = MAX_TIME * 1000 * FREQ;
reg button_out;
reg[N-1:0] q_reg;
reg[N:0] q_next;
reg DFF1, DFF2;
wire q_add;
wire q_reset;
reg button_out_d0;

assign q_reset = (DFF1 ^ DFF2);
assign q_add = ~(q_reg == TIMER_MAX_VAL);

always@(q_reset, q_add, q_reg)
begin
	case({q_reset, q_add})
		2'b00:
			q_next <= q_reg;
		2'b01:
			q_next <= q_reg + 1;
		default:
			q_next <= {N{1'b0}};
	endcase
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		DFF1 <= 1'b0;
		DFF2 <= 1'b0;
		q_reg <= {N{1'b0}};
	end
	else
	begin
		DFF1 <= button_in;
		DFF2 <= DFF1;
		q_reg <= q_next[N-1:0];
	end
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		button_out <= 1'b1;
	else if(q_reg == TIMER_MAX_VAL)
		button_out <= DFF2;
	else
		button_out <= button_out;
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		button_out_d0 <= 1'b1;
		button_negedge <= 1'b0;
	end
	else
	begin
		button_out_d0 <= button_out;
		button_negedge <= button_out_d0 & ~button_out;
	end
end
endmodule

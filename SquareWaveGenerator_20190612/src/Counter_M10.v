`timescale 1ns / 1ps
module Counter_M10
(
    input          clk,
    input          rst_n,
    input          en,
    input          clr,
	input          di,
    output reg[3:0]data,
    output reg     co,
	output reg     d0
);
always@(posedge clk or negedge rst_n) 
begin
    if(rst_n==0)
    begin
        data <= 4'd0;
        co <= 1'd0;
		d0 <= 1'b0;
    end
    else if(clr)
    begin
        co <= 1'd0;
		d0 <= 1'b0;
		data <= 4'd0;
    end
    else if(en)
    begin
		if(data==4'd9)
		begin
			co <= 1'b1;
			d0 <= 1'b0;
			data <= 4'd0;
		end
		else
		begin
			co <= 1'b0;
			d0 <= 1'b0;
			data <= data + 4'd1;
		end
	end
	else if(di)
	begin
		if(data == 4'd0)
		begin
			co <= 1'b0;
			d0 <= 1'b1;
			data <= 4'd9;
		end
		else
		begin
			co <= 1'b0;
			d0 <= 1'b0;
			data <= data - 4'd1;
		end
	end
    else
	begin
        co <= 1'b0;
		d0 <= 1'b0;
	end
end

endmodule 
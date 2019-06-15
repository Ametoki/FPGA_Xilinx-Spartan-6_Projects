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
);
//localparam[31:0] FOSC_HALF = 32'd25000000;
reg[31:0]        timer;
reg[31:0]        Counter;
always@(Freq)
begin
	case(Freq)
	32'd0:Counter <= 49999999;
	32'd1:Counter <= 24999999;
	32'd2:Counter <= 12499999;
	32'd3:Counter <= 8333332;
	32'd4:Counter <= 6249999;
	32'd5:Counter <= 4999999;
	32'd6:Counter <= 4166666;
	32'd7:Counter <= 3571428;
	32'd8:Counter <= 3124999;
	32'd9:Counter <= 2777777;
	/*
	32'd10:Counter <= 2499999;
	32'd11:Counter <= 2272726;
	32'd12:Counter <= 2083332;
	32'd13:Counter <= 1923076;
	32'd14:Counter <= 1785713;
	32'd15:Counter <= 1666666;
	32'd16:Counter <= 1562499;
	32'd17:Counter <= 1470587;
	32'd18:Counter <= 1388888;
	32'd19:Counter <= 1315788;
	32'd20:Counter <= 1249999;
	32'd21:Counter <= 1190475;
	32'd22:Counter <= 1136363;
	32'd23:Counter <= 1086956;
	32'd24:Counter <= 1041666;
	32'd25:Counter <= 999999;
	32'd26:Counter <= 961537;
	32'd27:Counter <= 925925;
	32'd28:Counter <= 892856;
	32'd29:Counter <= 862068;
	32'd30:Counter <= 833332;
	32'd31:Counter <= 806451;
	32'd32:Counter <= 781249;
	32'd33:Counter <= 757575;
	32'd34:Counter <= 735293;
	32'd35:Counter <= 714285;
	32'd36:Counter <= 694443;
	32'd37:Counter <= 675675;
	32'd38:Counter <= 657894;
	32'd39:Counter <= 641025;
	32'd40:Counter <= 624999;
	32'd41:Counter <= 609755;
	32'd42:Counter <= 595237;
	32'd43:Counter <= 581394;
	32'd44:Counter <= 568181;
	32'd45:Counter <= 555555;
	32'd46:Counter <= 543477;
	32'd47:Counter <= 531914;
	32'd48:Counter <= 520832;
	32'd49:Counter <= 510203;
	32'd50:Counter <= 499999;
	32'd51:Counter <= 490195;
	32'd52:Counter <= 480768;
	32'd53:Counter <= 471697;
	32'd54:Counter <= 462962;
	32'd55:Counter <= 454544;
	32'd56:Counter <= 446428;
	32'd57:Counter <= 438595;
	32'd58:Counter <= 431033;
	32'd59:Counter <= 423728;
	32'd60:Counter <= 416666;
	32'd61:Counter <= 409835;
	32'd62:Counter <= 403225;
	32'd63:Counter <= 396824;
	32'd64:Counter <= 390624;
	32'd65:Counter <= 384614;
	32'd66:Counter <= 378787;
	32'd67:Counter <= 373133;
	32'd68:Counter <= 367646;
	32'd69:Counter <= 362318;
	32'd70:Counter <= 357142;
	32'd71:Counter <= 352112;
	32'd72:Counter <= 347221;
	32'd73:Counter <= 342465;
	32'd74:Counter <= 337837;
	32'd75:Counter <= 333332;
	32'd76:Counter <= 328946;
	32'd77:Counter <= 324674;
	32'd78:Counter <= 320512;
	32'd79:Counter <= 316455;
	32'd80:Counter <= 312499;
	32'd81:Counter <= 308641;
	32'd82:Counter <= 304877;
	32'd83:Counter <= 301204;
	32'd84:Counter <= 297618;
	32'd85:Counter <= 294117;
	32'd86:Counter <= 290697;
	32'd87:Counter <= 287355;
	32'd88:Counter <= 284090;
	32'd89:Counter <= 280898;
	32'd90:Counter <= 277777;
	32'd91:Counter <= 274724;
	32'd92:Counter <= 271738;
	32'd93:Counter <= 268816;
	32'd94:Counter <= 265956;
	32'd95:Counter <= 263157;
	32'd96:Counter <= 260416;
	32'd97:Counter <= 257731;
	32'd98:Counter <= 255101;
	32'd99:Counter <= 252524;
	32'd100:Counter <= 249999;
	*/
	default:Counter <= 49999999;
	endcase
end
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

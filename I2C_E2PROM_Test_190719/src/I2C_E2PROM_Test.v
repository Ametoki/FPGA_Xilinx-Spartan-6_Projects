`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:38 07/19/2019 
// Design Name: 
// Module Name:    I2C_E2PROM_Test 
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
module I2C_E2PROM_Test
(
	input       clk,
	input       rst_n,
	input       key1,
	inout       i2c_sda,
	inout       i2c_scl,
	output[5:0] seg_sel,
	output[7:0] seg_data
);

localparam S_IDLE    = 0;
localparam S_READ    = 1;
localparam S_WAIT    = 2;
localparam S_WRITE   = 3;

reg[3:0]   state;
wire       button_negedge;
reg[7:0]   read_data;
reg[31:0]  timer;
wire       scl_pad_i;
wire       scl_pad_o;
wire       scl_padoen_o;
wire       sda_pad_i;
wire       sda_pad_o;
wire       sda_padoen_o;

reg[7:0]   i2c_slave_dev_addr;
reg[15:0]  i2c_slave_reg_addr;
reg[7:0]   i2c_write_data;
reg        i2c_read_req;
wire       i2c_read_req_ack;
reg        i2c_write_req;
wire       i2c_write_req_ack;
wire[7:0]  i2c_read_data;

KEY_Debounce KEY_Debounce_U0
(
	.clk            (clk),
	.rst            (~rst_n),
	.button_in      (key1),
	.button_negedge (),
	.button_posedge (button_negedge),
	.button_out     ()
);
wire[7:0] seg_data_0;
SEG_Decoder SEG_Decoder_U0
(
	.bin_data   (read_data[3:0]),
	.seg_data   (seg_data_0)
);
wire[7:0] seg_data_1;
SEG_Decoder SEG_Decoder_U1
(
	.bin_data   (read_data[7:4]),
	.seg_data   (seg_data_1)
);
SEG_Scan SEG_Scan_U0
(
	.clk        (clk),
    .rst_n      (rst_n),
    .seg_sel    (seg_sel),
    .seg_data   (seg_data),
    .seg_data_0 (8'hff),
    .seg_data_1 (8'hff),
    .seg_data_2 (8'hff),
    .seg_data_3 (8'hff),
    .seg_data_4 (seg_data_1),
    .seg_data_5 (seg_data_0)
);
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		state <= S_IDLE;
		i2c_write_req <= 1'b0;
		read_data <= 8'h00;
		timer <= 32'd0;
		i2c_write_data <= 8'd0;
		i2c_slave_reg_addr <= 16'd0;
		i2c_slave_dev_addr <= 8'ha0;
		i2c_read_req <= 1'b0;
	end
	else
		case(state)
			S_IDLE:
			begin
				if(timer >= 32'd12_499_999)//250ms
					state <= S_READ;
				else
					timer <= timer + 32'd1;
			end
			S_READ:
			begin
				if(i2c_read_req_ack)//no ack
				begin
					i2c_read_req <= 1'b0;//*
					read_data <= i2c_read_data;
					state <= S_WAIT;
				end
				else
				begin
					i2c_read_req <= 1'b1;
					i2c_slave_dev_addr <= 8'ha0;
					i2c_slave_reg_addr <= 16'd0;
				end
			end
			S_WAIT:
            begin
                if(button_negedge)
                begin
                    state <= S_WRITE;
                    read_data <= read_data + 8'd1;
                end
            end
			S_WRITE:
            begin
                if(i2c_write_req_ack)
                begin
                    i2c_write_req <= 1'b0;
                    state <= S_READ;
                end
                else
                begin
                    i2c_write_req <= 1'b1;
                    i2c_write_data <= read_data;
                end
            end
			default:
				state <= S_IDLE;
		endcase
end

assign sda_pad_i = i2c_sda;
assign i2c_sda = ~sda_padoen_o ? sda_pad_o : 1'bz;
assign scl_pad_i = i2c_scl;
assign i2c_scl = ~scl_padoen_o ? scl_pad_o : 1'bz;

i2c_master_top i2c_master_top_m0
(
    .rst(~rst_n),
    .clk(clk),
    .clk_div_cnt(16'd99),       //Standard mode:100Khz
    
    // I2C signals 
    // i2c clock line
    .scl_pad_i(scl_pad_i),            // SCL-line input
    .scl_pad_o(scl_pad_o),            // SCL-line output (always 1'b0)
    .scl_padoen_o(scl_padoen_o),      // SCL-line output enable (active low)

    // i2c data line
    .sda_pad_i(sda_pad_i),           // SDA-line input
    .sda_pad_o(sda_pad_o),           // SDA-line output (always 1'b0)
    .sda_padoen_o(sda_padoen_o),     // SDA-line output enable (active low)
    
    
    .i2c_addr_2byte(1'b0),
    .i2c_read_req(i2c_read_req),
    .i2c_read_req_ack(i2c_read_req_ack),
    .i2c_write_req(i2c_write_req),
    .i2c_write_req_ack(i2c_write_req_ack),
    .i2c_slave_dev_addr(i2c_slave_dev_addr),
    .i2c_slave_reg_addr(i2c_slave_reg_addr),
    .i2c_write_data(i2c_write_data),
    .i2c_read_data(i2c_read_data),
    .error()
);

endmodule

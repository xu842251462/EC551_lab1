`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2022 06:32:34 PM
// Design Name: 
// Module Name: seg_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define SEG7_0 8'b0000001
`define SEG7_1 8'b1001111
`define SEG7_2 8'b0010010
`define SEG7_3 8'b0000110
`define SEG7_4 8'b1001100
`define SEG7_5 8'b0100100
`define SEG7_6 8'b0100000
`define SEG7_7 8'b0001111
`define SEG7_8 8'b0000000
`define SEG7_9 8'b0000100

module seg_display(
    input  wire [11:0] num,

	output reg  [ 7:0] led_on,
	output reg  [ 3:0] digit_select,

	input  wire        clk,
	input  wire        rst
);
	reg  [ 1:0] place_ctr;
	wire [ 3:0] place[3:0];
	reg  [16:0] clk_div;
	wire        clk_slow;
	
	assign clk_slow = clk_div[16];

	always @(*) begin
		case(place_ctr)
			0: digit_select = 4'b0111;
			1: digit_select = 4'b1011;
			2: digit_select = 4'b1101;
			3: digit_select = 4'b1110;
		endcase
	end

	assign place[0] = (num % 10000) / 1000;
	assign place[1] = (num % 1000 ) / 100;
	assign place[2] = (num % 100  ) / 10;
	assign place[3] = (num % 10   );

	
	always @(*) begin
		case (place[place_ctr])
			0: led_on <= `SEG7_0;
			1: led_on <= `SEG7_1;
			2: led_on <= `SEG7_2;
			3: led_on <= `SEG7_3;
			4: led_on <= `SEG7_4;
			5: led_on <= `SEG7_5;
			6: led_on <= `SEG7_6;
			7: led_on <= `SEG7_7;
			8: led_on <= `SEG7_8;
			9: led_on <= `SEG7_9;
			default: led_on <= -1;
		endcase
	end
	
	always @(posedge clk) begin
		clk_div <= clk_div + 1;
	end

	always @(posedge clk_slow) begin
		if (rst) begin
			place_ctr <= 0;
		end else begin
			place_ctr <= place_ctr + 1;
		end
	end
endmodule


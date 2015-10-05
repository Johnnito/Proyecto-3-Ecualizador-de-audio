`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:58 09/24/2015 
// Design Name: 
// Module Name:    pwm 
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
module pwm(data_in, clk, reset, data_out, ready);
	parameter N=25;
	input [N-1:0]data_in;
	input clk, reset, ready;
	output reg data_out;
	reg [N-1:0] comp_clk, data_offset;
	initial
	begin
		data_out<=1'b0;
		comp_clk<=24'b0;
	end
	always @(posedge clk)
	begin 
		if (reset == 1) comp_clk=20'b0;
		else if (reset == 0 & comp_clk<20'hFFFFF) comp_clk<=comp_clk+1;
		else if(reset == 0 & comp_clk<20'hFFFFFF) comp_clk<=20'b0;
		if (data_in[19:0]<comp_clk) assign data_out = 0;
		else assign data_out = 1;
	end
endmodule

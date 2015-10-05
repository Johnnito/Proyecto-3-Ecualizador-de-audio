`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:18:06 09/27/2015
// Design Name:   Datos_ADC
// Module Name:   C:/Users/USUARIO1/Desktop/Proyecto3/TestBenchADC.v
// Project Name:  Proyecto3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Datos_ADC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchADC;
// Inputs
	reg clk_nexys;
	reg reset;
	reg sdata;

	// Outputs
	wire listo;
	wire SCLK;
	wire CS;
	wire [15:0] d_out;

	// Instantiate the Unit Under Test (UUT)
	Datos_ADC uut (
		.clk(clk_nexys), 
		.reset(reset), 
		.sdata(sdata), 
		.listo(listo), 
		.SCLK(SCLK), 
		.CS(CS), 
		.d_out(d_out)	
	);
	initial begin
		// Initialize Inputs
	clk_nexys = 0;
	reset = 0;
	sdata = 0;
	end
	integer i,j;
	reg [15:0] data_txt;
	reg [15:0] Memoria [0:15];
		initial begin
			// Initialize Inputs
			reset = 1;
			sdata = 0;
			clk_nexys = 0;
			$readmemb("test1.txt",Memoria);
			repeat(5) @(posedge clk_nexys) reset=0;
		end
		initial begin
			@(negedge reset, negedge CS)
			for(j=0;j<16;j=j+1)
				begin
					data_txt=Memoria[j];
					for (i=0;i<16;i=i+1)
						begin
							@(negedge SCLK)
								sdata=data_txt[15-i];
						end
						sdata<=1;
				end
				
		end
		initial forever begin
			#10 clk_nexys = ~ clk_nexys;
		end
endmodule


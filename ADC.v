`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:48:57 09/24/2015 
// Design Name: 
// Module Name:    ADC 
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
module ADC(
		input sdata, cs, sclk, reset,//Pines del ADC
		output [15:0] d_out,//Dato para enviar al filtro
		output reg listo);
					reg [4:0] contador; //Para ir revisando el sclk, son necesarios 16 conteos
					reg [15:0] dato_dig; //Ir guardando el dato conforme vaya avanzando el contador
					reg [15:0]dato_temp; //Para asignar al dato de salida, se le agregan los 4 bits de signo

		parameter [1:0] negedgeCS=2'b0, conteo=2'b1, posedgeCS=2'b11;
		reg [1:0] estado, sigestado;
		initial 
			begin
				contador <= 5'b0;
				dato_dig <= 16'b0;
				dato_temp <= 16'b0;
				listo <= 1'b0;
			end
	always @(negedge sclk, posedge reset)
		begin
			if (reset)begin
				estado<=negedgeCS;
				contador<=5'b0;
				listo <=1'b0;
				dato_dig <= 16'b0;
				dato_temp <= 16'b0;
			end
			else begin
				d_out = d_out;
				listo = listo;	
				estado = sigestado;	
				case(estado)
					conteo: if (contador<5'b10000)begin
						contador <= contador + 5'b1;
						dato_dig <= {dato_dig[14:0], sdata};
						listo <= 1'b0;
						end
					else if (contador == 5'b10000)begin
						dato_temp <= dato_dig[15:0] + 16'b1111100000000000;
						listo <= 1'b1;
					end
				endcase
			end
		end
	always @(*)
		begin
			case(estado)
				negedgeCS: if (CS==0) estado<=conteo;
				conteo: if (contador<5'b10000) estado<=conteo;
					else if (contador==5'b10000) begin
						contador<=5'b0;
						estado<=posedgeCS;
					end
				posedgeCS: if (CS==0) estado<=posedgeCS;
					else if (CS==1) estado<=negedgeCS;
			endcase
		end
	assign d_out = dato_temp;
endmodule

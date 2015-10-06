`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:52 09/26/2015 
// Design Name: 
// Module Name:    ADC_Protocolo 
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
module ADC_Protocolo(input sdata, CS, sclk, reset,//Pines del ADC
		output [15:0] d_out,//Dato para enviar al filtro
		output reg listo);
					reg [3:0] contador; //Para ir revisando el sclk, son necesarios 16 conteos
					reg [15:0] dato_dig; //Ir guardando el dato conforme vaya avanzando el contador
					reg [15:0]dato_temp; //Para asignar al dato de salida, se le agregan los 4 bits de signo

		parameter [1:0] negedgeCS=2'b0, conteo=2'b1, posedgeCS=2'b11;
		reg [1:0] estado, sigestado;
		initial 
			begin
				contador <= 4'b0;
				dato_dig <= 16'b0;
				dato_temp <= 16'b0;
				listo <= 1'b0;
			end
	always @(negedge sclk, posedge reset)
		begin
			if (reset)begin
				estado<=negedgeCS;
				contador<=4'b0;
				dato_dig <= 16'b0;
			end
			else begin
				listo <= listo;	
				estado <= sigestado;	
				case(estado)
					posedgeCS: contador <= 4'b0;
					conteo: if ((contador>3)||(contador<4'b1111))begin
						contador <= contador + 4'b1;
						dato_dig <= {dato_dig[14:0], sdata};
						listo <= 1'b0;
						end
						else if (contador<3) contador <= contador + 4'b1;
						else if (contador == 4'b1111)begin
							dato_dig <= dato_dig[15:0] /*16'b1111100000000000*/;
							listo <= 1'b1;
						end
					negedgeCS:begin
						listo <= 1'b1;
						dato_temp <= dato_dig;
					end
				endcase
			end
		end
	always @(*)
		begin
			case(estado)
				negedgeCS: if (CS==0) sigestado=conteo;
					else sigestado=negedgeCS;
				conteo: if (contador<4'b1111) sigestado=conteo;
					else sigestado=posedgeCS;
				posedgeCS: if (CS==0) sigestado=posedgeCS;
					else sigestado=negedgeCS;
				default sigestado=negedgeCS;
			endcase
		end
	assign d_out = {1'b0,dato_temp[15:1]};
endmodule


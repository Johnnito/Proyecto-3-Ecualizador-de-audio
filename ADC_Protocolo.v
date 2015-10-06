`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:33 10/01/2015 
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
module ADC_Protocolo(input wire SDATA, reset ,CS,SCLK,
							output reg rx_done_tick, 
							/*output reg [15:0] b_reg,*/
							output wire [11:0]data_Out
    );

	localparam [1:0]
		DetectaCS = 2'b00,
		Recibir = 2'b01,		//Estados de la máquina
		Carga = 2'b10;

		//Declaración de Señales

	reg[1:0] state_reg , state_next; // cambiar estado
	reg [3:0] n_reg, n_next; /// Para llevar cuenta de datos recibidos
	reg [15:0] b_next, b_reg;

	/////Partes secuencial
	always @(posedge reset,  negedge SCLK)
		if (reset)
			begin
				state_reg <= DetectaCS;
				n_reg <= 4'd0;
				b_reg <= 16'd0;
			end
		else
			begin 
				state_reg <= state_next;
				n_reg <= n_next;
				b_reg <= b_next;
			end

	///Parte combinacional

	always @*
	 begin
		state_next =state_reg;
		rx_done_tick = 1'b0;
		n_next = n_reg;
		b_next = b_reg;


		case(state_reg)

			DetectaCS :
				if(~CS)
					begin
					state_next = Recibir;
					n_next = 4'd0;

					b_next={b_reg[14:0],SDATA};
					end

				else state_next = DetectaCS;


			Recibir :
				begin
					b_next = {b_reg [14:0], SDATA}; /// se llena registro desplazamiento
					if(n_reg == 4'd14)
						state_next = Carga;
					else 
						n_next = n_reg + 4'd1;
				end

			Carga : 
					if(CS)
						begin
							state_next= DetectaCS;
							rx_done_tick = 1'b1;
						end
					else 
						state_next = Carga;
						

			default  			 		
					state_next = DetectaCS;
		endcase
		
	end
		

	assign data_Out = b_reg [11:0];

endmodule
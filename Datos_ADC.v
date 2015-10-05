`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:38 09/26/2015 
// Design Name: 
// Module Name:    Recepcion_Datos 
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
module Datos_ADC(
 input clk, reset, sdata,
 output listo, SCLK, CS,
 output [15:0] d_out
    );

// Instantiate the module
ADC_Protocolo Adc_protocolo (
    .sdata(sdata), 
    .CS(CS), 
    .sclk(SCLK), 
    .reset(reset), 
    .d_out(d_out), 
    .listo(listo)
    );

// Instantiate the module
Temporizador_32fm Sclk (
    .clk(clk), 
    .reset(reset), 
    .s_clk(SCLK)
    );
// Instantiate the module
Temporizador_fm C_S (
    .clk(clk), 
    .reset(reset), 
    .s_clk(CS)
    );


endmodule

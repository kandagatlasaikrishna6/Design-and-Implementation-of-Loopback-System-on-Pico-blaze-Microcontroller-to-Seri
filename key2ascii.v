`timescale 1ns / 1ps


module key2ascii (
  input [7:0] key_code,
  output [7:0] ascii_code);
  
  case(key_code)
                8'h00: ascii_code <= 8'b00110000;
				8'h01: ascii_code <= 8'b00110001;
				8'h02: ascii_code <= 8'b00110010;
				8'h03: ascii_code <= 8'b00110011;
				8'h04: ascii_code <= 8'b00110100;
				8'h05: ascii_code <= 8'b00110101;
				8'h06: ascii_code <= 8'b00110110;
				8'h07: ascii_code <= 8'b00110111;
				8'h08: ascii_code <= 8'b00111000;
				8'h09: ascii_code <= 8'b00111001;
				8'h10: ascii_code <= 8'b01000001;
				8'h11: ascii_code <= 8'b01000010;
				8'h12: ascii_code <= 8'b01000011;
				8'h13: ascii_code <= 8'b01000100;
				8'h14: ascii_code <= 8'b01000101;
				8'h15: ascii_code <= 8'b01000110;
				default: ascii_code <= 8'b00101010;
				
endmodule
			    
`timescale 1ns / 1ps

module top_level 
( 
    input		reset,		
	input		clk,		
	output	    tx,
	output	[7:0]	leds,
	output		PMODBT_CTS,
	output 	PMODBT_RTS
  );

 
    wire	[7:0]	w_data;
	wire	[7:0]	serialout;
	wire	[7:0]	ascii_code;
	wire	[7:0]	key_code;
	wire			kb_not_empty;
	wire	[7:0]	leds_next;
	wire			buffer_half_full;
	wire			buffer_full;
   
begin

assign PMODBT_CTS = 1'b0;
assign PMODBT_RST = 1'b1;
assign en_16_x_baud = 1'b1;

 loopback loopback_t(  
   .swithces(switches),
 	.leds(leds),
   .rs232_rx(rs232_rx), 
	.rs232_tx(rs232_tx), 
	.reset(reset), 
	.clk(clk)
  );


uart_tx6 uart_t(
     .datain(datain), .buffer_write(kb_not_empty), .buffer_reset(buffer_reset),
     .en_16_x_baud(en_16_x_baud), .serialout(serialout),
    .buffer_data_present(ascii_code), .buffer_half_full(buffer_half_full),
    .buffer_half_full(buffer_full),  .clk(clk)
  );
key2ascii key(
  .key_code(key_code), .ascii_code(ascii_code)
   );

 always @(posedge clk or posedge reset)
	begin
    if (reset) begin
      leds <= "00000000";
	  end
    else begin 
      leds <= leds_next;
    end 
  end 
  leds_next <= serialout;
endmodule;

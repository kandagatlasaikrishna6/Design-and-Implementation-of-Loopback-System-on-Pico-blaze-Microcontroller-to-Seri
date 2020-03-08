`timescale 1ns / 1ps

module loopback_testBench;

	// Inputs
	reg [7:0] switches;
	reg rs232_rx;
	reg reset;
	reg clk;

	// Outputs
	wire [7:0] leds;
	wire rs232_tx;

	// Instantiate the Unit Under Test (UUT)
	loopback uut (
		.switches(switches), 
		.leds(leds), 
		.rs232_tx(rs232_tx), 
		.rs232_rx(rs232_rx), 
		.reset(reset), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		switches = 0;
		rs232_rx = 0;
		reset = 0;
		clk = 0;
           end
initial
    begin
      #100;
      $display ("Simulation ended by SK");
      $finish;
    end

	
      
endmodule


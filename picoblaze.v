`timescale 1ns / 1ps
module picoblaze(
	port_id,
	read_strobe, in_port,
	write_strobe, out_port,
	interrupt, interrupt_ack,
	reset, clk
    );
	 
	 // Port Specifier
	 output	[7:0]	port_id;
	 
	 // Input port & acknowledge strobe
	 output			read_strobe;
	 input	[7:0]	in_port;
	 
	 // Output port & ready strobe
	 output			write_strobe;
	 output	[7:0]	out_port;
	 
	 // Interrupt input & acknowledge
	 input			interrupt;
	 output			interrupt_ack;
	 
	 
	 // global reset and clock
	 input reset;
	 input clk;
	 
	 // Reset Handling Logic
	 wire cpu_reset;
	 assign cpu_reset = reset;
	 
	 wire pb_sleep;
	 assign  pb_sleep = 1'b0;
	 
	 wire		[7:0]	address;
	 wire		[7:0]	instruction;
	 wire				bram_enable;

	kcpsm6 pblaze_cpu (
		.address(address),
		.instruction(instruction),
		.bram_enable(bram_enable),
		.port_id(port_id),
		.write_strobe(write_strobe),
		.k_write_strobe(),
		.out_port(out_port),
		.read_strobe(read_strobe),
		.in_port(in_port),
		.interrupt(interrupt),
		.interrupt_ack(interrupt_ack),
		.reset(cpu_reset),
		.sleep(pb_sleep),
		.clk(clk)
	);
	
	program pblaze_rom (
		.enable(bram_enable),
		.address(address),
		.instruction(instruction),
		.clk(clk)
	);

endmodule

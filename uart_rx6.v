//
`timescale 1 ps / 1ps

module uart_rx6 (
input        serial_in,
input        en_16_x_baud,
output [7:0] data_out,
input        buffer_read,
output       buffer_data_present,
output       buffer_half_full,
output       buffer_full,
input        buffer_reset,
input        clk );
//
wire [3:0] pointer_value;
wire [3:0] pointer;
wire       en_pointer;
wire       zero;
wire       full_int;
wire       data_present_value;
wire       data_present_int;
wire       sample_value;
wire       sample;
wire       sample_dly_value;
wire       sample_dly;
wire       stop_bit_value;
wire       stop_bit;
wire [7:0] data_value;
wire [7:0] data;
wire       run_value;
wire       run;
wire       start_bit_value;
wire       start_bit;
wire [3:0] div_value;
wire [3:0] div;
wire       div_carry;
wire       sample_input_value;
wire       sample_input;
wire       buffer_write_value;
wire       buffer_write;     
genvar i;

// SRL16E data storage

generate
for (i = 0 ; i <= 7 ; i = i+1)
begin : data_width_loop

(* HBLKNM = "uart_rx6_5" *)
SRL16E #(
        .INIT   (16'h0000))
storage_srl (   
        .D      (data[i]),
        .CE     (buffer_write),
        .CLK    (clk),
        .A0     (pointer[0]),
        .A1     (pointer[1]),
        .A2     (pointer[2]),
        .A3     (pointer[3]),
        .Q      (data_out[i]));

end //generate data_width_loop;
endgenerate

(* HBLKNM = "uart_rx6_1" *)
LUT6 #(
        .INIT    (64'hFF00FE00FF80FF00))
pointer3_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (pointer[2]),
        .I3     (pointer[3]),
        .I4     (buffer_write),
        .I5     (buffer_read),
        .O      (pointer_value[3]));                      

(* HBLKNM = "uart_rx6_1" *)
FDR pointer3_flop(  
        .D      (pointer_value[3]),
        .Q      (pointer[3]),
        .R      (buffer_reset),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_1" *)
LUT6 #(
        .INIT    (64'hF0F0E1E0F878F0F0))
pointer2_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (pointer[2]),
        .I3     (pointer[3]),
        .I4     (buffer_write),
        .I5     (buffer_read),
        .O      (pointer_value[2])); 
        
(* HBLKNM = "uart_rx6_1" *)
FDR pointer2_flop(  
        .D      (pointer_value[2]),
        .Q      (pointer[2]),
        .R      (buffer_reset),
        .C      (clk));

(* HBLKNM = "uart_rx6_1" *)
LUT6_2 #(
        .INIT    (64'hCC9060CCAA5050AA))
pointer01_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (en_pointer),
        .I3     (buffer_write),
        .I4     (buffer_read),
        .I5     (1'b1),
        .O5     (pointer_value[0]),
        .O6     (pointer_value[1])); 
        
(* HBLKNM = "uart_rx6_1" *)
FDR pointer1_flop(  
        .D      (pointer_value[1]),
        .Q      (pointer[1]),
        .R      (buffer_reset),
        .C      (clk));

(* HBLKNM = "uart_rx6_1" *)
FDR pointer0_flop(  
        .D      (pointer_value[0]),
        .Q      (pointer[0]),
        .R      (buffer_reset),
        .C      (clk));

(* HBLKNM = "uart_rx6_1" *)
LUT6_2 #(
        .INIT    (64'hF4FCF4FC040004C0))
data_present_lut( 
        .I0     (zero),
        .I1     (data_present_int),
        .I2     (buffer_write),
        .I3     (buffer_read),
        .I4     (full_int),
        .I5     (1'b1),
        .O5     (en_pointer),
        .O6     (data_present_value)); 
        
(* HBLKNM = "uart_rx6_1" *)
FDR data_present_flop(  
        .D      (data_present_value),
        .Q      (data_present_int),
        .R      (buffer_reset),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h0001000080000000))
full_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (pointer[2]),
        .I3     (pointer[3]),
        .I4     (1'b1),
        .I5     (1'b1),
        .O5     (full_int),
        .O6     (zero)); 

(* HBLKNM = "uart_rx6_4" *)
LUT6_2 #(
        .INIT    (64'hCCF00000AACC0000))
sample_lut( 
        .I0     (serial_in),
        .I1     (sample),
        .I2     (sample_dly),
        .I3     (en_16_x_baud),
        .I4     (1'b1),
        .I5     (1'b1),
        .O5     (sample_value),
        .O6     (sample_dly_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD sample_flop(  
        .D      (sample_value),
        .Q      (sample),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_4" *)
FD sample_dly_flop(  
        .D      (sample_dly_value),
        .Q      (sample_dly),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_4" *)
LUT6_2 #(
        .INIT    (64'hCAFFCAFF0000C0C0))
stop_bit_lut( 
        .I0     (stop_bit),
        .I1     (sample),
        .I2     (sample_input),
        .I3     (run),
        .I4     (data[0]),
        .I5     (1'b1),
        .O5     (buffer_write_value),
        .O6     (stop_bit_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD buffer_write_flop(  
        .D      (buffer_write_value),
        .Q      (buffer_write),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_4" *)
FD stop_bit_flop(  
        .D      (stop_bit_value),
        .Q      (stop_bit),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data01_lut( 
        .I0     (data[0]),
        .I1     (data[1]),
        .I2     (data[2]),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[0]),
        .O6     (data_value[1])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data0_flop(  
        .D      (data_value[0]),
        .Q      (data[0]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data1_flop(  
        .D      (data_value[1]),
        .Q      (data[1]),
        .C      (clk)); 

(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data23_lut( 
        .I0     (data[2]),
        .I1     (data[3]),
        .I2     (data[4]),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[2]),
        .O6     (data_value[3])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data2_flop(  
        .D      (data_value[2]),
        .Q      (data[2]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data3_flop(  
        .D      (data_value[3]),
        .Q      (data[3]),
        .C      (clk)); 

(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data45_lut( 
        .I0     (data[4]),
        .I1     (data[5]),
        .I2     (data[6]),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[4]),
        .O6     (data_value[5])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data4_flop(  
        .D      (data_value[4]),
        .Q      (data[4]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data5_flop(  
        .D      (data_value[5]),
        .Q      (data[5]),
        .C      (clk)); 

(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data67_lut( 
        .I0     (data[6]),
        .I1     (data[7]),
        .I2     (stop_bit),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[6]),
        .O6     (data_value[7])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data6_flop(  
        .D      (data_value[6]),
        .Q      (data[6]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data7_flop(  
        .D      (data_value[7]),
        .Q      (data[7]),
        .C      (clk)); 
        
(* HBLKNM = "uart_rx6_4" *)
LUT6 #(
        .INIT    (64'h2F2FAFAF0000FF00))
run_lut( 
        .I0     (data[0]),
        .I1     (start_bit),
        .I2     (sample_input),
        .I3     (sample_dly),
        .I4     (sample),
        .I5     (run),
        .O      (run_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD run_flop(  
        .D      (run_value),
        .Q      (run),
        .C      (clk));  
        
(* HBLKNM = "uart_rx6_4" *)
LUT6 #(
        .INIT    (64'h222200F000000000))
start_bit_lut( 
        .I0     (start_bit),
        .I1     (sample_input),
        .I2     (sample_dly),
        .I3     (sample),
        .I4     (run),
        .I5     (1'b1),
        .O      (start_bit_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD start_bit_flop(  
        .D      (start_bit_value),
        .Q      (start_bit),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h6C0000005A000000))
div01_lut( 
        .I0     (div[0]),
        .I1     (div[1]),
        .I2     (en_16_x_baud),
        .I3     (run),
        .I4     (1'b1),
        .I5     (1'b1),
        .O5     (div_value[0]),
        .O6     (div_value[1])); 
        
(* HBLKNM = "uart_rx6_3" *)
FD div0_flop(  
        .D      (div_value[0]),
        .Q      (div[0]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
FD div1_flop(  
        .D      (div_value[1]),
        .Q      (div[1]),
        .C      (clk)); 
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h6CCC00005AAA0000))
div23_lut( 
        .I0     (div[2]),
        .I1     (div[3]),
        .I2     (div_carry),
        .I3     (en_16_x_baud),
        .I4     (run),
        .I5     (1'b1),
        .O5     (div_value[2]),
        .O6     (div_value[3])); 
        
(* HBLKNM = "uart_rx6_3" *)
FD div2_flop(  
        .D      (div_value[2]),
        .Q      (div[2]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
FD div3_flop(  
        .D      (div_value[3]),
        .Q      (div[3]),
        .C      (clk)); 
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h0080000088888888))
sample_input_lut( 
        .I0     (div[0]),
        .I1     (div[1]),
        .I2     (div[2]),
        .I3     (div[3]),
        .I4     (en_16_x_baud),
        .I5     (1'b1),
        .O5     (div_carry),
        .O6     (sample_input_value)); 
        
(* HBLKNM = "uart_rx6_3" *)
FD sample_input_flop(  
        .D      (sample_input_value),
        .Q      (sample_input),
        .C      (clk)); 
        
// assign internal wires to outputs

assign buffer_full = full_int;  
assign buffer_half_full = pointer[3];  
assign buffer_data_present = data_present_int;

endmodule





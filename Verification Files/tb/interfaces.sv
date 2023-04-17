interface dut_interface_in;
    logic           clk;
    logic clk_fast;
    logic start;
    logic           CIN;
    logic   [4:0]   opcode;
    logic   [31:0]  A, B;
endinterface: dut_interface_in


interface dut_interface_out;
  
	logic 	[31:0] 	OUT;
	logic 			VOUT;
	
    logic clk;
logic underflow;
	logic div_by_zero;
	logic zero_by_zero;

endinterface: dut_interface_out

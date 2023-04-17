module ksa_test;
	reg c0;
	reg [23:0] i_a;
	reg [23:0] i_b;
	wire [23:0] o_s;
	wire o_carry;

	initial begin
		i_a=24'h111111;
		i_b=24'h222222;
		c0=1'b0;
		#400
		i_a=24'hABABAB;
		i_b=24'hBCBCBC;
		c0=1'b0;
		#400
		i_a=24'h000000;
		i_b=24'h000000;
		c0=1'b0;
	end
	
	//always 
	//#20 clock = ~clock;

// serial output from SSP is looped back to the serial input.
	ksa_top ksa (.c0(c0), .i_a(i_a), .i_b(i_b), .o_s(o_s), .o_carry(o_carry));

endmodule

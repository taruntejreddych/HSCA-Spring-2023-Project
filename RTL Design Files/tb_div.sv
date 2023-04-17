
module Test_alu;
	parameter CLK_PERIOD = 2;  // 10 ns == 100 MHz
	// Inputs
    parameter WIDTH = 32;
    parameter MBITS = 23;
	reg [31:0] A;
	reg [31:0] B;
	reg Cin;
	reg [2:0] opcode; 
	// Outputs
	wire [31:0] Out;
	wire Cout;

	reg clk;
	reg clk_fast;
	reg start;
	reg busy, valid, dbz, zbz, ovf, unf;
 	reg leftshift;
	always #(CLK_PERIOD / 2) clk = ~clk;
	// Instantiate the Unit Under Test (UUT)
	FPalu uut (
		.A(A), 
		.B(B), 
		.Cin(Cin),
		.Out(Out),
		.opcode(opcode),
		.Cout(Cout),
		.unf(unf), .ovf(ovf), .zbz(zbz), .dbz(dbz), .clk(clk), .start(start), .busy(busy), .valid(valid), .clk_fast(clk_fast), .leftshift(leftshift)
	);



	initial begin
	                clk = 1;	// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;
		opcode = 0;
		//start = 1;
		// Wait 200 ns for global reset to finish
		
		leftshift = 0;

		#200;
		A=32'h3FC00000;
		B=32'h3FA00000;
		
		 opcode = 3'b010;
		#200;
		A=32'hC0540000;
		B=32'h40E60000;

		 opcode = 3'b010;
		#200;
		A=32'b01111111101101100000000000000000;
		B=32'b01111111101100100000010000011001;
	
		 opcode = 3'b010;
		#200;
		A=32'hC0540000;
		B=32'h40E60000;

		 opcode = 3'b010;


		#200;
       	 A=32'b01000010001101100000000000000000;//11.375
			B=32'b01000011011111100000000000000000;//5.56300
		 Cin = 0;
		 opcode = 3'b100;
		leftshift = 1;
	
		#200;
       	 A=32'b01000010001101100000000000000000;//11.375
			B=32'b01000000000000000000000000000000;//5.56300
		 Cin = 0;
		 opcode = 3'b100;
		leftshift = 0;
		 
		 #200;
       	 A=32'b11000001001101100000000000000000;//11.375
			B=32'b11000000101100100000010000011001;//5.56300
		 Cin = 0;
		 opcode = 0;
	
	 	 #200;
       	 A=32'b00111111111101010000011010010111;//11.375
		 B=32'b10111111111101001001011100000101;//5.56300

		 Cin = 0;
		 opcode = 0;


		

		#200;
//       	 A=32'b01000001001101100000000000000000;//11.375
			A=32'b11000011101111011000000101001100;
			B=32'b11000010101011011011110101001000;	
//			B=32'b01000000101100100000010000011001;//5.56300
		 Cin = 0;
		 opcode = 0;
		 //SUM=16.938
		 $monitor("Output:  %b ",Out);

		#200;
       	 A=32'b11000001001101100000000000000000;//11.375
		 B=32'b11000000101100100000010000011001;//5.56300
		 Cin = 0;
		 opcode = 3'b010;
		 //SUM=16.938
		 $monitor("Output:  %b ",Out); 

	 	 #200;
       	 A=32'b01000001001101100000000000000000;//11.375
		 B=32'b11000000101100100000010000011001;//5.56300
		 Cin = 0;
		 opcode = 3'b011;
                start = 1;
        #2     start = 0;
		 //SUM=16.938
		 $monitor("Output:  %b ",Out);	

		 #200;
       	 A=32'b11000001001101100000000000000000;//11.375
		 B=32'b01000000101100100000010000011001;//5.56300
		 Cin = 0;
		 opcode = 0;
		 //SUM=16.938
		 $monitor("Output:  %b ",Out);




		#200 
		 B=32'b01000010011011111110101001111111;//59.979
		 A=32'b01000000110100000000000000000000;//6.5
		 Cin = 0;
		 opcode = 3'b001;
		 //SUM=66.479
		 $monitor("Output:  %b ",Out);
		 
		

		#200 
		 B=32'b11000010011011111110101001111111;//59.979
		 A=32'b11000000110100000000000000000000;//6.5
		 Cin = 0;
//		 opcode = 0;
		 //SUM=66.479
		 $monitor("Output:  %b ",Out);

		#200 
		 B=32'b01000010011011111110101001111111;//59.979
		 A=32'b11000000110100000000000000000000;//6.5
		 Cin = 0;
		 //SUM=66.479
		 $monitor("Output:  %b ",Out);

		#200 
		 B=32'b11000010011011111110101001111111;//59.979
		 A=32'b01000000110100000000000000000000;//6.5
		 Cin = 0;
		 //SUM=66.479
		 $monitor("Output:  %b ",Out);









		#200 
		 A=32'b01000100011110100010000000000000;//1000.5
		 B=32'b01000100011101010110100111011011;//981.654
		 Cin = 0;
		 //SUM=1982.1539
		 $monitor("Output:  %b ",Out);
		 
		 
		#200
		 A=32'b01000100000010010111111100101011;//549.987
		 B=32'b01000000101100100000010000011001;//5.563
		 Cin = 0;
		 //SUM=555.499
		 $monitor("Output:  %b ",Out);
		  
		
	end
      
endmodule





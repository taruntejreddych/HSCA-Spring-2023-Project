module cla_4(InputA,InputB,Cin,Out,cout);
	input[3:0] InputA,InputB;
	input Cin;
	output cout;
	output[3:0] Out;
	wire[3:0] g,p;
	wire[13:0] z;


	assign p[0] = InputA[0] ^ InputB[0];
	assign g[0] = InputA[0] & InputB[0];
	assign p[1] = InputA[1] ^ InputB[1];
	assign g[1] = InputA[1] & InputB[1];
	assign p[2] = InputA[2] ^ InputB[2];
	assign g[2] = InputA[2] & InputB[2];
	assign p[3] = InputA[3] ^ InputB[3];
	assign g[3] = InputA[3] & InputB[3];

	assign Out[0] = Cin ^ p[0];
	assign z[0] = Cin & p[0];

	assign z[1] = z[0] | g[0];
	assign Out[1] = z[1] ^ p[1];
	assign z[2] = Cin & p[0] & p[1];
	assign z[3] = g[0] & p[1];

	assign z[4] = z[2] | g[1] | z[3];
	assign Out[2] = z[4] ^ p[2];
	assign z[5] = Cin & p[0] & p[1] & p[2];
	assign z[6] = g[0] & p[1] & p[2];
	assign z[7] = g[1] & p[2];

	assign z[8] = z[5] | z[6] | g[2] | z[7];
	assign Out[3] = z[8] ^ p[3];
	assign z[9] = Cin & p[0] & p[1] & p[2];
	assign z[10] = g[0] & p[1] & p[2];
	assign z[11] = g[1] & p[2];

	assign z[12] = z[9] | z[10] | g[2] | z[11];
	assign z[13] = z[12] & p[3];

	assign cout = z[13] | g[3];

endmodule

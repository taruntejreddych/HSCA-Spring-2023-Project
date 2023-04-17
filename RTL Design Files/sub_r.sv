module Sub_Result(input Cin, input [7:0] A, input [7:0] B, output [7:0] Out, output b);
	wire [7:0]d;
	wire [7:0]d1;

	wire [7:0] w;

	assign d[0] = A[0] ^ B[0];
	assign w[0] = ~A[0] & B[0];

	assign d[1] = (A[1] ^ B[1]) ^ w[0];
	assign w[1] = (~A[1] & ~B[1] & w[0]) | (~A[1] & B[1] & w[0]) | (~A[1] & B[1] & ~w[0]) | (A[1] & B[1] & w[0]);


	assign d[2] = (A[2] ^ B[2]) ^ w[1];
	assign w[2] = (~A[2] & ~B[2] & w[1]) | (~A[2] & B[2] & w[1]) | (~A[2] & B[2] & ~w[1]) | (A[2] & B[2] & w[1]);

	assign d[3] = (A[3] ^ B[3]) ^ w[2];
	assign w[3] = (~A[3] & ~B[3] & w[2]) | (~A[3] & B[3] & w[2]) | (~A[3] & B[3] & ~w[2]) | (A[3] & B[3] & w[2]);

	assign d[4] = (A[4] ^ B[4]) ^ w[3];
	assign w[4] = (~A[4] & ~B[4] & w[3]) | (~A[4] & B[4] & w[3]) | (~A[4] & B[4] & ~w[3]) | (A[4] & B[4] & w[3]);

	assign d[5] = (A[5] ^ B[5]) ^ w[4];
	assign w[5] = (~A[5] & ~B[5] & w[4]) | (~A[5] & B[5] & w[4]) | (~A[5] & B[5] & ~w[4]) | (A[5] & B[5] & w[4]);

	assign d[6] = (A[6] ^ B[6]) ^ w[5];
	assign w[6] = (~A[6] & ~B[6] & w[5]) | (~A[6] & B[6] & w[5]) | (~A[6] & B[6] & ~w[5]) | (A[6] & B[6] & w[5]);

	assign d[7] = (A[7] ^ B[7]) ^ w[6];
	assign w[7] = (~A[7] & ~B[7] & w[6]) | (~A[7] & B[7] & w[6]) | (~A[7] & B[7] & ~w[6]) | (A[7] & B[7] & w[6]);
	
	assign b= w[7];

//ksa_top sub (1'b1, A, (~B), d, b);


	Complement2s C(d, d1);
	assign Out=(b == 1'b1)?d1:d;


endmodule

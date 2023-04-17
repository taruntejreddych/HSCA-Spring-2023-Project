module  FP_Adder_Sub(input [31:0] A, input [31:0] B, input Cin, output [31:0] Out, input [2:0] opcode, output Vout);

	wire [7:0]Exp_A; 
	wire [7:0]Exp_B;
	assign Exp_A = A[30:23];
	assign Exp_B = B[30:23];

	wire sub;
	assign sub = ~B[31]; 
		
	reg B_sign;

	always_comb begin
		if(opcode == 3'b001) begin
			B_sign = sub;
		end
		else 
			B_sign = B[31];
	end


	wire [24:0] Mantissa_A_1;
	wire [24:0] Mantissa_B_1;

	assign Mantissa_A_1[22:0]=A[22:0];
	assign Mantissa_B_1[22:0]=B[22:0];

	assign Mantissa_A_1[23] = 1'b1;
	assign Mantissa_B_1[23] = 1'b1;

	assign Mantissa_A_1[24] = A[31];
	
	assign Mantissa_B_1[24] = B_sign;

	wire [23:0]Mantissa_A_c; 
	wire [23:0]Mantissa_B_c; 

		
	wire [7:0]Diff;
	wire great_A;
	
	Sub_Result subtract(1'b1, Exp_A,Exp_B,Diff,great_A);
	

	reg [23:0]mux1out;
	reg [23:0]mux2out;

 	wire [23:0] mux1out_c;

 	wire [23:0] mux2out_c;

	wire [24:0] mux1out_1;
	wire [24:0] mux2out_1;
	
	Mux24 rightshiftertop(Mantissa_B_1,Mantissa_A_1,great_A,mux1out_1);
	Mux24 addertop(Mantissa_A_1,Mantissa_B_1,great_A,mux2out_1);

	wire [23:0]outshift;

	wire sign_shift;
	assign sign_shift = (great_A == 0) ? B_sign : A[31];

	
	wire [4:0]shiftdiff;

	wire [23:0] outshift_1;

	assign shiftdiff = Diff[4:0];
	BarrelShifter rightshift(mux1out_1[23:0], outshift, shiftdiff, 1'b0);
	
	wire [23:0]adderout;
	wire cout;
	wire cout_1;


	Comp_24 Mantissa_A_c_1(outshift,mux1out_c);	
	Comp_24 Mantissa_B_c_1(mux2out_1[23:0],mux2out_c);		



	always_comb begin
	if(mux1out_1[24] != mux2out_1[24]) begin
		mux1out = (mux1out_1[24]==1) ? mux1out_c : outshift;
		mux2out = (mux2out_1[24]==1) ? mux2out_c : mux2out_1[23:0];
	end
	else begin
		mux1out = outshift;
		mux2out = mux2out_1[23:0];
	end

	end
	

	wire [23:0] adderout_temp;

	//Adder_24Bit A1(mux2out,mux1out,adderout_temp,cout_1);
	//assign {cout_1, adderout_temp} = mux2out + mux1out;
	ksa_top A1(Cin, mux2out,mux1out,adderout_temp,cout_1);
	//cla A1(mux2out,mux1out, Cin, adderout_temp,cout_1);

	assign cout = (A[31] != B_sign) ? 0 : cout_1; 

	reg [23:0] finalout;
	reg  [7:0]	finexp;
	wire [7:0]maxexp ;
	Mux_8 expmax(Exp_A,Exp_B,great_A,maxexp);


reg greater_neg;

	always_comb begin
	if(A[31] != B_sign) begin
		if(A[31] == 1) begin
			if(A[30:23] == B[30:23]) begin
				if(A[22:0] > B[22:0])
					greater_neg = 1'b1;
				else 
					greater_neg =1'b0;
			end

			else if(A[30:23] > B[30:23])
				greater_neg = 1'b1;		
			else 
				greater_neg = 1'b0;
		end
		
		else if(B_sign == 1) begin
			if(A[30:23] == B[30:23]) begin
				if(B[22:0] > A[22:0])
					greater_neg = 1'b1;
				else 
					greater_neg =1'b0;
			end

			else if(B[30:23] > A[30:23])
				greater_neg = 1'b1;		
			else 
				greater_neg = 1'b0;
		end		
	end

	else
		greater_neg = 1'b0;
	end


wire [23:0] adderout_c;
Comp_24 adderout_c_1(adderout_temp,adderout_c);


assign adderout = (greater_neg == 1) ? (adderout_c) : adderout_temp;	

	always_comb begin
	if(mux1out_1[24] != mux2out_1[24]) begin
		if(adderout[23]!=1) begin
			finexp = maxexp - 1;
			finalout = adderout << 1;
		end
		else begin
			finexp = maxexp;
			finalout = adderout;
		end
	end
	else begin
		finexp = maxexp + 1;
		finalout = adderout >> 1;
	end

	end

	reg sign_final;
	reg Vout1;
	
	always_comb begin
	if(A[31] == B_sign) begin
		sign_final = A[31];
		if(Exp_A == 8'b11111111 && Exp_B == 8'b11111111) begin
				Vout1 = 1'b1;
		end
		else
			Vout1 = 1'b0;		
			
	end
	else if(greater_neg == 1) begin
		sign_final = 1'b1;
		Vout1 = 1'b0;
	end
	else begin 
		sign_final = 1'b0;
		Vout1 = 1'b0;
	end
	end

	assign Vout = Vout1;
	assign Out[31] = sign_final;
	assign Out[30:23] = finexp;
	assign Out[22:0] = finalout [22:0];


endmodule



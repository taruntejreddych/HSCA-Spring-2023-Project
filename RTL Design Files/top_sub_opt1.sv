module FPalu (input [31:0] A, input [31:0] B, input Cin, input [2:0] opcode, output reg [31:0] Out, output Cout, input clk, input clk_fast, input start, output reg busy, output reg valid, output reg dbz, output reg ovf, output reg zbz, output reg unf, input leftshift, output greaterA, output equalA, output lesserA);
//reg [31:0] Out;
wire [31:0] Out1;
wire [31:0] Out2;
wire [31:0] Out3;
wire [31:0] Out4;
wire [31:0] Out5;

wire [22:0] M;
wire [51:0] C;
wire S;
wire [7:0] E;
wire ovf3;

//`define P = 1'b1;

//parameter P=1;
wire busy1, valid1, dbz1, zbz1, ovf1, unf1, ovf2;
wire ovf4, unf4;

FP_Adder_Sub add(.A(A), .B(B), .Cin(Cin), .Out(Out1), .opcode(opcode), .Vout(ovf2)); 
BOOTH_16_BIT mul(.A_i(A), .B_i(B),  .result(Out2), .overflow(ovf3));
div_top div_1(.A(A), .B(B), .C(Out3), .unf(unf1), .ovf(ovf1), .zbz(zbz1), .dbz(dbz1), .clk(clk), .start(start), .busy(busy1), .valid(valid1));

shifter shift(.inputA(A), .inputB(B), .leftshift(leftshift), .Out(Out4), .ovf(ovf4), .unf(unf4));
comparator comp(.inputA(A), .inputB(B), .greaterA(greaterA), .equalA(equalA), .lesserA(lesserA));


always@(*) begin
	if(opcode == 3'b000 | opcode == 3'b001) begin
		Out = Out1;	
		busy = 0;
		valid = 0;
		zbz = 0;
		dbz = 0;
		ovf = ovf2;
		unf = 0;
	end
	else if(opcode == 3'b010) begin
		Out = Out2;
		busy = 0;
		valid = 0;
		zbz = 0;
		dbz = 0;
		ovf = ovf3;
		unf = 0;
	end
	else if(opcode == 3'b011) begin
		Out = Out3;	
		busy = busy1;
		valid = valid1;
		zbz = zbz1;
		dbz = dbz1;
		ovf = ovf1;
		unf = unf1;
	end
	else if(opcode == 3'b100) begin
		Out = Out4;	
		busy = 0;
		valid = 0;
		zbz = 0;
		dbz = 0;
		ovf = ovf4;
		unf = unf4;
	end
end
endmodule



module comparator(inputA, inputB, greaterA, equalA, lesserA);
    input [31:0] inputA;
    input [31:0] inputB;
	output reg greaterA, equalA, lesserA;

	always_comb begin
		if(inputA[31] == inputB[31]) begin
			if(inputA[31] == 0) begin
				if(inputA[30:23] > inputB[30:23]) begin
					greaterA = 1'b1;
					equalA = 0;
					lesserA = 0;
				end
				else if(inputA[30:23] == inputB[30:23]) begin
					if(inputA[22:0] > inputB[22:0]) begin
						greaterA = 1'b1;
						equalA = 0;
						lesserA = 0;
					end
					else if(inputA[22:0] == inputB[22:0]) begin
						greaterA = 0;
						equalA = 1'b1;
						lesserA = 0;
					end
					else begin
						greaterA = 0;
						equalA = 0;	
						lesserA = 1'b1;
					end
				end
				else begin
					greaterA = 0;
					equalA = 0;
					lesserA = 1'b1;
				end
			end
			else begin
				if(inputA[30:23] < inputB[30:23]) begin
					greaterA = 1'b1;
					equalA = 0;
					lesserA = 0;	
				end
				else if(inputA[30:23] == inputB[30:23]) begin
					if(inputA[22:0] < inputB[22:0]) begin
						greaterA = 1'b1;
						equalA = 0;
						lesserA = 0;
					end
					else if(inputA[22:0] == inputB[22:0]) begin
						greaterA = 0;
						equalA = 1'b1;
						lesserA = 0;
					end
					else begin
						greaterA = 0;
						equalA = 0;
						lesserA = 1'b1;
					end
				end
				else begin
					greaterA = 0;
					equalA = 0;
					lesserA = 1'b1;

				end
			end
		end
	
		else begin
			if(inputA[31] == 0) begin
				greaterA = 1'b1;
				equalA = 0;
				lesserA = 0;
			end
			else begin 
				greaterA = 0;
				equalA = 0;
				lesserA = 1'b1;
			end
		end
	end		

endmodule


module shifter(inputA, inputB, leftshift, Out, ovf, unf);
    input [31:0] inputA;
    input [31:0] inputB;
	input leftshift;
    output reg [31:0] Out;
	output reg ovf;
	output reg unf;

	wire [23:0] z;
	wire [20:0] t1;	
	wire [20:0] t2;

	assign z = {1'b1,inputB[22:0]};

	assign t1 = inputA[30:23] + (z >> (8'b00010111 - (inputB[30:23] - 8'b01111111) ));
	assign t2 = inputA[30:23] - (z >> (8'b00010111 - (inputB[30:23] - 8'b01111111) ));

	always_comb begin
		if(leftshift == 1) begin
			Out[31] = inputA[31];
			Out[22:0] = inputA[22:0];
			Out[30:23] = t1[7:0];
		end
		else begin
			Out[31] = inputA[31];
			Out[22:0] = inputA[22:0];
			Out[30:23] = t2[7:0];
		end			
	end

	always_comb begin
		if(t1 > 8'd254) begin
			ovf = 1'b1;
			unf = 1'b0;
		end
		else if (inputA[30:23] <= (z >> (8'b00010111 - (inputB[30:23] - 8'b01111111))) ) begin
			unf = 1'b1;
			ovf = 1'b0;
		end
		else begin
			ovf = 1'b0;
			unf = 1'b0;
		end			
	end




endmodule




module cla( inputA,inputB,Cin,Out,cout);
    input [23:0] inputA;
    input [23:0] inputB;
    input Cin;
    output cout;
    output [23:0] Out;

 	wire c_1,c_2,c_3,c_4,c_5;

  	cla_4 a(inputA[3:0],inputB[3:0],Cin,Out[3:0],c_1);
 	cla_4 b(inputA[7:4],inputB[7:4],c_1,Out[7:4],c_2);
 	cla_4 c(inputA[11:8],inputB[11:8],c_2,Out[11:8],c_3);
 	cla_4 d(inputA[15:12],inputB[15:12],c_3,Out[15:12],c_4);
 	cla_4 e(inputA[19:16],inputB[19:16],c_4,Out[19:16],c_5);
 	cla_4 f(inputA[23:20],inputB[23:20],c_5,Out[23:20],cout);

endmodule


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

module BarrelShifter(
    input [23:0] In,
    output [23:0] Out,
    input [4:0] Shift,
	input sign_shift
    );
	 
 wire [23:0]a;
 genvar i;
 parameter P=1; 
 generate
	if(P==1)	begin:b1
		for(i=0;i<23;i=i+1)
			begin:b2
			Mux M(In[i] , In[i+1] , Shift[0] , a[i]);
			end
	 Mux M1(In[23] , sign_shift , Shift[0] , a[23]);
	end
endgenerate

wire [23:0]a1;
genvar j , k;

generate
	if(P==1)begin:b3
		for(j=0;j<22;j=j+1)
			begin:b4
		    	Mux M2(a[j] , a[j+2] , Shift[1] , a1[j]);
			end
	    for(k=22;k<24;k=k+1)
			begin:b5
			   Mux M3(a[k] , sign_shift , Shift[1] , a1[k]);
			end
	end
endgenerate

genvar p , q;
wire [23:0]a2;

generate
	if(P==1)begin:b6
		for(p=0;p<20;p=p+1)
			begin:b7
			 Mux M4(a1[p] , a1[p+4] , Shift[2] , a2[p]);
			end
		for(k=20;k<24;k=k+1)
			begin:b8
			 Mux M5(a1[k] , sign_shift , Shift[2] , a2[k]);
			end
	end
endgenerate

genvar x , y;
wire [23:0]a3;

generate
	if(P==1)begin
		for(x=0;x<16;x=x+1)
		 begin:b9
		  Mux M6(a2[x] , a2[x+8] , Shift[3] , a3[x]);
		 end
		for(y=16;y<24;y=y+1)
		 begin:b10
		  Mux M7(a2[y] , sign_shift , Shift[3] , a3[y]);
		 end
	end
endgenerate

genvar s , t;
wire [23:0]a4;

generate
	if(P==1)begin:b11
	for(s=0;s<8;s=s+1)
		begin:b12
		 Mux M8(a3[s] , a3[s+4] , Shift[4] , a4[s]);
		end
	for(t=8;t<24;t=t+1)
		begin:b13
		 Mux M9(a3[t] , sign_shift , Shift[4] , a4[t]);
		end
	end
endgenerate

assign Out = a4;

endmodule

module Complement2s(
    input [7:0] A,
    output [7:0] Out
    );
	 
wire [7:0]w;
genvar j;
parameter P =1;
 generate
 if(P==1) begin
   for(j=0;j<8;j=j+1)
    begin
     Mux M(1'b1,1'b0,A[j],w[j]);
    end
  end
endgenerate

wire [7:0]c;

//HalfAdder H1(w[0],1'b1,Out[0],c[0]);

assign Out[0] = w[0] ^ 1'b1;
assign c[0] = w[0] & 1'b1;

genvar i;

	generate
		if(P==1)begin
			for(i=1;i<8;i=i+1)
			  begin
//			    FullAdder F1(w[i],1'b0,c[i-1],Out[i],c[i]);

				assign Out[i] = ((w[i] ^ 1'b0)) ^ c[i-1];
				assign c[i] = ((w[i] ^ 1'b0) & c[i-1]) | (w[i] & 1'b0);
			  end
		end
	endgenerate
	
endmodule

module Comp_24(
    input [23:0] inputA,
    output [23:0] Out
    );
	 
wire [23:0]w;
genvar j;

parameter P =1;
generate
 if(P==1) begin
   for(j=0;j<24;j=j+1)
    begin
     Mux M(1'b1,1'b0,inputA[j],w[j]);
    end
  end
endgenerate

wire [24:0]c;


//HalfAdder H1(w[0],1'b1,Out[0],c[0]);

assign Out[0] = w[0] ^ 1'b1;
assign c[0] = w[0] & 1'b1;


wire w1,w2,w3;

genvar i;
	generate
	if(P==1)	begin
			for(i=1;i<24;i=i+1)
			  begin
			 //   FullAdder F1(w[i],1'b0,c[i-1],Out[i],c[i]);

		   	//	assign w1 = w[i] ^ 1'b0;
				assign Out[i] = ((w[i] ^ 1'b0)) ^ c[i-1];
			//	assign w2 = w1 & c[i-1];
			//	assign w3 = w[i] & 1'b0;
				assign c[i] = ((w[i] ^ 1'b0) & c[i-1]) | (w[i] & 1'b0);
				
			  end
		end
	endgenerate
	
endmodule



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



module Mux24(

    input [24:0] inputA,
    input [24:0] inputB,
    input sel,
	 output [24:0] Out
    );
	 
genvar i;

parameter P =1;
generate
 if(P==1)begin
  for(i=0;i<24;i = i + 1)
    Mux M(inputA[i],inputB[i],sel,Out[i]);
  end
endgenerate



assign Out[24] = (sel==1'b1) ? inputB[24] : inputA[24];

endmodule

module Mux_8(
    input [7:0] inputA,
    input [7:0] inputB,
    input sel,
    output [7:0] Out
    );
	 
 genvar j;
parameter P=1; 
 generate 
 if(P==1) begin
   for(j=0;j<=7;j=j+1)
    begin
     Mux M(inputA[j],inputB[j],sel,Out[j]);
    end
   end
endgenerate

endmodule

module Mux(
    input inputA,
    input inputB,
    input sel,
	 output Out
    );
	 
assign Out = (~sel & inputA) | (sel & inputB);


endmodule


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

	/*always_comb begin
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
*/

assign greater_neg = 1'b0;

wire [23:0] adderout_c;
Comp_24 adderout_c_1(adderout_temp,adderout_c);


assign adderout = (greater_neg == 1) ? (adderout_c) : adderout_temp;	

	always_comb begin
	if(mux1out_1[24] != mux2out_1[24]) begin
		/*if(adderout[23]!=1&& adderout[22] != 1&& adderout[21] != 1&& adderout[20] != 1&& adderout[19] != 1&& adderout[18] != 1&& adderout[17] != 1&& adderout[16] != 1) begin
			finexp = maxexp - 8;
			finalout = adderout << 8;
		end

		else if(adderout[23] !=1 && adderout[22] != 1&& adderout[21] != 1&& adderout[20] != 1&& adderout[19] != 1&& adderout[18] != 1&& adderout[17] != 1) begin
			finexp = maxexp - 7;
			finalout = adderout << 7;
		end


		else if(adderout[23] !=1 && adderout[22] != 1&& adderout[21] != 1&& adderout[20] != 1&& adderout[19] != 1&& adderout[18] != 1) begin
			finexp = maxexp - 6;
			finalout = adderout << 6;
		end


		else if(adderout[23] !=1 && adderout[22] != 1  && adderout[21] != 1&& adderout[20] != 1&& adderout[19] != 1) begin
			finexp = maxexp - 5;
			finalout = adderout << 5;
		end



		else if(adderout[23] !=1 && adderout[22] != 1  && adderout[21] != 1 && adderout[20] != 1) begin
			finexp = maxexp - 4;
			finalout = adderout << 4;
		end


		else if(adderout[23] !=1 && adderout[22] != 1  && adderout[21] != 1) begin
			finexp = maxexp - 3;
			finalout = adderout << 3;
		end

		else if(adderout[23] !=1 && adderout[22] != 1 ) begin
			finexp = maxexp - 2;
			finalout = adderout << 2;
		end
	*/	if(adderout[23] !=1) begin
			finexp = maxexp - 1;
			finalout = adderout << 1;
		end


		else begin
			finexp = maxexp;
			finalout = adderout;
		end
	end
	else begin
		if(adderout[23]!=1 || cout_1 == 1) begin
			finexp = maxexp + 1;
			finalout = adderout >> 1;
		end
		else begin
			finalout =adderout;
			finexp = maxexp;	
		end
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



module black(
  input  wire i_pj,
  input  wire i_gj,
  input  wire i_pk,
  input  wire i_gk,
  output wire o_g,
  output wire o_p
);

assign o_g = i_gk | (i_gj & i_pk);
assign o_p = i_pk & i_pj;

endmodule

module grey(
  input  wire i_gj,
  input  wire i_pk,
  input  wire i_gk,
  output wire o_g
);

assign o_g = i_gk | (i_gj & i_pk);

endmodule

module ks_1(
  input i_c0,
  input  wire [23:0]i_a,
  input  wire [23:0]i_b,
  output wire [23:0]o_pk_1,
  output wire [23:0]o_gk_1,
  output o_c0_1
);

assign o_c0_1 = i_c0;

pg pg_0(i_a[0], i_b[0], o_pk_1[0], o_gk_1[0]);
pg pg_1(i_a[1], i_b[1], o_pk_1[1], o_gk_1[1]);
pg pg_2(i_a[2], i_b[2], o_pk_1[2], o_gk_1[2]);
pg pg_3(i_a[3], i_b[3], o_pk_1[3], o_gk_1[3]);
pg pg_4(i_a[4], i_b[4], o_pk_1[4], o_gk_1[4]);
pg pg_5(i_a[5], i_b[5], o_pk_1[5], o_gk_1[5]);
pg pg_6(i_a[6], i_b[6], o_pk_1[6], o_gk_1[6]);
pg pg_7(i_a[7], i_b[7], o_pk_1[7], o_gk_1[7]);
pg pg_8(i_a[8], i_b[8], o_pk_1[8], o_gk_1[8]);
pg pg_9(i_a[9], i_b[9], o_pk_1[9], o_gk_1[9]);
pg pg_10(i_a[10], i_b[10], o_pk_1[10], o_gk_1[10]);
pg pg_11(i_a[11], i_b[11], o_pk_1[11], o_gk_1[11]);
pg pg_12(i_a[12], i_b[12], o_pk_1[12], o_gk_1[12]);
pg pg_13(i_a[13], i_b[13], o_pk_1[13], o_gk_1[13]);
pg pg_14(i_a[14], i_b[14], o_pk_1[14], o_gk_1[14]);
pg pg_15(i_a[15], i_b[15], o_pk_1[15], o_gk_1[15]);
pg pg_16(i_a[16], i_b[16], o_pk_1[16], o_gk_1[16]);
pg pg_17(i_a[17], i_b[17], o_pk_1[17], o_gk_1[17]);
pg pg_18(i_a[18], i_b[18], o_pk_1[18], o_gk_1[18]);
pg pg_19(i_a[19], i_b[19], o_pk_1[19], o_gk_1[19]);
pg pg_20(i_a[20], i_b[20], o_pk_1[20], o_gk_1[20]);
pg pg_21(i_a[21], i_b[21], o_pk_1[21], o_gk_1[21]);
pg pg_22(i_a[22], i_b[22], o_pk_1[22], o_gk_1[22]);
pg pg_23(i_a[23], i_b[23], o_pk_1[23], o_gk_1[23]);

endmodule

module ks_2(
  input  wire        i_c0,
  input  wire [23:0] i_pk,
  input  wire [23:0] i_gk,
  output wire        o_c0,
  output wire [23:0] o_pk,
  output wire [23:0] o_gk,
  output wire [23:0] o_p_save
);

wire [23:0] gkj;
wire [23:0] pkj;

assign o_c0      = i_c0;
assign o_p_save  = i_pk[23:0];
assign gkj[0]    = i_c0;
assign gkj[23:1] = i_gk[22:0];
assign pkj       = i_pk[22:0];

grey gc_0(gkj[0], i_pk[0], i_gk[0], o_gk[0]);
black bc_0(pkj[0], gkj[1], i_pk[1], i_gk[1], o_gk[1], o_pk[0]);
black bc_1(pkj[1], gkj[2], i_pk[2], i_gk[2], o_gk[2], o_pk[1]);
black bc_2(pkj[2], gkj[3], i_pk[3], i_gk[3], o_gk[3], o_pk[2]);
black bc_3(pkj[3], gkj[4], i_pk[4], i_gk[4], o_gk[4], o_pk[3]);
black bc_4(pkj[4], gkj[5], i_pk[5], i_gk[5], o_gk[5], o_pk[4]);
black bc_5(pkj[5], gkj[6], i_pk[6], i_gk[6], o_gk[6], o_pk[5]);
black bc_6(pkj[6], gkj[7], i_pk[7], i_gk[7], o_gk[7], o_pk[6]);
black bc_7(pkj[7], gkj[8], i_pk[8], i_gk[8], o_gk[8], o_pk[7]);
black bc_8(pkj[8], gkj[9], i_pk[9], i_gk[9], o_gk[9], o_pk[8]);
black bc_9(pkj[9], gkj[10], i_pk[10], i_gk[10], o_gk[10], o_pk[9]);
black bc_10(pkj[10], gkj[11], i_pk[11], i_gk[11], o_gk[11], o_pk[10]);
black bc_11(pkj[11], gkj[12], i_pk[12], i_gk[12], o_gk[12], o_pk[11]);
black bc_12(pkj[12], gkj[13], i_pk[13], i_gk[13], o_gk[13], o_pk[12]);
black bc_13(pkj[13], gkj[14], i_pk[14], i_gk[14], o_gk[14], o_pk[13]);
black bc_14(pkj[14], gkj[15], i_pk[15], i_gk[15], o_gk[15], o_pk[14]);
black bc_15(pkj[15], gkj[16], i_pk[16], i_gk[16], o_gk[16], o_pk[15]);
black bc_16(pkj[16], gkj[17], i_pk[17], i_gk[17], o_gk[17], o_pk[16]);
black bc_17(pkj[17], gkj[18], i_pk[18], i_gk[18], o_gk[18], o_pk[17]);
black bc_18(pkj[18], gkj[19], i_pk[19], i_gk[19], o_gk[19], o_pk[18]);
black bc_19(pkj[19], gkj[20], i_pk[20], i_gk[20], o_gk[20], o_pk[19]);
black bc_20(pkj[20], gkj[21], i_pk[21], i_gk[21], o_gk[21], o_pk[20]);
black bc_21(pkj[21], gkj[22], i_pk[22], i_gk[22], o_gk[22], o_pk[21]);
black bc_22(pkj[22], gkj[23], i_pk[23], i_gk[23], o_gk[23], o_pk[22]);

endmodule

module ks_3(
  input  wire        i_c0,
  input  wire [23:0] i_pk,
  input  wire [23:0] i_gk,
  input  wire [23:0] i_p_save,
  output wire        o_c0,
  output wire [23:0] o_pk,
  output wire [23:0] o_gk,
  output wire [23:0] o_p_save
);

wire [23:0] gkj;
wire [23:0] pkj;

assign o_c0      = i_c0;
assign o_p_save  = i_p_save[23:0];
assign gkj[0]    = i_c0;
assign gkj[23:1] = i_gk[22:0];
assign pkj       = i_pk[23:0];
assign o_gk[0]   = i_gk[0];

grey gc_0(gkj[0], i_pk[0], i_gk[1], o_gk[1]);
grey gc_1(gkj[1], i_pk[1], i_gk[2], o_gk[2]);
black bc_0(pkj[0], gkj[2], i_pk[2], i_gk[3], o_gk[3], o_pk[0]);
black bc_1(pkj[1], gkj[3], i_pk[3], i_gk[4], o_gk[4], o_pk[1]);
black bc_2(pkj[2], gkj[4], i_pk[4], i_gk[5], o_gk[5], o_pk[2]);
black bc_3(pkj[3], gkj[5], i_pk[5], i_gk[6], o_gk[6], o_pk[3]);
black bc_4(pkj[4], gkj[6], i_pk[6], i_gk[7], o_gk[7], o_pk[4]);
black bc_5(pkj[5], gkj[7], i_pk[7], i_gk[8], o_gk[8], o_pk[5]);
black bc_6(pkj[6], gkj[8], i_pk[8], i_gk[9], o_gk[9], o_pk[6]);
black bc_7(pkj[7], gkj[9], i_pk[9], i_gk[10], o_gk[10], o_pk[7]);
black bc_8(pkj[8], gkj[10], i_pk[10], i_gk[11], o_gk[11], o_pk[8]);
black bc_9(pkj[9], gkj[11], i_pk[11], i_gk[12], o_gk[12], o_pk[9]);
black bc_10(pkj[10], gkj[12], i_pk[12], i_gk[13], o_gk[13], o_pk[10]);
black bc_11(pkj[11], gkj[13], i_pk[13], i_gk[14], o_gk[14], o_pk[11]);
black bc_12(pkj[12], gkj[14], i_pk[14], i_gk[15], o_gk[15], o_pk[12]);
black bc_13(pkj[13], gkj[15], i_pk[15], i_gk[16], o_gk[16], o_pk[13]);
black bc_14(pkj[14], gkj[16], i_pk[16], i_gk[17], o_gk[17], o_pk[14]);
black bc_15(pkj[15], gkj[17], i_pk[17], i_gk[18], o_gk[18], o_pk[15]);
black bc_16(pkj[16], gkj[18], i_pk[18], i_gk[19], o_gk[19], o_pk[16]);
black bc_17(pkj[17], gkj[19], i_pk[19], i_gk[20], o_gk[20], o_pk[17]);
black bc_18(pkj[18], gkj[20], i_pk[20], i_gk[21], o_gk[21], o_pk[18]);
black bc_19(pkj[19], gkj[21], i_pk[21], i_gk[22], o_gk[22], o_pk[19]);
black bc_20(pkj[20], gkj[22], i_pk[22], i_gk[23], o_gk[23], o_pk[20]);

endmodule


module ks_4(
  input  wire        i_c0,
  input  wire [23:0] i_pk,
  input  wire [23:0] i_gk,
  input  wire [23:0] i_p_save,
  output wire        o_c0,
  output wire [23:0] o_pk,
  output wire [23:0] o_gk,
  output wire [23:0] o_p_save
);

wire [23:0] gkj;
wire [23:0] pkj;

assign o_c0      = i_c0;
assign o_p_save  = i_p_save[23:0];
assign gkj[0]    = i_c0;
assign gkj[23:1] = i_gk[22:0];
assign pkj       = i_pk[23:0];
assign o_gk[2:0] = i_gk[2:0];

grey gc_0(gkj[0], i_pk[0], i_gk[3], o_gk[3]);
grey gc_1(gkj[1], i_pk[1], i_gk[4], o_gk[4]);
grey gc_2(gkj[2], i_pk[2], i_gk[5], o_gk[5]);
grey gc_3(gkj[3], i_pk[3], i_gk[6], o_gk[6]);
black bc_0(pkj[0], gkj[4], i_pk[4], i_gk[7], o_gk[7], o_pk[0]);
black bc_1(pkj[1], gkj[5], i_pk[5], i_gk[8], o_gk[8], o_pk[1]);
black bc_2(pkj[2], gkj[6], i_pk[6], i_gk[9], o_gk[9], o_pk[2]);
black bc_3(pkj[3], gkj[7], i_pk[7], i_gk[10], o_gk[10], o_pk[3]);
black bc_4(pkj[4], gkj[8], i_pk[8], i_gk[11], o_gk[11], o_pk[4]);
black bc_5(pkj[5], gkj[9], i_pk[9], i_gk[12], o_gk[12], o_pk[5]);
black bc_6(pkj[6], gkj[10], i_pk[10], i_gk[13], o_gk[13], o_pk[6]);
black bc_7(pkj[7], gkj[11], i_pk[11], i_gk[14], o_gk[14], o_pk[7]);
black bc_8(pkj[8], gkj[12], i_pk[12], i_gk[15], o_gk[15], o_pk[8]);
black bc_9(pkj[9], gkj[13], i_pk[13], i_gk[16], o_gk[16], o_pk[9]);
black bc_10(pkj[10], gkj[14], i_pk[14], i_gk[17], o_gk[17], o_pk[10]);
black bc_11(pkj[11], gkj[15], i_pk[15], i_gk[18], o_gk[18], o_pk[11]);
black bc_12(pkj[12], gkj[16], i_pk[16], i_gk[19], o_gk[19], o_pk[12]);
black bc_13(pkj[13], gkj[17], i_pk[17], i_gk[20], o_gk[20], o_pk[13]);
black bc_14(pkj[14], gkj[18], i_pk[18], i_gk[21], o_gk[21], o_pk[14]);
black bc_15(pkj[15], gkj[19], i_pk[19], i_gk[22], o_gk[22], o_pk[15]);
black bc_16(pkj[16], gkj[20], i_pk[20], i_gk[23], o_gk[23], o_pk[16]);

endmodule





module ks_5(
  input  wire        i_c0,
  input  wire [23:0] i_pk,
  input  wire [23:0] i_gk,
  input  wire [23:0] i_p_save,
  output wire        o_c0,
  output wire [16:0] o_pk,
  output wire [23:0] o_gk,
  output wire [23:0] o_p_save
);

wire [23:0] gkj;
wire [16:0] pkj;

assign o_c0      = i_c0;
assign o_p_save  = i_p_save[23:0];
assign gkj[0]    = i_c0;
assign gkj[23:1] = i_gk[22:0];
assign pkj       = i_pk[16:0];
assign o_gk[6:0] = i_gk[6:0];

grey gc_0(gkj[0], i_pk[0], i_gk[7], o_gk[7]);
grey gc_1(gkj[1], i_pk[1], i_gk[8], o_gk[8]);
grey gc_2(gkj[2], i_pk[2], i_gk[9], o_gk[9]);
grey gc_3(gkj[3], i_pk[3], i_gk[10], o_gk[10]);
grey gc_4(gkj[4], i_pk[4], i_gk[11], o_gk[11]);
grey gc_5(gkj[5], i_pk[5], i_gk[12], o_gk[12]);
grey gc_6(gkj[6], i_pk[6], i_gk[13], o_gk[13]);
grey gc_7(gkj[7], i_pk[7], i_gk[14], o_gk[14]);
black bc_0(pkj[0], gkj[8], i_pk[8], i_gk[15], o_gk[15], o_pk[0]);
black bc_1(pkj[1], gkj[9], i_pk[9], i_gk[16], o_gk[16], o_pk[1]);
black bc_2(pkj[2], gkj[10], i_pk[10], i_gk[17], o_gk[17], o_pk[2]);
black bc_3(pkj[3], gkj[11], i_pk[11], i_gk[18], o_gk[18], o_pk[3]);
black bc_4(pkj[4], gkj[12], i_pk[12], i_gk[19], o_gk[19], o_pk[4]);
black bc_5(pkj[5], gkj[13], i_pk[13], i_gk[20], o_gk[20], o_pk[5]);
black bc_6(pkj[6], gkj[14], i_pk[14], i_gk[21], o_gk[21], o_pk[6]);
black bc_7(pkj[7], gkj[15], i_pk[15], i_gk[22], o_gk[22], o_pk[7]);
black bc_8(pkj[8], gkj[16], i_pk[16], i_gk[23], o_gk[23], o_pk[8]);

endmodule

module ks_6(
  input  wire        i_c0,
  input  wire [16:0] i_pk,
  input  wire [23:0] i_gk,
  input  wire [23:0] i_p_save,
  output wire        o_c0,
  output wire [23:0] o_pk,
  output wire [23:0] o_gk
);

wire [16:0] gkj;

assign o_c0       = i_c0;
assign o_pk       = i_p_save[23:0];
assign gkj[0]     = i_c0;
assign gkj[16:1]  = i_gk[15:0];
assign o_gk[15:0] = i_gk[15:0];

grey gc_1(gkj[1], i_pk[1], i_gk[16], o_gk[16]);
grey gc_2(gkj[2], i_pk[2], i_gk[17], o_gk[17]);
grey gc_3(gkj[3], i_pk[3], i_gk[18], o_gk[18]);
grey gc_4(gkj[4], i_pk[4], i_gk[19], o_gk[19]);
grey gc_5(gkj[5], i_pk[5], i_gk[20], o_gk[20]);
grey gc_6(gkj[6], i_pk[6], i_gk[21], o_gk[21]);
grey gc_7(gkj[7], i_pk[7], i_gk[22], o_gk[22]);
grey gc_8(gkj[8], i_pk[8], i_gk[23], o_gk[23]);

endmodule

module ks_7(
  input  wire        i_c0,
  input  wire [23:0] i_pk,
  input  wire [23:0] i_gk,
  output wire [23:0] o_s,
  output wire        o_carry
);

assign o_carry   = i_gk[23];
assign o_s[0]    = i_c0 ^ i_pk[0];
assign o_s[23:1] = i_gk[22:0] ^ i_pk[23:1];

endmodule

module ksa_top(
  input  wire        c0,
  input  wire [23:0] i_a,
  input  wire [23:0] i_b,
  output wire [23:0] o_s,
  output wire        o_carry
);

wire [23:0] p1;
wire [23:0] g1;
wire        c1;

wire [23:0] p2;
wire [23:0] g2;
wire        c2;
wire [23:0] ps1;

wire [23:0] p3;
wire [23:0] g3;
wire        c3;
wire [23:0] ps2;

wire [23:0] p4;
wire [23:0] g4;
wire        c4;
wire [23:0] ps3;

wire [16:0] p5;
wire [23:0] g5;
wire        c5;
wire [23:0] ps4;

wire [23:0] p6;
wire [23:0] g6;
wire        c6;

ks_1 s1(c0, i_a, i_b, p1, g1, c1);
ks_2 s2(c1, p1, g1, c2, p2, g2, ps1);
ks_3 s3(c2, p2, g2, ps1, c3, p3, g3, ps2);
ks_4 s4(c3, p3, g3, ps2, c4, p4, g4, ps3);
ks_5 s5(c4, p4, g4, ps3, c5, p5, g5, ps4);
ks_6 s6(c5, p5, g5, ps4, c6, p6, g6);
ks_7 s7(c6, p6, g6, o_s, o_carry);

endmodule

module pg(
  input  wire i_a,
  input  wire i_b,
  output wire o_p,
  output wire o_g
);

assign o_p = i_a ^ i_b;
assign o_g = i_a & i_b;

endmodule


module PARTIALPRODUCT (INPUT1,segment,OUTPUT1);
input [25:0] INPUT1;input [2:0] segment;output reg [51:0] OUTPUT1;
 always @(*) begin
 case (segment)
 3'b000:OUTPUT1=$signed(1'b0);
 3'b011:
 begin
 OUTPUT1=$signed(INPUT1);
 OUTPUT1=$signed(OUTPUT1)<<<1;
 end
 3'b100:begin
 OUTPUT1=$signed(INPUT1);
 OUTPUT1=$signed(~OUTPUT1+1'b1);
 OUTPUT1=$signed(OUTPUT1)<<<1;
 end
 3'b101:begin
 OUTPUT1=$signed(INPUT1);
 OUTPUT1=$signed(~OUTPUT1+1'b1);
 end
 3'b110:begin
 OUTPUT1=$signed(INPUT1);
 OUTPUT1=$signed(~OUTPUT1+1'b1);
 end
 3'b111:OUTPUT1=$signed(16'b0);
 default:OUTPUT1=$signed(INPUT1);
 endcase
 end
 endmodule
 


module BOOTH_16_BIT(A_i,B_i, result, overflow );
input [31:0] A_i;
input [31:0] B_i;
reg [23:0] A;
reg [23:0] B;
reg [47:0] a;
 reg [51:0] C;
reg [22:0] M;
reg [8:0] E;
reg S;
output reg overflow;
output reg [31:0] result;
//reg [31:0] D, E;
wire [51:0] TEMP [12:0];
operand_man OM(A_i, B_i, A, B);
PARTIALPRODUCT P0({2'b00,A},{B[1:0],1'b0},TEMP[0]);

PARTIALPRODUCT P1({2'b00,A}, B[3:1],TEMP[1]);
PARTIALPRODUCT P2({2'b00,A}, B[5:3],TEMP[2]);
PARTIALPRODUCT P3({2'b00,A}, B[7:5],TEMP[3]);
PARTIALPRODUCT P4({2'b00,A}, B[9:7],TEMP[4]);
PARTIALPRODUCT P5({2'b00,A}, B[11:9],TEMP[5]);
PARTIALPRODUCT P6({2'b00,A}, B[13:11],TEMP[6]);
PARTIALPRODUCT P7({2'b00,A}, B[15:13],TEMP[7]);
PARTIALPRODUCT P8({2'b00,A}, B[17:15],TEMP[8]);
PARTIALPRODUCT P9({2'b00,A}, B[19:17],TEMP[9]);
PARTIALPRODUCT P10({2'b00,A}, B[21:19],TEMP[10]);
PARTIALPRODUCT P11({2'b00,A}, B[23:21],TEMP[11]);
PARTIALPRODUCT P12({2'b00,A},{2'b00, B[23]}, TEMP[12]);



always@(*)
begin
C= ($signed(TEMP[0])+$signed(TEMP[1]<<<2)+$signed(TEMP[2]<<<4)+$signed(TEMP[3]<<<6)+$signed(TEMP[4]<<<8)+$signed(TEMP[5]<<<10)+$signed(TEMP[6]<<<12)+$signed(TEMP[7]<<<14)+$signed(TEMP[8]<<<16)+$signed(TEMP[9]<<<18)+$signed(TEMP[10]<<<20)+$signed(TEMP[11]<<<22)+$signed(TEMP[12]<<<24));
a=C[47:0];
if(a[47]==1) begin
E=A_i[30:23]+B_i[30:23]-127+1;
if(E[8]==1)
overflow=1;
else 
overflow=0;
M=a[46:24];
end 
else begin
E=A_i[30:23]+B_i[30:23]-127;
if(E[8]==1)
overflow=1;
else 
overflow=0;
M=a[45:23];
end
if((A_i[31]==0&&B_i[31]==0) || (A_i[31]==1 && B_i[31]==1)) begin
	S=0;
end
else begin 
	S=1;
end
result={S, E[7:0], M[22:0]};
//E= 3*($signed(TEMP[0])+$signed(TEMP[1]<<<2)+$signed(TEMP[2]<<<4)+$signed(TEMP[3]<<<6)+$signed(TEMP[4]<<<8)+$signed(TEMP[5]<<<10)+$signed(TEMP[6]<<<12)+$signed(TEMP[7]<<<14));
//C=(D+(E/3))/2;
end
endmodule



module operand_man(a_i, b_i, a_i_oper, b_i_oper);
input [31:0] a_i;
input [31:0] b_i;
output reg [23:0] a_i_oper;
output reg [23:0] b_i_oper;
assign b_i_oper={1'b1, b_i[22:0]};
assign a_i_oper={1'b1, a_i[22:0]};
endmodule

module div #(
      // fractional bits (for fixed point)
parameter WIDTH=23,  // width of numbers in bits
    parameter FBITS=22 
    ) (
    input      logic clk,
    input      logic start,          // start signal
    output     logic busy,           // calculation in progress
    output     logic valid,          // quotient and remainder are valid
    output     logic dbz,            // divide by zero flag
    output     logic ovf,            // overflow flag (fixed-point)
    input      logic [WIDTH-1:0] x,  // dividend
    input      logic [WIDTH-1:0] y,  // divisor
    output     logic [WIDTH-1:0] q,  // quotient
    output     logic [WIDTH-1:0] r   // remainder
    );

    // avoid negative vector width when fractional bits are not used
    localparam FBITSW = (FBITS) ? FBITS : 1;

	logic cout_dummy;
    logic [WIDTH-1:0] y1;           // copy of divisor
    logic [WIDTH-1:0] q1, q1_next;  // intermediate quotient
    logic [WIDTH:0] ac, ac_next;    // accumulator (1 bit wider)

    localparam ITER = WIDTH+FBITS;  // iterations are dividend width + fractional bits
    logic [$clog2(ITER)-1:0] i;     // iteration counter

	logic [WIDTH:0] ac_next_1;
	logic [WIDTH:0] ac_next_2;
	ksa_top A2(1'b1, ac, {1'b0,~y1}, ac_next_1, cout_dummy);

    always_comb begin
        if (ac >= {1'b0,y1}) begin
//            ac_next = ac - y1;


            {ac_next_2, q1_next} = {ac_next_1[WIDTH-1:0], q1, 1'b1};
        end else begin
            {ac_next_2, q1_next} = {ac, q1} << 1;
        end
    end

    assign ac_next = ac_next_2;

    always_ff @(posedge clk) begin
        if (start) begin
            valid <= 0;
            ovf <= 0;
            i <= 0;
            if (y == 0) begin  // catch divide by zero
                busy <= 0;
                dbz <= 1;
            end else begin
                busy <= 1;
                dbz <= 0;
                y1 <= y;
                {ac, q1} <= {{WIDTH{1'b0}}, x, 1'b0};
            end
        end else if (busy) begin
            if (i == ITER-1) begin  // done
                busy <= 0;
                valid <= 1;
                q <= q1_next;
                r <= ac_next[WIDTH:1];  // undo final shift
            end else if (i == WIDTH-1 && q1_next[WIDTH-1:WIDTH-FBITSW]) begin // overflow?
                busy <= 0;
                ovf <= 1;
                q <= 0;
                r <= 0;
            end else begin  // next iteration
                i <= i + 1;
                ac <= ac_next;
                q1 <= q1_next;
            end
        end
    end
endmodule


module div_top #(
    parameter WIDTH=32,  // width of numbers in bits
    parameter MBITS=23   // mantissa bits (IEEE 754 single precision floating point)
    ) (
    input      logic clk,
    input      logic start,          // start signal
    output     logic busy,           // calculation in progress
    output     logic valid,          // quotient and remainder are valid
    output     logic dbz,            // divide by zero flag
    output     logic zbz,            // zero by zero flag
    output     logic ovf,            // overflow flag  (exp > exp max)
    output     logic unf,            // underflow flag (exp < exp min)
    input      logic [WIDTH-1:0] A,  // dividend
    input      logic [WIDTH-1:0] B,  // divisor
    output     logic [WIDTH-1:0] C   // result
    );

    logic [MBITS-1 : 0] q;  // quotient
    logic [MBITS-1 : 0] r;  // remainder

    logic extra_bit;
    logic sign;
    logic [7:0] exp;
    logic [MBITS-1 : 0] man;
    logic [MBITS-1 : 0] x;
    logic [MBITS-1 : 0] y;

    always_comb begin
	x = {1'b1, A[22:1]};
	y = {1'b1, B[22:1]};
    end

    div mandiv (
	.clk(clk),
	.start(start),
	.busy(busy),
	.valid(valid),
	.dbz(),
	.ovf(),
	.x(x),
	.y(y),
	.q(q),
	.r(r)
    );
   

    assign dbz = (B==0) & !zbz;
    assign zbz = (A==0 & B==0);
    assign extra_bit = (x>=y) ? 0 : 1;
    assign sign = A[WIDTH-1] ^ B[WIDTH-1];
    assign exp  = A[WIDTH-2 -: 8] - B[WIDTH-2 -: 8] + 8'd127 - extra_bit;
    assign man  = q << extra_bit;
    assign ovf  = (exp>254) & !dbz;
    assign unf  = (exp<1) & !dbz;

    assign C = {sign, exp, man[MBITS-2:0], 1'b0};

endmodule






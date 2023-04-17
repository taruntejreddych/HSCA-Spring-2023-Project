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


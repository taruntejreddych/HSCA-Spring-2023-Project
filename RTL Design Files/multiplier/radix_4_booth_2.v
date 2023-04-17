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

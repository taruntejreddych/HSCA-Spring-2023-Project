module BOOTH_16_BIT_RAD2(A_i,B_i,C, E, S,M );
input [31:0] A_i;
input [31:0] B_i;
reg [23:0] A;
reg [23:0] B;
reg [49:0] a;
output reg [51:0] C;
output reg [22:0] M;
output reg [7:0] E;
reg [51:0] temp17, temp19, temp21;
output reg S;
reg b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23;
//reg [31:0] D, E;
wire [51:0] TEMP [24:0];
operand_man OM(A_i, B_i, A, B);
PARTIALPRODUCT P0({2'b00,A},{B[1:0],1'b0},TEMP[0]);
PARTIALPRODUCT P1({2'b00,A}, {B[2:1],b0},TEMP[1]);
PARTIALPRODUCT P2({2'b00,A}, {B[3:2],b1},TEMP[2]);
PARTIALPRODUCT P3({2'b00,A}, {B[4:3],b2},TEMP[3]);
PARTIALPRODUCT P4({2'b00,A}, {B[5:4],b3},TEMP[4]);
PARTIALPRODUCT P5({2'b00,A}, {B[6:5],b4},TEMP[5]);
PARTIALPRODUCT P6({2'b00,A}, {B[7:6],b5},TEMP[6]);
PARTIALPRODUCT P7({2'b00,A}, {B[8:7],b6},TEMP[7]);
PARTIALPRODUCT P8({2'b00,A}, {B[9:8],b7},TEMP[8]);
PARTIALPRODUCT P9({2'b00,A}, {B[10:9],b8},TEMP[9]);
PARTIALPRODUCT P10({2'b00,A}, {B[11:10],b9},TEMP[10]);
PARTIALPRODUCT P11({2'b00,A}, {B[12:11],b10},TEMP[11]);
PARTIALPRODUCT P12({2'b00,A}, {B[13:12],b11},TEMP[12]);
PARTIALPRODUCT P13({2'b00,A}, {B[14:13],b12},TEMP[13]);
PARTIALPRODUCT P14({2'b00,A}, {B[15:14],b13},TEMP[14]);
PARTIALPRODUCT P15({2'b00,A}, {B[16:15],b14},TEMP[15]);
PARTIALPRODUCT P16({2'b00,A}, {B[17:16],b15},TEMP[16]);
PARTIALPRODUCT P17({2'b00,A}, {B[18:17],b16},TEMP[17]);
PARTIALPRODUCT P18({2'b00,A}, {B[19:18],b17},TEMP[18]);
PARTIALPRODUCT P19({2'b00,A}, {B[20:19],b18},TEMP[19]);
PARTIALPRODUCT P20({2'b00,A}, {B[21:20],b19},TEMP[20]);
PARTIALPRODUCT P21({2'b00,A}, {B[22:21],b20},TEMP[21]);
PARTIALPRODUCT P22({2'b00,A}, {B[23:22],b21},TEMP[22]);
PARTIALPRODUCT P23({2'b00,A}, {1'b0,B[23],b22},TEMP[23]);
PARTIALPRODUCT P24({2'b00,A}, {1'b0,1'b0,b23},TEMP[24]);

always @(*) begin
if({B[1:0],1'b0}==3'b010) begin
	 b0=0;
end 
else begin
	 b0=B[0];
end

if({B[2:1],b0}==3'b010) begin
	 b1=0;
end 
else if ({B[2:1],b0}==3'b101) begin 
	 b1=1;
end
else begin
	 b1=B[1];
end

if({B[3:2],b1}==3'b010) begin
	 b2=0;
end 
else if ({B[3:1]}==3'b101) begin 
	 b2=1;
end
else begin
	 b2=B[2];
end
if({B[4:3],b2}==3'b010) begin
	 b3=0;
end 
else if ({B[4:3],b2}==3'b101) begin 
	 b3=1;
end
else begin
	 b3=B[3];
end
if({B[5:4],b3}==3'b010) begin
	 b4=0;
end 
else if ({B[5:4],b3}==3'b101) begin 
	 b4=1;
end
else begin
	 b4=B[4];
end
if({B[6:5],b4}==3'b010) begin
	 b5=0;
end 
else if ({B[6:5],b4}==3'b101) begin 
	 b5=1;
end
else begin
	 b5=B[5];
end
if({B[7:6],b5}==3'b010) begin
	 b6=0;
end 
else if ({B[7:6],b5}==3'b101) begin 
	 b6=1;
end
else begin
	 b6=B[6];
end
if({B[8:7],b6}==3'b010) begin
	 b7=0;
end 
else if ({B[8:7],b6}==3'b101) begin 
	 b7=1;
end
else begin
	 b7=B[7];
end
if({B[9:8],b7}==3'b010) begin
	 b8=0;
end 
else if ({B[9:8],b7}==3'b101) begin 
	 b8=1;
end
else begin
	 b8=B[8];
end
if({B[10:9],b8}==3'b010) begin
	 b9=0;
end 
else if ({B[10:9],b8}==3'b101) begin 
	 b9=1;
end
else begin
	 b9=B[9];
end

if({B[11:10],b9}==3'b010) begin
	 b10=0;
end 
else if ({B[11:10],b9}==3'b101) begin 
	 b10=1;
end
else begin
	 b10=B[10];
end

if({B[12:11],b10}==3'b010) begin
	 b11=0;
end 
else if ({B[12:11],b10}==3'b101) begin 
	 b11=1;
end
else begin
	 b11=B[11];
end

if({B[13:12],b11}==3'b010) begin
	 b12=0;
end 
else if ({B[13:12],b11}==3'b101) begin 
	 b12=1;
end
else begin
	 b12=B[12];
end

if({B[14:13],b12}==3'b010) begin
	 b13=0;
end 
else if ({B[14:13],b12}==3'b101) begin 
	 b13=1;
end
else begin
	 b13=B[13];
end

if({B[15:14],b13}==3'b010) begin
	 b14=0;
end 
else if ({B[15:14],b13}==3'b101) begin 
	 b14=1;
end
else begin
	 b14=B[14];
end

if({B[16:15],b14}==3'b010) begin
	 b15=0;
end 
else if ({B[16:15],b14}==3'b101) begin 
	 b15=1;
end
else begin
	 b15=B[15];
end


if({B[17:16],b15}==3'b010) begin
	 b16=0;
end 
else if ({B[17:16],b15}==3'b101) begin 
	 b16=1;
end
else begin
	 b16=B[16];
end

if({B[18:17],b16}==3'b010) begin
	 b17=0;
end 
else if ({B[18:17],b16}==3'b101) begin 
	 b17=1;
end
else begin
	 b17=B[17];
end

if({B[19:18],b17}==3'b010) begin
	 b18=0;
end 
else if ({B[19:18],b17}==3'b101) begin 
	 b18=1;
end
else begin
	 b18=B[18];
end

if({B[20:19],b18}==3'b010) begin
	 b19=0;
end 
else if ({B[20:19],b18}==3'b101) begin 
	 b19=1;
end
else begin
	 b19=B[19];
end
if({B[21:20],b19}==3'b010) begin
	 b20=0;
end 
else if ({B[21:20],b19}==3'b101) begin 
	 b20=1;
end
else begin
	 b20=B[20];
end
if({B[22:21],b20}==3'b010) begin
	 b21=0;
end 
else if ({B[22:21],b20}==3'b101) begin 
	 b21=1;
end
else begin
	 b21=B[21];
end
if({B[23:22],b21}==3'b010) begin
	 b22=0;
end 
else if ({B[23:22],b21}==3'b101) begin 
	 b22=1;
end
else begin
	 b22=B[22];
end

if({1'b0,B[23],b22}==3'b010) begin
	 b23=0;
end 
else if ({1'b0,B[23],b22}==3'b101) begin 
	 b23=1;
end
else begin
	 b23=B[23];
end
end
//PARTIALPRODUCT P12({1'b0,A},{1'b0, B[23]}, TEMP[12]);



always@(*)
begin
C= ($signed(TEMP[0])+$signed(TEMP[1]<<<1)+$signed(TEMP[2]<<<2)+$signed(TEMP[3]<<<3)+$signed(TEMP[4]<<<4)+$signed(TEMP[5]<<<5)+$signed(TEMP[6]<<<6)+$signed(TEMP[7]<<<7)+$signed(TEMP[8]<<<8)+$signed(TEMP[9]<<<9)+$signed(TEMP[10]<<<10)+$signed(TEMP[11]<<<11)+$signed(TEMP[12]<<<12)+$signed(TEMP[13]<<<13)+$signed(TEMP[14]<<<14)+$signed(TEMP[15]<<<15)+$signed(TEMP[19]<<<19)+$signed(TEMP[16]<<<16)+$signed(TEMP[17]<<<17)+$signed(TEMP[18]<<<18)+$signed(TEMP[20]<<<20)+$signed(TEMP[21]<<<21)+$signed(TEMP[22]<<<22)+$signed(TEMP[23]<<<23)+$signed(TEMP[24]<<<24));
temp17=$signed(TEMP[17]<<<17);
temp19=$signed(TEMP[19]<<<19);
temp21=$signed(TEMP[21]<<<21);
a=C[49:0];
if(a[47]==1) begin
E=A_i[30:23]+B_i[30:23]-127+1;
M=a[46:24];
end 
else begin
E=A_i[30:23]+B_i[30:23]-127;
M=a[45:23];
end
if((A_i[31]==0&&B_i[31]==0) || (A_i[31]==1 && B_i[31]==1)) begin
	S=0;
end
else begin 
	S=1;
end
//E= 3*($signed(TEMP[0])+$signed(TEMP[1]<<<2)+$signed(TEMP[2]<<<4)+$signed(TEMP[3]<<<6)+$signed(TEMP[4]<<<8)+$signed(TEMP[5]<<<10)+$signed(TEMP[6]<<<12)+$signed(TEMP[7]<<<14));
//C=(D+(E/3))/2;
end
endmodule

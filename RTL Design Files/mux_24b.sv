
module Mux24(

    input [24:0] inputA,
    input [24:0] inputB,
    input sel,
	 output [24:0] Out
    );
	 
genvar i;

generate
 begin
  for(i=0;i<24;i = i + 1)
    Mux M(inputA[i],inputB[i],sel,Out[i]);
  end
endgenerate



assign Out[24] = (sel==1'b1) ? inputB[24] : inputA[24];

endmodule

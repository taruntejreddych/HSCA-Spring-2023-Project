module Mux_8(
    input [7:0] inputA,
    input [7:0] inputB,
    input sel,
    output [7:0] Out
    );
	 
 genvar j;
 
 generate 
  begin
   for(j=0;j<=7;j=j+1)
    begin
     Mux M(inputA[j],inputB[j],sel,Out[j]);
    end
   end
endgenerate

endmodule

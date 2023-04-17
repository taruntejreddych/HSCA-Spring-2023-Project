module Comp_24(
    input [23:0] inputA,
    output [23:0] Out
    );
	 
wire [23:0]w;
genvar j;

 generate
  begin
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
		begin
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

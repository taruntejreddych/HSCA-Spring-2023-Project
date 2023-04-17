module Complement2s(
    input [7:0] A,
    output [7:0] Out
    );
	 
wire [7:0]w;
genvar j;

 generate
  begin
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
		begin
			for(i=1;i<8;i=i+1)
			  begin
//			    FullAdder F1(w[i],1'b0,c[i-1],Out[i],c[i]);

				assign Out[i] = ((w[i] ^ 1'b0)) ^ c[i-1];
				assign c[i] = ((w[i] ^ 1'b0) & c[i-1]) | (w[i] & 1'b0);
			  end
		end
	endgenerate
	
endmodule

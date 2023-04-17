module Mux(
    input inputA,
    input inputB,
    input sel,
	 output Out
    );
	 
assign Out = (~sel & inputA) | (sel & inputB);


endmodule

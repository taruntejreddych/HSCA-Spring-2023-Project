module operand_man(a_i, b_i, a_i_oper, b_i_oper);
input [31:0] a_i;
input [31:0] b_i;
output reg [23:0] a_i_oper;
output reg [23:0] b_i_oper;
assign b_i_oper={1'b1, b_i[22:0]};
assign a_i_oper={1'b1, a_i[22:0]};
endmodule

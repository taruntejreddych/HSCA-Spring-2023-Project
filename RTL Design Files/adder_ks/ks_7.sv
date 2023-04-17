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

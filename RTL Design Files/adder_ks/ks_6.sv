module ks_6(
  input  wire        i_c0,
  input  wire [16:0] i_pk,
  input  wire [23:0] i_gk,
  input  wire [23:0] i_p_save,
  output wire        o_c0,
  output wire [23:0] o_pk,
  output wire [23:0] o_gk
);

wire [16:0] gkj;

assign o_c0       = i_c0;
assign o_pk       = i_p_save[23:0];
assign gkj[0]     = i_c0;
assign gkj[16:1]  = i_gk[15:0];
assign o_gk[15:0] = i_gk[15:0];

grey gc_1(gkj[1], i_pk[1], i_gk[16], o_gk[16]);
grey gc_2(gkj[2], i_pk[2], i_gk[17], o_gk[17]);
grey gc_3(gkj[3], i_pk[3], i_gk[18], o_gk[18]);
grey gc_4(gkj[4], i_pk[4], i_gk[19], o_gk[19]);
grey gc_5(gkj[5], i_pk[5], i_gk[20], o_gk[20]);
grey gc_6(gkj[6], i_pk[6], i_gk[21], o_gk[21]);
grey gc_7(gkj[7], i_pk[7], i_gk[22], o_gk[22]);
grey gc_8(gkj[8], i_pk[8], i_gk[23], o_gk[23]);

endmodule

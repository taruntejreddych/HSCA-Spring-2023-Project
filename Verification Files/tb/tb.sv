`timescale 1ns / 100ps
`include "uvm_macros.svh"

import uvm_pkg::*;
import modules_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;
import tests::*;



module top;    
dut_interface_in dut_intf_in();
dut_interface_out dut_intf_out();

initial begin
    dut_intf_in.clk<=1;
end
always begin
#5 dut_intf_in.clk<=~dut_intf_in.clk;
end

initial begin
    dut_intf_in.clk_fast<=1;
end
always begin
#0.1 dut_intf_in.clk_fast<=~dut_intf_in.clk_fast;
end

initial begin
    dut_intf_out.clk<=1;    
end

always begin
#5 dut_intf_out.clk<=~dut_intf_out.clk;
end

initial begin
dut_intf_in.start = 0;
end

always @(posedge dut_intf_in.clk) begin
//@(posedge dut_intf_in.clk_fast);
//@(posedge dut_intf_in.clk_fast);
dut_intf_in.start <=1;
@(posedge dut_intf_in.clk_fast);
dut_intf_in.start <= 0;
//repeat(50) begin
//@(posedge dut_intf_in.clk_fast);
//end
end




// TODO: Instantiate the dut module as dut1 and use the input as dut_in1 and output as dut_out1
FPalu alu(
.clk(dut_intf_in.clk),
.clk_fast(dut_intf_in.clk_fast),
.start(dut_intf_in.start),
.A(dut_intf_in.A),
.B(dut_intf_in.B),
.Cin(dut_intf_in.CIN),
.opcode(dut_intf_in.opcode),
.Out(dut_intf_out.OUT),
.ovf(dut_intf_out.VOUT),
.unf(dut_intf_out.underflow),
.dbz(dut_intf_out.div_by_zero),
.zbz(dut_intf_out.zero_by_zero)
);

//dut DUT_inst(._in(dut_intf_in), ._out(dut_intf_out));


initial begin
    uvm_config_db #(virtual dut_interface_in)::set(null,"uvm_test_top.*","dut_config_interafce_in",dut_intf_in);
    uvm_config_db #(virtual dut_interface_out)::set(null,"uvm_test_top.*","dut_config_interface_out",dut_intf_out);
    uvm_top.finish_on_completion=1;

    run_test("float_alu_test");  /////////////change diff tests
end

endmodule: top

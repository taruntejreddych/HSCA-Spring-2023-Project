`include "uvm_macros.svh"

package scoreboard; 
import uvm_pkg::*;
import sequences::*;

class float_alu_scoreboard_c extends uvm_scoreboard;
`uvm_component_utils(float_alu_scoreboard_c)

static real out_gold;
static real oper_A;
static real oper_B;
 
static logic vout_gold;
static real cin_dut;

static int diff;
static int pass_cnt = 0;
static int fail_cnt = 0;
static int total_cnt;
static real diff_in_outputs;
static logic underflow_gold;
static logic div_by_zero_gold;
static logic zero_by_zero_gold;


uvm_analysis_export #(float_alu_rand_item_in) scoreboard_port_in;
uvm_analysis_export #(float_alu_rand_item_out) scoreboard_port_out;

uvm_tlm_analysis_fifo #(float_alu_rand_item_in) fifo_port_in;
uvm_tlm_analysis_fifo #(float_alu_rand_item_out) fifo_port_out;

float_alu_rand_item_in tx_in;
float_alu_rand_item_out tx_out;

function new(string name, uvm_component parent);
		super.new(name,parent);
		tx_in=new("tx_in");
		tx_out=new("tx_out");
endfunction: new

function void build_phase(uvm_phase phase);
		scoreboard_port_in=new("scoreboard_port_in",this);
		scoreboard_port_out=new("scoreboard_port_out",this);
		fifo_port_in=new("fifo_port_in",this);
		fifo_port_out=new("fifo_port_out",this);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
		scoreboard_port_in.connect(fifo_port_in.analysis_export);
		scoreboard_port_out.connect(fifo_port_out.analysis_export);
endfunction: connect_phase

virtual function goldenoutput();
bit sign_A;
bit [7:0] exp_A;
bit [22:0] manti_A;
real sum_A = 0;
real sum_bias_A;
real manti_sum_A = 0;
real exponent_A;
real mantissa_A;
//real oper_A;
real div_A;
real numer_A;
real denom_A;

bit sign_B;
bit [7:0] exp_B;
bit [22:0] manti_B;
real sum_B = 0;
real sum_bias_B;
real manti_sum_B = 0;
real exponent_B;
real mantissa_B;
//real oper_B;
real div_B;
real numer_B;
real denom_B;

		if(tx_in.A == 0) 
                  oper_A = 0;
                else begin
                sign_A = tx_in.A[31];
                exp_A = tx_in.A[30:23];
                
                for(int i = 0;i<8;i++) begin
                       sum_A = sum_A + exp_A[i]*(2**i);
                end
                
                sum_bias_A = sum_A - 127;
                
                exponent_A = 2**sum_bias_A;                
                manti_A = tx_in.A[22:0];               
                for(int i = 1; i<=23; i++) begin
                        numer_A = manti_A[23-i];
                        denom_A = 2**i;                        
                        div_A = numer_A/denom_A;                        
                	manti_sum_A = manti_sum_A + div_A; 
                                           
                end
                
                mantissa_A = 1+manti_sum_A;
                if(sign_A == 1)
                	oper_A = (-1)*(exponent_A)*(mantissa_A);
                else
                	oper_A = 1*(exponent_A)*(mantissa_A);
                //$display("oper_A = %f input A = %b exp = %f\n",oper_A,tx_in.A,sum_A);
                end

                if(tx_in.B == 0)
                  oper_B = 0;
                else begin  
		sign_B = tx_in.B[31];
                exp_B = tx_in.B[30:23];
                
                for(int i = 0;i<8;i++) begin
                       sum_B = sum_B + exp_B[i]*(2**i);
                end
                
                sum_bias_B = sum_B - 127;
		
                exponent_B = 2**sum_bias_B;                
                manti_B = tx_in.B[22:0];               
                for(int i = 1; i<=23; i++) begin
                        numer_B = manti_B[23-i];
                        denom_B = 2**i;                        
                        div_B = numer_B/denom_B;                        
                	manti_sum_B = manti_sum_B + div_B;
			                        
                end
                
                mantissa_B = 1+manti_sum_B;
                if(sign_B == 1)
                	oper_B = (-1)*(exponent_B)*(mantissa_B);
                else
                	oper_B = 1*(exponent_B)*(mantissa_B);
                $display("oper_B = %f input B = %b exp = %f \n",oper_B,tx_in.B,sum_B);
                end 

		
cin_dut = tx_in.CIN;
if(tx_in.opcode == 3'b000) begin //add
//add
	
	if((sign_A == sign_B) && (sum_A == 255 && sum_B == 255))
		vout_gold = 1;
	else
		vout_gold = 0;
	
	out_gold = oper_A+oper_B + cin_dut;
	underflow_gold = 0;
	div_by_zero_gold = 0;
	zero_by_zero_gold = 0;
	
		
end

if(tx_in.opcode == 3'b001) begin //sub
	
	out_gold = oper_A - oper_B;
	underflow_gold = 0;
	div_by_zero_gold = 0;
	zero_by_zero_gold = 0;
	if((sign_A != sign_B) && (sum_A == 255 && sum_B == 255))
		vout_gold = 1;
	else
		vout_gold = 0;
	
end

if(tx_in.opcode == 3'b010) begin //mul
	
	out_gold = oper_A * oper_B;
   	
	underflow_gold = 0;
	div_by_zero_gold = 0;
	zero_by_zero_gold = 0;
	if(sum_A + sum_B -127 > 255)
		vout_gold = 1;
	else
		vout_gold = 0;
end

if(tx_in.opcode == 3'b011) begin //div
	out_gold = oper_A/oper_B;
        diff = sum_A - sum_B;
        if(diff <0)
        	diff =( -1)*diff;
        else
		diff = diff;
	if(diff + 127 > 254)
        	vout_gold = 1;
	else
		vout_gold = 0;
	
	/*if(diff < 1)
		underflow_gold = 1;
  	else
		underflow_gold = 0;*/
	if(oper_B == 0) begin
        	if(oper_A == 0) begin
			zero_by_zero_gold = 1;
			div_by_zero_gold = 1;
		end
		else begin
			div_by_zero_gold = 1;
			zero_by_zero_gold = 0;
		end
	end
	else begin
		div_by_zero_gold = 0;
		zero_by_zero_gold = 0;
	end
   		
end


if(tx_in.opcode == 3'b100) begin //shift

end

/*if(tx_in.opcode == 3'b101) begin //comparator
	if(sign_A > sign_B) begin
		less_than = 1;	
		greater_than = 0;
		equal_to = 0;
	end
	else if(sign_A<sign_B) n=begin
		greater_than = 1;
		less_than = 0;
		equal_to = 0;
	end
	else begin //signs equal
		if(sum_A > sum_B) begin
			if(sign_A == 1) begin//A and B negative
				less_than = 1;
				greater_than = 0;
				equal_to = 0;
			end
			else begin//A and B are positive
				greater_than = 1;
				less_than = 0;
				equal_to = 0;
			end		
		end
		else if(sum_A < sum_B) begin
			if(sign_A == 1) begin//A and B negative
				greater_than = 1;
				less_than = 0;
				equal_to = 0;
			end
			else begin//A and B are positive
				less_than = 1;
				greater_than = 0;
				equal_to = 0;
			end
		end
		else begin //exponents equal
			if(mantissa_A > mantissa_B) begin
				if(sign_A == 1) begin//A and B negative
					less_than = 1;
					greater_than = 0;
					equal_to = 0;
				end
			        else begin//A and B are positive
					greater_than = 1;
					less_than = 0;
					equal_to = 0;
				end
			end
			else if(mantissa_A < mantissa_B) begin
				if(sign_A == 1) begin//A and B negative
					greater_than = 1;
					less_than = 0;
					equal_to = 0;
				end
			 	else begin//A and B are positive
					less_than = 1;
					greater_than = 0;
					equal_to = 0;
				end
			end
			else begin
				equal_to = 1;
				less_than = 0;
				greater_than = 0;
			end
		end
	end
end*/


endfunction

virtual function compare_outputs();
bit sign_out;
bit [7:0] exp_out;
bit [22:0] manti_out;
real sum_out = 0;
real sum_bias_out;
real manti_sum_out = 0;
real exponent_out;
real mantissa_out;
real out_dut;
real div_out;
real numer_out;
real denom_out;		
		
		goldenoutput();
                




		sign_out = tx_out.OUT[31];
                exp_out = tx_out.OUT[30:23];
                
                for(int i = 0;i<8;i++) begin
                       sum_out = sum_out + exp_out[i]*(2**i);
                end
                
                sum_bias_out = sum_out - 127;
		
                exponent_out = 2**sum_bias_out;
		                
                manti_out = tx_out.OUT[22:0];               
                for(int i = 1; i<=23; i++) begin
                        numer_out = manti_out[23-i];
                        denom_out = 2**i;                        
                        div_out = numer_out/denom_out;                        
                	manti_sum_out = manti_sum_out + div_out;
			                        
                end
                
                mantissa_out = 1+manti_sum_out;
                if(sign_out == 1)
                	out_dut = (-1)*(exponent_out)*(mantissa_out);
                else
                	out_dut = 1*(exponent_out)*(mantissa_out);
                $display("out_dut = %f out = %b\n",out_dut,tx_out.OUT);

                
                
		

diff_in_outputs = out_dut - out_gold;
//mul - 0.0125
//add - 0.017

                if(diff_in_outputs >= -0.01 && diff_in_outputs <= 0.01 && (vout_gold==tx_out.VOUT) && (div_by_zero_gold == tx_out.div_by_zero) && (zero_by_zero_gold == tx_out.zero_by_zero)) begin
				pass_cnt = pass_cnt + 1;
				
				`uvm_info(get_type_name(), $sformatf("matching\n  OPCODE = %b A = %1.38f B = %1.38f CIN = %x\n EXPECTED OUTPUTS: OUT = %1.38f VOUT = %x div_by_zero = %x zero_by_zero = %x\n DUT OUTPUTS: OUT = %1.38f VOUT = %x  div_by_zero = %x zero_by_zero = %x\n", tx_in.opcode,oper_A,oper_B, tx_in.CIN, out_gold, vout_gold, div_by_zero_gold, zero_by_zero_gold,out_dut,tx_out.VOUT,tx_out.div_by_zero,tx_out.zero_by_zero),UVM_LOW)
		end
		else begin
				fail_cnt = fail_cnt + 1;
				`uvm_error(get_type_name(),$sformatf("not matching\n  OPCODE = %b A = %1.38f B = %1.38f CIN = %x\n EXPECTED OUTPUTS: OUT = %1.38f  VOUT = %x  div_by_zero = %x zero_by_zero = %x\n DUT OUTPUTS: OUT = %1.38f  VOUT = %x  div_by_zero = %x zero_by_zero = %x\n", tx_in.opcode, oper_A,oper_B, tx_in.CIN, out_gold,  vout_gold, div_by_zero_gold, zero_by_zero_gold,out_dut,tx_out.VOUT,tx_out.div_by_zero,tx_out.zero_by_zero))
		end
endfunction

task run();
		forever begin
				fifo_port_in.get(tx_in);
				
				fifo_port_out.get(tx_out);
				
				
				compare_outputs();
		end
endtask: run

virtual function void check_phase (uvm_phase phase);
if(fail_cnt == 0)
		`uvm_info(get_type_name(),"\n\t\t\t\t------------------------------TEST PASSED-------------------------------\n",UVM_LOW)
	else
		`uvm_info(get_type_name(),"\n\t\t\t\t------------------------------TEST FAILED-------------------------------\n",UVM_LOW)
total_cnt = pass_cnt + fail_cnt;
`uvm_info(get_type_name(),$sformatf("\nTotal tests run: %d\n Passed tests: %d\n Failed Tests: %d\n",total_cnt,pass_cnt,fail_cnt),UVM_LOW)
endfunction

 

endclass: float_alu_scoreboard_c



endpackage: scoreboard

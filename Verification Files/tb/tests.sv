package tests;
`include "uvm_macros.svh"

import modules_pkg::*;
import uvm_pkg::*;
import sequences::*;
import scoreboard::*;

class float_alu_test extends float_alu_base_test;
    `uvm_component_utils(float_alu_test)

float_alu_rand_item_in tx_pkt_item;
float_alu_random_sequence rand_seq;



    function new(string name, uvm_component parent);
        super.new(name,parent);
        tx_pkt_item = new("tx_pkt_item");
    endfunction: new

function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       rand_seq = float_alu_random_sequence::type_id::create("rand_seq");
    endfunction: build_phase
    
    task run_phase(uvm_phase phase);	
	phase.raise_objection(this);
    repeat(100) begin    
        assert( tx_pkt_item.randomize() with {
             //opcode == 3'b000;
             //A == 32'b10000000110110011100011111011101; //11.375
	     //B == 32'b10000000110110011100011111011101; //5.563
	     CIN == 0;
             
        });
        uvm_config_db #(float_alu_rand_item_in)::set(null, "uvm_test_top", "tx_pkt_item", tx_pkt_item);
        rand_seq.start(float_alu_env.float_alu_agent_in.float_alu_sequencer);
     end
	phase.drop_objection(this);
     $display("\n\n\n");
$display("\t\t\t///////////////////////////////////////////////////////////////////\n");
$display("\t\t\t-----------------------------------------------------------------------\n"); 
$display("\t\t\t ------------------------------TEST COMPLETED---------------------\n");
$display("\t\t\t-----------------------------------------------------------------------\n");
$display("\t\t\t/////////////////////////////////////////////////////////////////////\n");
    endtask: run_phase

    
endclass : float_alu_test



endpackage: tests

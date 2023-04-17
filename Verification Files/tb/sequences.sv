`include "uvm_macros.svh"

package sequences;

    import uvm_pkg::*;

    class float_alu_rand_item_in extends uvm_sequence_item;
         
        

        rand logic [31:0] A;
        rand logic [31:0] B;
        rand logic [2:0] opcode;
        
        rand logic CIN;

      function new(string name = "");
            super.new(name);
        endfunction: new

       `uvm_object_utils_begin(float_alu_rand_item_in)
        `uvm_field_int (A, UVM_DEFAULT)
        `uvm_field_int (B, UVM_DEFAULT)
        `uvm_field_int (opcode, UVM_DEFAULT)
        
        `uvm_field_int (CIN, UVM_DEFAULT)
       `uvm_object_utils_end

        
      //constraints
      constraint operand_1{
	//A >= 32'b00111111100000000000000000000000 && A<= 32'b11000011111111111111111111111111;
	A[30:23] >= 127 && A[30:23] <= 135;
	//A[30:23] == 255;
        //A[31] == 0;
      }

      constraint operand_2{
	//B >= 32'b00111111100000000000000000000000 && B<= 32'b11000011111111111111111111111111;
	B[30:23] >= 127 && B[30:23] <= 135;
	//B[30:23] == 255;
	//B == 0;
        //B[31] == 0;
      }

      constraint opcode_constraint{
	opcode inside {0,1,2,3};
      } 
    endclass: float_alu_rand_item_in


    class float_alu_rand_item_out extends uvm_sequence_item;
	
        function new(string name = "");
            super.new(name);
        endfunction: new;	

        logic [31:0] OUT;
        logic COUT;
        logic VOUT;
	logic underflow;
	logic div_by_zero;
	logic zero_by_zero;

          `uvm_object_utils_begin(float_alu_rand_item_out)
             `uvm_field_int (OUT, UVM_DEFAULT)
             `uvm_field_int (COUT, UVM_DEFAULT)
             `uvm_field_int (VOUT, UVM_DEFAULT)
	     `uvm_field_int (underflow, UVM_DEFAULT)
	     `uvm_field_int (div_by_zero, UVM_DEFAULT)
	     `uvm_field_int (zero_by_zero, UVM_DEFAULT)
        `uvm_object_utils_end

        
        
        

    endclass: float_alu_rand_item_out

    class float_alu_random_sequence extends uvm_sequence #(float_alu_rand_item_in);
        `uvm_object_utils(float_alu_random_sequence)
         `uvm_declare_p_sequencer(uvm_sequencer#(float_alu_rand_item_in))

        function new(string name = "");
            super.new(name);
        endfunction: new

        

        task body;
        
            float_alu_rand_item_in tx_pkt_item; 
            uvm_config_db #(float_alu_rand_item_in)::get(null, "uvm_test_top", "tx_pkt_item", tx_pkt_item);
             start_item(tx_pkt_item);            
            finish_item(tx_pkt_item);
          
            
        endtask: body
    endclass: float_alu_random_sequence 


    

endpackage: sequences

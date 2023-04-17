`include "uvm_macros.svh"

package coverage;
import sequences::*;
import uvm_pkg::*;

class alu_subscriber_in extends uvm_subscriber #(float_alu_rand_item_in);
    `uvm_component_utils(alu_subscriber_in)

    //TODO: Declare the transaction object to facilitate sampling and create covergroup and its corresponding coverpoints
    //Make sure to instantiate the covergroup inside the new function

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void write(float_alu_rand_item_in t);
       //TODO: Sample the created covergroup with the proper transaction object 
    endfunction: write

endclass: alu_subscriber_in

class alu_subscriber_out extends uvm_subscriber #(float_alu_rand_item_out);
    `uvm_component_utils(alu_subscriber_out)

    //TODO: Declare the transaction object to facilitate sampling and create covergroup and its corresponding coverpoints
    //Make sure to instantiate the covergroup inside the new function
   
function new(string name, uvm_component parent);
    super.new(name,parent);
endfunction: new

    function void write(float_alu_rand_item_out t);
       //TODO: Sample the created covergroup with the proper transaction object 
    endfunction: write

endclass: alu_subscriber_out

endpackage: coverage

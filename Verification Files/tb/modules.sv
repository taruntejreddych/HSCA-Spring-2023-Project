`include "uvm_macros.svh"

package modules_pkg;

import uvm_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;

typedef uvm_sequencer #(float_alu_rand_item_in) float_alu_sequencer_c;



class float_alu_driver_c extends uvm_driver#(float_alu_rand_item_in);
    `uvm_component_utils(float_alu_driver_c)

    
    virtual dut_interface_in dut_intf_in;
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(virtual dut_interface_in)::get(this, "", "dut_config_interafce_in", dut_intf_in));
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        float_alu_rand_item_in tx_pkt_in;
        
        @(posedge dut_intf_in.clk);
        
        seq_item_port.get(tx_pkt_in);
	//$display("in driver A = %b B = %b opcode = %b CIN = %b @ %t\n",tx_pkt_in.A,tx_pkt_in.B,tx_pkt_in.opcode,tx_pkt_in.CIN,$time);
                
                
		dut_intf_in.A <= tx_pkt_in.A;
		dut_intf_in.B <= tx_pkt_in.B;
		dut_intf_in.opcode <= tx_pkt_in.opcode;
		dut_intf_in.CIN <= tx_pkt_in.CIN;
        //$display("in driver after A = %b B = %b opcode = %b CIN = %b @ %t\n",tx_pkt_in.A,tx_pkt_in.B,tx_pkt_in.opcode,tx_pkt_in.CIN,$time);
               //@(posedge dut_intf_in.clk);
               //$display("time after delay in driver %t\n",$time);
                
         
                

      end
    endtask: run_phase

endclass: float_alu_driver_c

class float_alu_monitor_in_c extends uvm_monitor;
    `uvm_component_utils(float_alu_monitor_in_c)

    uvm_analysis_port #(float_alu_rand_item_in) mon_port;
    virtual dut_interface_in dut_intf_in;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        
        mon_port=new("mon_port",this);
        assert( uvm_config_db #(virtual dut_interface_in)::get(this, "", "dut_config_interafce_in", dut_intf_in) );
        

    endfunction: build_phase

    task run_phase(uvm_phase phase);
    @(posedge dut_intf_in.clk);
      forever
      begin

        float_alu_rand_item_in tx_mon;
        
        @(posedge dut_intf_in.clk_fast);
        //@(posedge dut_intf_in.clk);
        tx_mon = float_alu_rand_item_in::type_id::create("tx_mon");

	
		
		tx_mon.A = dut_intf_in.A;
		tx_mon.B = dut_intf_in.B;
		tx_mon.opcode = dut_intf_in.opcode;
		tx_mon.CIN = dut_intf_in.CIN;


//$display("in in_mon A = %b B = %b opcode = %b CIN = %b @ %t\n",tx_mon.A,tx_mon.B,tx_mon.opcode,tx_mon.CIN,$time);

                
        mon_port.write(tx_mon);
      @(posedge dut_intf_in.clk);
        
      end
    endtask: run_phase

endclass: float_alu_monitor_in_c


class float_alu_monitor_out_c extends uvm_monitor;
    `uvm_component_utils(float_alu_monitor_out_c)

    uvm_analysis_port #(float_alu_rand_item_out) mon_port;
    virtual dut_interface_out dut_intf_out;
    //virtual dut_interface_in dut_intf_in;
	

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        
        mon_port=new("mon_port",this);
        assert( uvm_config_db #(virtual dut_interface_out)::get(this, "", "dut_config_interface_out", dut_intf_out) );
         //assert( uvm_config_db #(virtual dut_interface_in)::get(this, "", "dut_config_interface_in", dut_intf_in) );
    endfunction: build_phase

    task run_phase(uvm_phase phase);
    @(posedge dut_intf_out.clk);
    //@(posedge dut_intf_out.clk); //changed
      forever
      begin
        float_alu_rand_item_out tx_mon;
        
        @(posedge dut_intf_out.clk);
        //#94;
        
        tx_mon = float_alu_rand_item_out::type_id::create("tx_mon");

        
		

		tx_mon.VOUT = dut_intf_out.VOUT;
		
		tx_mon.OUT = dut_intf_out.OUT;
		tx_mon.underflow = dut_intf_out.underflow;
		tx_mon.div_by_zero = dut_intf_out.div_by_zero;
		tx_mon.zero_by_zero = dut_intf_out.zero_by_zero;
         //$display("in out_mon VOUT = %b OUT = %x underflow = %b div_by_zero = %b zero_by_zero = %b  @ %t\n",tx_mon.VOUT,tx_mon.OUT,tx_mon.underflow,tx_mon.div_by_zero,tx_mon.zero_by_zero,$time);


        mon_port.write(tx_mon);
      end
    endtask: run_phase
endclass: float_alu_monitor_out_c

class float_alu_agent_active_c extends uvm_agent;
    `uvm_component_utils(float_alu_agent_active_c)

    uvm_analysis_port #(float_alu_rand_item_in) agent_port;

    float_alu_sequencer_c float_alu_sequencer;
    float_alu_driver_c float_alu_driver;
    float_alu_monitor_in_c float_alu_monitor_in;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        agent_port=new("agent_port",this);
        float_alu_sequencer=float_alu_sequencer_c::type_id::create("float_alu_sequencer",this);
        float_alu_driver=float_alu_driver_c::type_id::create("float_alu_driver",this);
        float_alu_monitor_in=float_alu_monitor_in_c::type_id::create("float_alu_monitor_in",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        float_alu_driver.seq_item_port.connect(float_alu_sequencer.seq_item_export);
        float_alu_monitor_in.mon_port.connect(agent_port);
    endfunction: connect_phase

endclass: float_alu_agent_active_c

class float_alu_agent_passive_c extends uvm_agent;
    `uvm_component_utils(float_alu_agent_passive_c)

    uvm_analysis_port #(float_alu_rand_item_out) agent_port;

    float_alu_monitor_out_c float_alu_monitor_out;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        agent_port=new("agent_port",this);
        float_alu_monitor_out=float_alu_monitor_out_c::type_id::create("float_alu_monitor_out",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        float_alu_monitor_out.mon_port.connect(agent_port);
    endfunction: connect_phase

endclass: float_alu_agent_passive_c


class float_alu_env_c extends uvm_env;
    `uvm_component_utils(float_alu_env_c)

    float_alu_agent_active_c float_alu_agent_in;
    float_alu_agent_passive_c float_alu_agent_out;
    
    float_alu_scoreboard_c float_alu_scoreboard;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        float_alu_agent_in = float_alu_agent_active_c::type_id::create("float_alu_agent_in",this);
        float_alu_agent_out = float_alu_agent_passive_c::type_id::create("float_alu_agent_out",this);
        float_alu_scoreboard = float_alu_scoreboard_c::type_id::create("float_alu_scoreboard",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        
        float_alu_agent_in.agent_port.connect(float_alu_scoreboard.scoreboard_port_in);
        float_alu_agent_out.agent_port.connect(float_alu_scoreboard.scoreboard_port_out);
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        
        uvm_report_info(get_type_name (), $sformatf("Debug level message"), 500);
    endfunction: start_of_simulation_phase

endclass: float_alu_env_c

class float_alu_base_test extends uvm_test;
    `uvm_component_utils(float_alu_base_test)

    
    float_alu_env_c float_alu_env;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       
        float_alu_env = float_alu_env_c::type_id::create("float_alu_env", this);
    endfunction: build_phase

   /*virtual function void report_phase(uvm_phase phase);
	int err_cnt,total_cnt,pass_cnt;
	err_cnt = float_alu_env.float_alu_agent_out.float_alu_monitor_out.dut_intf_out.fail_cnt;
	pass_cnt = float_alu_env.float_alu_agent_out.float_alu_monitor_out.dut_intf_out.pass_cnt; 
         
	if(err_cnt == 0)
		`uvm_info(get_type_name(),"TEST PASSED\n",UVM_LOW);
	else
		`uvm_info(get_type_name(),"TEST FAILED\n",UVM_LOW);
	total_cnt = pass_cnt + fail_cnt;
	`uvm_info(get_type_name(),$sformatf("Total tests run: %d Passed tests: %d Failed Tests: %d\n",total_cnt,pass_cnt,err_cnt),UVM_LOW)
		
   endfunction: report_phase*/


endclass:float_alu_base_test

endpackage: modules_pkg

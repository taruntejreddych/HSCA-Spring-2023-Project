# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the sources.
#vlog ../dut/ALU_netlist.v ../lib/gscl45nm.v
vlog ../dut/top.sv ../lib/gscl45nm.v
vlog +cover -sv ../tb/interfaces.sv  ../tb/sequences.sv ../tb/coverage.sv ../tb/scoreboard.sv ../tb/modules.sv ../tb/tests.sv  ../tb/tb.sv  
#vlog +cover -sv ../tb/interfaces.sv  ../tb/sequences.sv ../tb/scoreboard.sv ../tb/modules.sv ../tb/tests.sv  ../tb/tb.sv

#coverage -assert -directive -cvg -codeAll

# Simulate the design.
vsim -coverage -c top
run -all
exit

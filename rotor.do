vlib work
vlog -timescale 1ns/1ns rotor.v

vsim rotor
log {/*}
add wave {/*}


force {wiring_config[0]} 0
force {wiring_config[1]} 1
force {wiring_config[2]} 0
force {rotate} 0 0, 1 5 -r 10
force {in[0]} 1 0
force {in[1]} 0
force {in[2]} 0
force {in[3]} 0




run 1000
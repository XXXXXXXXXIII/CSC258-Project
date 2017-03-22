vlib work
vlog -timescale 1ns/1ns rero.v

vsim rero
log {/*}
add wave {/*}


force {wheel_config[0]} 0
force {wheel_config[1]} 0
force {wheel_config[2]} 0
force {in[0]} 0 0, 1 3 -r 5
force {in[1]} 0
force {in[2]} 0
force {in[3]} 0
force {in[4]} 0


run 1000
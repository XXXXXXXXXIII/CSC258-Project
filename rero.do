vlib work
vlog -timescale 1ns/1ns rero.v

vsim rero
log {/*}
add wave {/*}


force {wheel_config[0]} 0
force {wheel_config[1]} 0
force {wheel_config[2]} 0

force {in[12]} 1 0, 0 8
force {in[14]} 1 10, 0 18
force {in[13]} 1 20, 0 28
force {in[14]} 1 30, 0 38
force {in[22]} 1 40, 0 48
run 100